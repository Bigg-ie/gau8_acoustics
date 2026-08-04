/*
    Solve the earliest Mach-cone arrival from a projectile travelling at
    constant velocity from its current position.

    Return value:
    [
        distinctShock,
        listenerDownrangeMetres,
        listenerCrossTrackMetres,
        projectileSpeedMetresPerSecond,
        machNumber,
        minimumDownrangeForConeMetres,
        muzzleArrivalSeconds,
        shockArrivalSeconds,
        shockBeforeMuzzleSeconds,
        shockEmissionPositionASL
    ]
*/
params
[
    "_projectilePositionASL",
    "_projectileVelocity",
    "_listenerPositionASL",
    ["_soundSpeed", 343.0]
];

private _projectileSpeed = vectorMagnitude _projectileVelocity;
private _relative =
    _listenerPositionASL vectorDiff _projectilePositionASL;
private _muzzleDistance = vectorMagnitude _relative;
private _muzzleArrival = _muzzleDistance / _soundSpeed;

if (
    _projectileSpeed <= (_soundSpeed * 1.001) ||
    {_muzzleDistance <= 0.001}
) exitWith
{
    [
        false,
        0,
        _muzzleDistance,
        _projectileSpeed,
        _projectileSpeed / _soundSpeed,
        0,
        _muzzleArrival,
        _muzzleArrival,
        0,
        +_projectilePositionASL
    ]
};

private _direction =
    _projectileVelocity vectorMultiply (1 / _projectileSpeed);
private _downrange = _relative vectorDotProduct _direction;
private _relativeSquared = _relative vectorDotProduct _relative;
private _crossTrackSquared =
    (_relativeSquared - (_downrange * _downrange)) max 0;
private _crossTrack = sqrt _crossTrackSquared;
private _mach = _projectileSpeed / _soundSpeed;
private _machRoot = sqrt ((_mach * _mach) - 1);

/*
    At the stationary-phase point, the listener lies on the projectile's
    Mach cone. This is the minimum forward displacement required before a
    shock emitted by the projectile can reach the listener.
*/
private _minimumDownrange = _crossTrack / _machRoot;
private _projectileTravel = _downrange - _minimumDownrange;
private _distinct = _projectileTravel >= 0;

private _shockEmissionPosition =
    if (_distinct) then
    {
        _projectilePositionASL vectorAdd
        (_direction vectorMultiply _projectileTravel)
    }
    else
    {
        +_projectilePositionASL
    };

private _shockArrival = _muzzleArrival;
private _separation = 0;

if (_distinct) then
{
    private _shockSlantDistance =
        _listenerPositionASL vectorDistance _shockEmissionPosition;

    _shockArrival =
        (_projectileTravel / _projectileSpeed) +
        (_shockSlantDistance / _soundSpeed);

    _separation = _muzzleArrival - _shockArrival;
    _distinct = _separation > 0.001;
};

[
    _distinct,
    _downrange,
    _crossTrack,
    _projectileSpeed,
    _mach,
    _minimumDownrange,
    _muzzleArrival,
    _shockArrival,
    _separation,
    _shockEmissionPosition
]
