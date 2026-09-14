params
[
    "_vehicle",
    ["_projectile", objNull]
];

private _listenerPositionASL =
    AGLToASL
    (
        positionCameraToWorld [0, 0, 0]
    );

private _emissionPositionASL =
    if (!isNull _projectile) then
    {
        getPosASL _projectile
    }
    else
    {
        getPosASL _vehicle
    };

private _distance =
    _listenerPositionASL vectorDistance _emissionPositionASL;

private _sampleCurve =
{
    params
    [
        "_x",
        "_points"
    ];

    private _pointCount = count _points;

    if (_pointCount == 0) exitWith
    {
        0
    };

    private _first = _points select 0;

    if (_x <= (_first select 0)) exitWith
    {
        _first select 1
    };

    private _last = _points select (_pointCount - 1);
    private _value = _last select 1;
    private _index = 1;

    while {_index < _pointCount} do
    {
        private _lower = _points select (_index - 1);
        private _upper = _points select _index;

        if (_x <= (_upper select 0)) exitWith
        {
            _value = linearConversion
            [
                _lower select 0,
                _upper select 0,
                _x,
                _lower select 1,
                _upper select 1,
                true
            ];
        };

        _index = _index + 1;
    };

    _value
};


private _distanceGain =
    [
        _distance,
        [
            [0,     3.000],
            [30,    3.000],
            [50,    2.400],
            [100,   1.600],
            [150,   1.180],
            [200,   0.920],
            [350,   0.660],
            [500,   0.500],
            [600,   0.420],
            [1000,  0.280],
            [2000,  0.160],
            [5000,  0.070],
            [10000, 0.035],
            [20000, 0.016],
            [30000, 0.010],
            [50000, 0.004],
            [55000, 0.000]
        ]
    ]
    call _sampleCurve;


private _closeToMid =
    [
        _distance,
        [
            [0,   0.00],
            [25,  0.00],
            [50,  0.10],
            [75,  0.30],
            [100, 0.50],
            [140, 0.72],
            [190, 0.90],
            [250, 1.00]
        ]
    ]
    call _sampleCurve;

private _midToFar =
    linearConversion
    [
        500,
        800,
        _distance,
        0,
        1,
        true
    ];

private _closeWeight =
    if (_distance < 500) then
    {
        1 - _closeToMid
    }
    else
    {
        0
    };

private _midWeight =
    if (_distance < 500) then
    {
        _closeToMid
    }
    else
    {
        sqrt (1 - _midToFar)
    };

private _farWeight =
    if (_distance <= 500) then
    {
        0
    }
    else
    {
        sqrt _midToFar
    };


private _mechanicalPresence =
    [
        _distance,
        [
            [0, 1.00],
            [50, 1.00],
            [100, 0.50],
            [150, 0.20],
            [250, 0.00]
        ]
    ]
    call _sampleCurve;


private _cameraObject = cameraOn;
private _cameraVehicle =
    if (isNull _cameraObject) then
    {
        objNull
    }
    else
    {
        vehicle _cameraObject
    };

private _cameraMode = toUpper cameraView;

private _cockpitTarget =
    (_cameraVehicle isEqualTo _vehicle) &&
    {_cameraMode in ["INTERNAL", "GUNNER"]};

private _targetCockpitMix = parseNumber _cockpitTarget;

private _shotCount =
    _vehicle getVariable
    [
        "gau_gau8_shotCount",
        0
    ];

private _previousCockpitMix =
    _vehicle getVariable
    [
        "gau_gau8_cockpitMix",
        _targetCockpitMix
    ];

private _cockpitMix =
    if (_shotCount == 0) then
    {
        _targetCockpitMix
    }
    else
    {
        _previousCockpitMix +
        ((_targetCockpitMix - _previousCockpitMix) * 0.28)
    };

_cockpitMix = (_cockpitMix max 0) min 1;

_vehicle setVariable
[
    "gau_gau8_cockpitMix",
    _cockpitMix
];

private _externalMix = 1 - _cockpitMix;

private _cockpitMaster =
    (
        _vehicle getVariable
        [
            "gau_gau8_cockpitMaster",
            1.0
        ]
    ) max 0 min 2;

private _cockpitBodyGain =
    _cockpitMix * _cockpitMaster;

private _cockpitAirframeGain =
    _cockpitMix * _cockpitMaster;

