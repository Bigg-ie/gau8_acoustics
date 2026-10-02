params
[
    "_vehicle",
    ["_smooth", false]
];

private _cameraObject = cameraOn;

private _listenerVehicle =
    if (isNull _cameraObject) then
    {
        if (!isNull player) then
        {
            vehicle player
        }
        else
        {
            objNull
        }
    }
    else
    {
        vehicle _cameraObject
    };

private _cameraMode = toUpper cameraView;

private _sameSourceVehicle =
    !isNull _listenerVehicle &&
    {_listenerVehicle isEqualTo _vehicle};

private _interiorTarget =
    _sameSourceVehicle &&
    {_cameraMode in ["INTERNAL", "GUNNER"]};

private _targetInteriorMix = parseNumber _interiorTarget;
private _interiorMix = _targetInteriorMix;

if (_smooth) then
{
    private _shotCount =
        _vehicle getVariable
        [
            "gau_gau8_shotCount",
            0
        ];

    private _previousInteriorMix =
        _vehicle getVariable
        [
            "gau_gau8_interiorMix",
            _vehicle getVariable
            [
                "gau_gau8_cockpitMix",
                _targetInteriorMix
            ]
        ];

    _interiorMix =
        if (_shotCount == 0) then
        {
            _targetInteriorMix
        }
        else
        {
            _previousInteriorMix +
            ((_targetInteriorMix - _previousInteriorMix) * 0.28)
        };

    _interiorMix = (_interiorMix max 0) min 1;

    _vehicle setVariable
    [
        "gau_gau8_interiorMix",
        _interiorMix
    ];

    _vehicle setVariable
    [
        "gau_gau8_cockpitMix",
        _interiorMix
    ];

    _vehicle setVariable
    [
        "gau_gau8_exteriorMix",
        1 - _interiorMix
    ];
};

private _exteriorMix = 1 - _interiorMix;

[
    _cameraMode,
    _listenerVehicle,
    _sameSourceVehicle,
    _interiorTarget,
    _interiorMix,
    _exteriorMix
]
