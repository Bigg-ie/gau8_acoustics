/*
    Calculates ideal constant-velocity Mach-cone geometry.

    Parameters:
        0: Muzzle position, PositionASL
        1: Initial projectile velocity, Vector3D in m/s
        2: Listener position, PositionASL
        3: Speed of sound in m/s; default 343

    Returns:
        0: Distinct shock is geometrically eligible
        1: Listener distance downrange along projectile axis
        2: Listener perpendicular distance from projectile axis
        3: Projectile speed
        4: Mach number
        5: Minimum downrange distance for a distinct shock
        6: Muzzle-report arrival time
        7: Shock arrival time
        8: Shock-to-muzzle separation time
        9: Retarded shock-emission position, PositionASL
*/

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

/*
    A distinct shock requires a non-negative retarded
    emission point after the projectile leaves the muzzle.

        x >= d / sqrt(M^2 - 1)
*/
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

/*
    Retarded-time arrival of the Mach front:

        t_shock =
            (x + d * sqrt(M^2 - 1)) / v
*/
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
