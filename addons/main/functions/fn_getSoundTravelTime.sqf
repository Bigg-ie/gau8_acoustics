params
[
    "_sourcePositionASL",
    "_listenerPositionASL",
    ["_soundSpeed", 343.0],
    ["_windVector", [0, 0, 0]]
];

if (
    (count _sourcePositionASL) != 3 ||
    {(count _listenerPositionASL) != 3}
) exitWith
{
    [0, 343.0, [0, 0, 0], 0]
};

if ((count _windVector) != 3) then
{
    _windVector = [0, 0, 0];
};

_soundSpeed =
    _soundSpeed
    max 1;

private _displacement =
    _listenerPositionASL
    vectorDiff
    _sourcePositionASL;

private _distance =
    vectorMagnitude _displacement;

if (_distance <= 0.001) exitWith
{
    [
        0,
        _soundSpeed,
        [0, 0, 0],
        0
    ]
};

private _windSquared =
    _windVector vectorDotProduct _windVector;

private _cSquared =
    _soundSpeed * _soundSpeed;

private _denominator =
    _cSquared - _windSquared;

if (_denominator <= 1.0) exitWith
{
    private _ray =
        _displacement vectorMultiply
        (1 / _distance);

    [
        _distance / _soundSpeed,
        _soundSpeed,
        _ray,
        _distance
    ]
};

private _displacementDotWind =
    _displacement
    vectorDotProduct
    _windVector;

private _discriminant =
    (
        _displacementDotWind *
        _displacementDotWind
    ) +
    (
        _denominator *
        _distance *
        _distance
    );

private _travelTime =
    (
        (
            -_displacementDotWind +
            sqrt (_discriminant max 0)
        ) /
        _denominator
    )
    max 0;

if (_travelTime <= 0.000001) exitWith
{
    private _ray =
        _displacement vectorMultiply
        (1 / _distance);

    [
        _distance / _soundSpeed,
        _soundSpeed,
        _ray,
        _distance
    ]
};

private _mediumDisplacement =
    _displacement vectorDiff
    (
        _windVector vectorMultiply _travelTime
    );

private _mediumDistance =
    vectorMagnitude _mediumDisplacement;

private _mediumRay =
    if (_mediumDistance > 0.000001) then
    {
        _mediumDisplacement vectorMultiply
        (1 / _mediumDistance)
    }
    else
    {
        _displacement vectorMultiply
        (1 / _distance)
    };

private _effectiveGroundSpeed =
    _distance / _travelTime;

[
    _travelTime,
    _effectiveGroundSpeed,
    _mediumRay,
    _distance
]
