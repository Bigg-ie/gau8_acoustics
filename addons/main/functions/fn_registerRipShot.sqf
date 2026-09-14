params
[
    ["_vehicle", objNull],
    ["_projectile", objNull]
];

if (
    !hasInterface ||
    {isNull _vehicle} ||
    {isNull _projectile} ||
    {isNull player}
) exitWith
{
    false
};

private _sourcePositionASL = getPosASL _projectile;
private _sourceVelocity = velocity _projectile;
private _sourceSpeed = vectorMagnitude _sourceVelocity;

private _soundSpeed =
    (
        missionNamespace getVariable
        [
            "gau_gau8_speedOfSound",
            343
        ]
    )
    max 300
    min 360;

if (_sourceSpeed <= (_soundSpeed * 1.05)) exitWith
{
    false
};

private _listenerPositionASL = eyePos player;

private _sourceDirection =
    _sourceVelocity vectorMultiply
    (1 / _sourceSpeed);

private _listenerDelta =
    _listenerPositionASL vectorDiff _sourcePositionASL;

private _alongTrack =
    _listenerDelta vectorDotProduct _sourceDirection;

private _perpendicular =
    _listenerDelta vectorDiff
    (
        _sourceDirection vectorMultiply _alongTrack
    );

private _initialCrossTrack =
    vectorMagnitude _perpendicular;

private _maxCrossTrack =
    _vehicle getVariable
    [
        "gau_gau8_ripMaxCrossTrack",
        1200
    ];

if (_initialCrossTrack > (_maxCrossTrack * 1.08)) exitWith
{
    false
};

private _sourceMach = _sourceSpeed / _soundSpeed;
private _sourceMachRoot =
    sqrt ((_sourceMach * _sourceMach) - 1);

if (_sourceMachRoot <= 0.0001) exitWith
{
    false
};

private _constantVelocityEmissionDelay =
    (
        _alongTrack -
        (_initialCrossTrack / _sourceMachRoot)
    ) / _sourceSpeed;

private _maxEmissionDelay =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripMaxEmissionDelay",
            4.0
        ]
    )
    max 0.25
    min 6.0;

if (_constantVelocityEmissionDelay < -0.08) exitWith
{
    false
};

private _ammoClass = typeOf _projectile;
private _ammoConfig =
    configFile >> "CfgAmmo" >> _ammoClass;

private _airFriction =
    getNumber (_ammoConfig >> "airFriction");

private _coefGravity =
    getNumber (_ammoConfig >> "coefGravity");

private _gravityAcceleration =
[
    0,
    0,
    -9.80665 * _coefGravity
];

private _integrationStep =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripBallisticStep",
            0.010
        ]
    )
    max 0.005
    min 0.025;

private _evaluateMachCondition =
{
    params ["_positionASL", "_velocity"];

    private _toListener =
        _listenerPositionASL vectorDiff _positionASL;

    private _distance =
        vectorMagnitude _toListener;

    if (_distance <= 0.01) exitWith
    {
        -1e9
    };

    private _ray =
        _toListener vectorMultiply
        (1 / _distance);

    (_velocity vectorDotProduct _ray) - _soundSpeed
};

private _previousPosition = +_sourcePositionASL;
private _previousVelocity = +_sourceVelocity;

private _previousCondition =
    [
        _previousPosition,
        _previousVelocity
    ]
    call _evaluateMachCondition;

if (_previousCondition <= 0) exitWith
{
    false
};

private _previousTime = 0.0;
private _solved = false;
private _becameSubsonic = false;
private _emissionTravelTime = -1.0;
private _emissionPositionASL = [];
private _emissionVelocity = [];

while
{
    !_solved &&
    {!_becameSubsonic} &&
    {_previousTime < _maxEmissionDelay}
}
do
{
    private _dt =
        _integrationStep min
        (_maxEmissionDelay - _previousTime);

    private _previousSpeed =
        vectorMagnitude _previousVelocity;

    private _acceleration0 =
        (
            _previousVelocity vectorMultiply
            (_airFriction * _previousSpeed)
        )
        vectorAdd _gravityAcceleration;

    private _midVelocity =
        _previousVelocity vectorAdd
        (_acceleration0 vectorMultiply (_dt * 0.5));

    private _midSpeed =
        vectorMagnitude _midVelocity;

    private _accelerationMid =
        (
            _midVelocity vectorMultiply
            (_airFriction * _midSpeed)
        )
        vectorAdd _gravityAcceleration;

    private _nextPosition =
        _previousPosition vectorAdd
        (_midVelocity vectorMultiply _dt);

    private _nextVelocity =
        _previousVelocity vectorAdd
        (_accelerationMid vectorMultiply _dt);

    private _nextSpeed =
        vectorMagnitude _nextVelocity;

    private _nextTime =
        _previousTime + _dt;

    if (_nextSpeed <= (_soundSpeed * 1.0005)) then
    {
        _becameSubsonic = true;
    }
    else
    {
        private _nextCondition =
            [
                _nextPosition,
                _nextVelocity
            ]
            call _evaluateMachCondition;

        if (
            _previousCondition >= 0 &&
            {_nextCondition <= 0}
        ) then
        {
            private _denominator =
                _previousCondition - _nextCondition;

            private _fraction =
                if (abs _denominator > 0.000001) then
                {
                    (_previousCondition / _denominator)
                    max 0
                    min 1
                }
                else
                {
                    0.5
                };

            _emissionTravelTime =
                _previousTime + (_dt * _fraction);

            _emissionPositionASL =
                _previousPosition vectorAdd
                (
                    (
                        _nextPosition vectorDiff _previousPosition
                    )
                    vectorMultiply _fraction
                );

            _emissionVelocity =
                _previousVelocity vectorAdd
                (
                    (
                        _nextVelocity vectorDiff _previousVelocity
                    )
                    vectorMultiply _fraction
                );

            _solved = true;
        }
        else
        {
            _previousPosition = +_nextPosition;
            _previousVelocity = +_nextVelocity;
            _previousCondition = _nextCondition;
            _previousTime = _nextTime;
        };
    };
};