private _toListener =
    if (_distance > 0.01) then
    {
        _emissionPositionASL vectorFromTo _listenerPositionASL
    }
    else
    {
        vectorDir _vehicle
    };


private _sourceForward = vectorDir _vehicle;

if (!isNull _projectile) then
{
    private _projectileVelocity = velocity _projectile;

    if ((vectorMagnitude _projectileVelocity) > 50) then
    {
        _sourceForward = vectorNormalized _projectileVelocity;
    };
};

private _forwardDot =
    ((_sourceForward vectorDotProduct _toListener) max -1) min 1;

private _offAxisAngle = acos _forwardDot;


private _closeBodyDirectivity =
    [
        _offAxisAngle,
        [
            [0,   1.10],
            [30,  1.08],
            [60,  1.00],
            [90,  0.88],
            [120, 0.78],
            [150, 0.70],
            [180, 0.66]
        ]
    ]
    call _sampleCurve;

private _midBodyDirectivity =
    [
        _offAxisAngle,
        [
            [0,   1.06],
            [30,  1.04],
            [60,  1.00],
            [90,  0.92],
            [120, 0.84],
            [150, 0.79],
            [180, 0.76]
        ]
    ]
    call _sampleCurve;

private _farBodyDirectivity =
    [
        _offAxisAngle,
        [
            [0,   1.03],
            [30,  1.02],
            [60,  1.00],
            [90,  0.97],
            [120, 0.94],
            [150, 0.92],
            [180, 0.90]
        ]
    ]
    call _sampleCurve;

private _mechanicalDirectivity = 1.00;


private _muzzleDirectivity =
    [
        _offAxisAngle,
        [
            [0,   1.35],
            [15,  1.30],
            [30,  1.15],
            [60,  0.85],
            [90,  0.55],
            [120, 0.35],
            [150, 0.22],
            [180, 0.18]
        ]
    ]
    call _sampleCurve;


private _terrainOcclusion = 0.0;
private _objectOcclusion = 0.0;
private _combinedOcclusion = 0.0;
private _reflectionPresence = 0.0;
private _reflectionPositionASL = +_emissionPositionASL;
private _reflectionPropagationDelay = _distance / 343.0;
private _reflectionExtraDelay = 0.0;
private _sourceHeightAGL = 0.0;
private _listenerHeightAGL = 0.0;
private _objectHitCount = 0;
private _baseCloseBodyGain =
    _distanceGain * _closeWeight * _closeBodyDirectivity * 1.25 * _externalMix;


private _baseMidBodyGain =
    _distanceGain * _midWeight * _midBodyDirectivity * 1.12 * _externalMix;

private _baseFarBodyGain =
    _distanceGain * _farWeight * _farBodyDirectivity * _externalMix;

private _baseMechanicalGain =
    _distanceGain * _mechanicalPresence * _mechanicalDirectivity * 0.35 * _externalMix;

private _baseMuzzleGain =
    _distanceGain * _closeWeight * _muzzleDirectivity * 0.90 * _externalMix;


private _closeBodyGain = _baseCloseBodyGain;
private _midBodyGain = _baseMidBodyGain;
private _farBodyGain = _baseFarBodyGain;
private _mechanicalGain = _baseMechanicalGain;
private _muzzleGain = _baseMuzzleGain;


private _reflectionGain = 0.0;

[
    _listenerPositionASL,
    _emissionPositionASL,
    _distance,
    _distance / 343.0,
    _distanceGain,
    _closeBodyGain,
    _midBodyGain,
    _farBodyGain,
    _mechanicalGain,
    _muzzleGain,
    _forwardDot,
    _offAxisAngle,
    _closeBodyDirectivity,
    _midBodyDirectivity,
    _farBodyDirectivity,
    _mechanicalDirectivity,
    _muzzleDirectivity,
    _cameraMode,
    _cockpitTarget,
    _cockpitMix,
    _externalMix,
    _cockpitBodyGain,
    _cockpitAirframeGain,
    _terrainOcclusion,
    _objectOcclusion,
    _combinedOcclusion,
    _reflectionGain,
    _reflectionPositionASL,
    _reflectionPropagationDelay,
    _reflectionExtraDelay,
    _sourceHeightAGL,
    _listenerHeightAGL,
    _objectHitCount
]
