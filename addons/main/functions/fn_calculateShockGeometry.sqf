params
[
    "_muzzlePositionASL",
    "_projectileVelocity",
    "_listenerPositionASL",
    ["_speedOfSound", 343.0],
    ["_windVector", [0, 0, 0]]
];

if (
    (count _muzzlePositionASL) != 3 ||
    (count _projectileVelocity) != 3 ||
    (count _listenerPositionASL) != 3 ||
    _speedOfSound <= 0
) exitWith
{
    []
};

if ((count _windVector) != 3) then
{
    _windVector = [0, 0, 0];
};

private _projectileSpeed =
    vectorMagnitude _projectileVelocity;

private _airVelocity =
    _projectileVelocity vectorDiff _windVector;

private _airSpeed =
    vectorMagnitude _airVelocity;

if (_projectileSpeed <= 0) exitWith
{
    []
};

private _projectileAxis =
    vectorNormalized _projectileVelocity;

private _muzzleToListener =
    _listenerPositionASL
    vectorDiff
    _muzzlePositionASL;

private _directDistance =
    vectorMagnitude _muzzleToListener;

private _downrange =
    _muzzleToListener
    vectorDotProduct
    _projectileAxis;

private _axialComponent =
    _projectileAxis
    vectorMultiply
    _downrange;

private _crossTrackVector =
    _muzzleToListener
    vectorDiff
    _axialComponent;

private _crossTrackDistance =
    vectorMagnitude _crossTrackVector;

private _mach =
    _airSpeed /
    _speedOfSound;

private _muzzleTravel =
    [
        _muzzlePositionASL,
        _listenerPositionASL,
        _speedOfSound,
        _windVector
    ]
    call gau_gau8_fnc_getSoundTravelTime;

private _muzzleArrival =
    _muzzleTravel param
    [
        0,
        (_directDistance / _speedOfSound)
    ];

if (_mach <= 1) exitWith
{
    [
        false,
        _downrange,
        _crossTrackDistance,
        _projectileSpeed,
        _mach,
        -1,
        _muzzleArrival,
        _muzzleArrival,
        0,
        _muzzlePositionASL
    ]
};

private _evaluateCondition =
{
    params ["_time"];

    private _position =
        _muzzlePositionASL vectorAdd
        (
            _projectileVelocity vectorMultiply _time
        );

    private _travel =
        [
            _position,
            _listenerPositionASL,
            _speedOfSound,
            _windVector
        ]
        call gau_gau8_fnc_getSoundTravelTime;

    private _ray =
        _travel param [2, [0, 0, 0]];

    (
        _airVelocity
        vectorDotProduct
        _ray
    ) -
    _speedOfSound
};

private _initialCondition =
    [0]
    call _evaluateCondition;

if (_initialCondition <= 0) exitWith
{
    [
        false,
        _downrange,
        _crossTrackDistance,
        _projectileSpeed,
        _mach,
        0,
        _muzzleArrival,
        _muzzleArrival,
        0,
        _muzzlePositionASL
    ]
};

private _low = 0.0;
private _high = 0.01;
private _highCondition =
    [_high]
    call _evaluateCondition;

while
{
    _highCondition > 0 &&
    {_high < 6.0}
}
do
{
    _low = _high;
    _high = (_high * 2) min 6.0;
    _highCondition =
        [_high]
        call _evaluateCondition;
};

if (_highCondition > 0) exitWith
{
    [
        false,
        _downrange,
        _crossTrackDistance,
        _projectileSpeed,
        _mach,
        -1,
        _muzzleArrival,
        _muzzleArrival,
        0,
        _muzzlePositionASL
    ]
};

for "_iteration" from 0 to 17 do
{
    private _mid =
        (_low + _high) * 0.5;

    private _midCondition =
        [_mid]
        call _evaluateCondition;

    if (_midCondition > 0) then
    {
        _low = _mid;
    }
    else
    {
        _high = _mid;
    };
};

private _emissionTime =
    (_low + _high) * 0.5;

private _shockEmissionPosition =
    _muzzlePositionASL vectorAdd
    (
        _projectileVelocity
        vectorMultiply
        _emissionTime
    );

private _shockTravel =
    [
        _shockEmissionPosition,
        _listenerPositionASL,
        _speedOfSound,
        _windVector
    ]
    call gau_gau8_fnc_getSoundTravelTime;

private _shockArrival =
    _emissionTime +
    (
        _shockTravel param
        [
            0,
            0
        ]
    );

private _separation =
    (
        _muzzleArrival -
        _shockArrival
    )
    max 0;

private _emissionDistance =
    _projectileSpeed *
    _emissionTime;

[
    true,
    _downrange,
    _crossTrackDistance,
    _projectileSpeed,
    _mach,
    _emissionDistance,
    _muzzleArrival,
    _shockArrival,
    _separation,
    _shockEmissionPosition
]
