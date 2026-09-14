params
[
    "_muzzlePositionASL",
    "_projectileVelocity",
    "_listenerPositionASL",
    ["_speedOfSound", 343.0]
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

private _projectileSpeed =
    vectorMagnitude _projectileVelocity;

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
    _projectileSpeed /
    _speedOfSound;

private _muzzleArrival =
    _directDistance /
    _speedOfSound;

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

private _machRoot =
    sqrt
    (
        (_mach * _mach) - 1
    );


private _minimumDownrange =
    _crossTrackDistance /
    _machRoot;

private _isDistinct =
    _downrange >=
    _minimumDownrange;

if (!_isDistinct) exitWith
{
    [
        false,
        _downrange,
        _crossTrackDistance,
        _projectileSpeed,
        _mach,
        _minimumDownrange,
        _muzzleArrival,
        _muzzleArrival,
        0,
        _muzzlePositionASL
    ]
};


private _shockArrival =
    (
        _downrange +
        (
            _crossTrackDistance *
            _machRoot
        )
    ) /
    _projectileSpeed;

private _separation =
    (
        _muzzleArrival -
        _shockArrival
    )
    max
    0;

private _emissionDistance =
    _downrange -
    _minimumDownrange;

private _shockEmissionPosition =
    _muzzlePositionASL
    vectorAdd
    (
        _projectileAxis
        vectorMultiply
        _emissionDistance
    );

[
    true,
    _downrange,
    _crossTrackDistance,
    _projectileSpeed,
    _mach,
    _minimumDownrange,
    _muzzleArrival,
    _shockArrival,
    _separation,
    _shockEmissionPosition
]
