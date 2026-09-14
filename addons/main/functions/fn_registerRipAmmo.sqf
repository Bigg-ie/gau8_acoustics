params
[
    ["_ammoClasses", [], [[]]]
];

private _registry =
    missionNamespace getVariable
    [
        "gau_gau8_ripAmmoRegistry",
        []
    ];

{
    private _ammo = _x;

    if (
        _ammo isEqualType "" &&
        {_ammo isNotEqualTo ""}
    ) then
    {
        private _cfg =
            configFile
            >> "CfgAmmo"
            >> _ammo;

        if (isClass _cfg) then
        {
            _registry pushBackUnique _ammo;
        }
        else
        {
            diag_log format
            [
                "GAU8 RIP: ignored missing ammo registration %1",
                _ammo
            ];
        };
    };
}
forEach _ammoClasses;

missionNamespace setVariable
[
    "gau_gau8_ripAmmoRegistry",
    _registry
];

missionNamespace setVariable
[
    "gau_gau8_ripReadOnlyAmmo",
    +_registry
];

true
