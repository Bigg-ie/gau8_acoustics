/*
    Returns the listener/source geometry and the runtime mix for one
    emitted GAU-8 event.

    Return value:
    [
        listenerPositionASL,
        emissionPositionASL,
        distanceMetres,
        propagationDelaySeconds,
        distanceGain,
        closeBodyGain,
        midBodyGain,
        farBodyGain,
        mechanicalGain,
        muzzleGain,
        forwardDot
    ]
*/
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

/*
    Game-calibrated pressure envelope.

    The near field is deliberately compressed relative to literal 1/r
    propagation so the cannon can be forceful without consuming the whole
    game mix. The close/far recordings provide timbre; this curve controls
    absolute level.
*/
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

/*
    Three-zone spectral model.

    0-150 m:
        Accepted close recording only.

    150-500 m:
        Constant-sum close-to-mid transition. The mid assets are filtered
        derivatives of the close source, so constant-sum mixing avoids
        correlated reinforcement.

    500-800 m:
        Equal-power mid-to-far transition. The far recording is independent,
        so square-root weights prevent the usual -3 dB midpoint dip.
*/
private _closeToMid =
    linearConversion
    [
        150,
        500,
        _distance,
        0,
        1,
        true
    ];

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

/*
    Mechanical texture remains local. Its files already sit roughly 17 dB
    below the body, and this presence curve removes it completely by 250 m.
*/
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

private _toListener =
    if (_distance > 0.01) then
    {
        _emissionPositionASL vectorFromTo _listenerPositionASL
    }
    else
    {
        vectorDir _vehicle
    };

private _forward = vectorDir _vehicle;
private _forwardDot =
    ((_forward vectorDotProduct _toListener) max -1) min 1;

/*
    First-order directivity. The sustained body remains broad; the initial
    muzzle-pressure transient is more forward-biased.
*/
private _bodyDirectivity =
    linearConversion
    [
        -1,
        1,
        _forwardDot,
        0.95,
        1.00,
        true
    ];

private _muzzleDirectivity =
    linearConversion
    [
        -1,
        1,
        _forwardDot,
        0.65,
        1.00,
        true
    ];

private _closeBodyGain =
    _distanceGain * _closeWeight * _bodyDirectivity * 1.25;

/*
    Mid files are rendered 1 dB below the close files to retain headroom.
    The 1.12 multiplier restores nominal crossover loudness.
*/
private _midBodyGain =
    _distanceGain * _midWeight * _bodyDirectivity * 1.12;

private _farBodyGain =
    _distanceGain * _farWeight * _bodyDirectivity;

private _mechanicalGain =
    _distanceGain * _mechanicalPresence * 0.35;

private _muzzleGain =
    _distanceGain * _closeWeight * _muzzleDirectivity * 0.90;

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
    _forwardDot
]
