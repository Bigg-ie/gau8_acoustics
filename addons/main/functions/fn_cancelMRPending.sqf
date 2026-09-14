params
[
    "_vehicle",
    ["_burstToken", -1]
];

if (isNull _vehicle) exitWith
{
    false
};

private _activeToken =
    _vehicle getVariable
    [
        "gau_gau8_mrBurstToken",
        -1
    ];

if (
    (_burstToken >= 0) &&
    {_activeToken isNotEqualTo _burstToken}
) exitWith
{
    false
};

private _cancelSerial =
    (
        _vehicle getVariable
        [
            "gau_gau8_mrCancelSerial",
            0
        ]
    ) + 1;

_vehicle setVariable
[
    "gau_gau8_mrCancelSerial",
    _cancelSerial
];

_vehicle setVariable
[
    "gau_gau8_mrReleasePending",
    false
];

_vehicle setVariable
[
    "gau_gau8_mrSustainArmed",
    true
];

_vehicle setVariable
[
    "gau_gau8_mrReleaseBoundaryTick",
    -1
];

true