if (
    !_solved ||
    {(count _emissionPositionASL) != 3} ||
    {(count _emissionVelocity) != 3}
) exitWith
{
    false
};

private _emissionSpeed =
    vectorMagnitude _emissionVelocity;

if (_emissionSpeed <= (_soundSpeed * 1.0005)) exitWith
{
    false
};

private _emissionMach =
    _emissionSpeed / _soundSpeed;

private _machAngleDegrees =
    asin
    (
        (1 / _emissionMach)
        max -1
        min 1
    );

private _emissionDirection =
    _emissionVelocity vectorMultiply
    (1 / _emissionSpeed);

private _emissionListenerDelta =
    _listenerPositionASL vectorDiff
    _emissionPositionASL;

private _emissionAlongTrack =
    _emissionListenerDelta
    vectorDotProduct _emissionDirection;

private _emissionPerpendicular =
    _emissionListenerDelta vectorDiff
    (
        _emissionDirection vectorMultiply
        _emissionAlongTrack
    );

private _crossTrack =
    vectorMagnitude _emissionPerpendicular;

if (_crossTrack > _maxCrossTrack) exitWith
{
    false
};

private _emissionDistance =
    vectorMagnitude
    (
        _listenerPositionASL vectorDiff
        _emissionPositionASL
    );

private _maxDistance =
    _vehicle getVariable
    [
        "gau_gau8_ripMaxDistance",
        4000
    ];

if (_emissionDistance > _maxDistance) exitWith
{
    false
};

private _nowTick = diag_tickTime;
private _eventTime =
    _nowTick + _emissionTravelTime;

_vehicle setVariable ["gau_gau8_ripLastShotTick", _nowTick];
_vehicle setVariable ["gau_gau8_ripEventPositionASL", +_emissionPositionASL];
_vehicle setVariable ["gau_gau8_ripEventTime", _eventTime];
_vehicle setVariable ["gau_gau8_ripProjectileSpeed", _emissionSpeed];
_vehicle setVariable ["gau_gau8_ripEmissionVelocity", +_emissionVelocity];
_vehicle setVariable ["gau_gau8_ripEmissionMach", _emissionMach];
_vehicle setVariable ["gau_gau8_ripMachAngleDegrees", _machAngleDegrees];
_vehicle setVariable ["gau_gau8_ripCrossTrack", _crossTrack];


_vehicle setVariable
[
    "gau_gau8_ripEventGeometry",
    [
        +_emissionPositionASL,
        _eventTime,
        _crossTrack,
        _emissionDistance,
        _nowTick,
        +_emissionVelocity,
        _soundSpeed,
        _emissionSpeed,
        _emissionMach,
        _machAngleDegrees,
        _emissionTravelTime,
        _airFriction,
        _coefGravity,
        _sourceSpeed,
        _constantVelocityEmissionDelay
    ]
];

missionNamespace setVariable
[
    "gau_gau8_lastRipGeometry",
    [
        _vehicle,
        _ammoClass,
        +_sourcePositionASL,
        +_listenerPositionASL,
        _sourceSpeed,
        _sourceMach,
        _alongTrack,
        _initialCrossTrack,
        _constantVelocityEmissionDelay,
        _emissionTravelTime,
        +_emissionPositionASL,
        +_emissionVelocity,
        _emissionSpeed,
        _emissionMach,
        _machAngleDegrees,
        _crossTrack,
        _eventTime,
        _emissionDistance,
        _airFriction,
        _coefGravity,
        _integrationStep
    ]
];

if (
    _vehicle getVariable
    [
        "gau_gau8_debugRipBallistics",
        false
    ]
) then
{
    private _lastDebugTick =
        _vehicle getVariable
        [
            "gau_gau8_lastRipBallisticsDebugTick",
            -100
        ];

    if ((_nowTick - _lastDebugTick) > 0.25) then
    {
        _vehicle setVariable
        [
            "gau_gau8_lastRipBallisticsDebugTick",
            _nowTick
        ];

        diag_log
        format
        [
            "GAU-8 ballistic emission: ammo=%1 source=%2m/s emit=%3m/s M=%4 angle=%5deg t=%6s cross=%7m drag=%8 g=%9",
            _ammoClass,
            round _sourceSpeed,
            round _emissionSpeed,
            _emissionMach toFixed 3,
            _machAngleDegrees toFixed 2,
            _emissionTravelTime toFixed 4,
            round _crossTrack,
            _airFriction,
            _coefGravity
        ];
    };
};

private _running =
    _vehicle getVariable
    [
        "gau_gau8_ripStreamRunning",
        false
    ];

if (!_running) then
{
    _vehicle setVariable
    [
        "gau_gau8_ripStreamRunning",
        true
    ];

    private _generation =
        _vehicle getVariable
        [
            "gau_gau8_handlerGeneration",
            -1
        ];

    [
        _vehicle,
        _generation
    ]
    spawn gau_gau8_fnc_runRipStream;
};

true
