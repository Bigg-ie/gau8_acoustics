params
[
    ["_weapon", "", [""]],
    ["_modes", ["*"], [[]]],
    ["_impactAmmoClasses", [], [[]]]
];

if (_weapon isEqualTo "") exitWith
{
    false
};

if (_modes isEqualTo []) then
{
    _modes = ["*"];
};

private _registry =
    missionNamespace getVariable
    [
        "gau_gau8_weaponRegistry",
        []
    ];

private _index =
    _registry findIf
    {
        (_x select 0) isEqualTo _weapon
    };

if (_index < 0) then
{
    _registry pushBack
    [
        _weapon,
        +_modes,
        +_impactAmmoClasses
    ];
}
else
{
    private _entry =
        _registry select _index;

    private _registeredModes =
        _entry select 1;

    {
        _registeredModes pushBackUnique _x;
    }
    forEach _modes;

    _entry set
    [
        1,
        _registeredModes
    ];

    private _registeredImpactAmmoClasses =
        _entry param
        [
            2,
            []
        ];

    {
        _registeredImpactAmmoClasses pushBackUnique _x;
    }
    forEach _impactAmmoClasses;

    _entry set
    [
        2,
        _registeredImpactAmmoClasses
    ];

    _registry set
    [
        _index,
        _entry
    ];
};

missionNamespace setVariable
[
    "gau_gau8_weaponRegistry",
    _registry
];

true
