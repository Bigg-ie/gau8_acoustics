private _getParentChain =
{
    params ["_config"];

    private _result = [];
    private _current = _config;

    while {isClass _current} do
    {
        private _name = configName _current;
        _result pushBack _name;

        private _parent = inheritsFrom _current;

        if !(isClass _parent) exitWith {};

        if ((configName _parent) isEqualTo _name) exitWith {};

        _current = _parent;
    };

    _result
};

private _collectTurrets = {};

_collectTurrets =
{
    params
    [
        "_turretsConfig",
        ["_parentPath", []]
    ];

    private _result = [];
    private _turrets = "true" configClasses _turretsConfig;

    {
        private _path = _parentPath + [_forEachIndex];
        private _nestedTurrets = _x >> "Turrets";

        _result pushBack
        [
            _path,
            configName _x,
            getArray (_x >> "weapons"),
            getArray (_x >> "magazines"),
            configSourceAddonList _x,
            [_x] call _getParentChain
        ];

        if (isClass _nestedTurrets) then
        {
            _result append
            (
                [
                    _nestedTurrets,
                    _path
                ]
                call _collectTurrets
            );
        };
    }
    forEach _turrets;

    _result
};

private _getWeaponReport =
{
    params ["_weaponName"];

    private _weaponConfig =
        configFile
        >> "CfgWeapons"
        >> _weaponName;

    if !(isClass _weaponConfig) exitWith
    {
        [
            _weaponName,
            false
        ]
    };

    private _modeNames =
        getArray
        (
            _weaponConfig
            >> "modes"
        );

    private _modeRows = [];

    {
        private _modeName = _x;

        private _modeConfig =
            _weaponConfig
            >> _modeName;

        private _standardSound =
            _modeConfig
            >> "StandardSound";

        _modeRows pushBack
        [
            _modeName,
            isClass _modeConfig,
            configSourceAddonList _modeConfig,
            [_modeConfig] call _getParentChain,
            getNumber (_modeConfig >> "reloadTime"),
            getNumber (_modeConfig >> "autoFire"),
            getNumber (_modeConfig >> "burst"),
            getText (_modeConfig >> "weaponSoundEffect"),
            getArray (_standardSound >> "soundBegin"),
            getArray (_standardSound >> "soundSetShot"),
            getArray (_standardSound >> "begin1"),
            getArray (_standardSound >> "begin2")
        ];
    }
    forEach _modeNames;

    [
        _weaponName,
        true,
        getText (_weaponConfig >> "displayName"),
        getNumber (_weaponConfig >> "scope"),
        configSourceAddonList _weaponConfig,
        [_weaponConfig] call _getParentChain,
        getArray (_weaponConfig >> "magazines"),
        _modeNames,
        getText (_weaponConfig >> "weaponSoundEffect"),
        _modeRows
    ]
};

private _vehicleRows = [];

{
    private _vehicleConfig = _x;
    private _vehicleName = configName _vehicleConfig;
    private _displayName = getText (_vehicleConfig >> "displayName");
    private _sourceAddons = configSourceAddonList _vehicleConfig;

    private _searchText =
        toLower
        (
            _vehicleName
            + " "
            + _displayName
            + " "
            + str _sourceAddons
        );

    private _isA10 =
        (_searchText find "a-10") >= 0
        || {(_searchText find "a10") >= 0}
        || {(_searchText find "warthog") >= 0}
        || {(_searchText find "thunderbolt") >= 0};

    private _isTargetMod =
        (_searchText find "usaf") >= 0
        || {(_searchText find "cup") >= 0};

    if (_isA10 && {_isTargetMod}) then
    {
        private _driverWeapons =
            getArray
            (
                _vehicleConfig
                >> "weapons"
            );

        private _turretRows = [];

        private _turretsConfig =
            _vehicleConfig
            >> "Turrets";

        if (isClass _turretsConfig) then
        {
            _turretRows =
                [
                    _turretsConfig,
                    []
                ]
                call _collectTurrets;
        };

        private _allWeaponNames = +_driverWeapons;

        {
            _allWeaponNames append (_x select 2);
        }
        forEach _turretRows;

        _allWeaponNames =
            _allWeaponNames
            arrayIntersect
            _allWeaponNames;

        private _weaponRows = [];

        {
            _weaponRows pushBack
            (
                [_x]
                call _getWeaponReport
            );
        }
        forEach _allWeaponNames;

        _vehicleRows pushBack
        [
            _vehicleName,
            _displayName,
            getNumber (_vehicleConfig >> "scope"),
            _sourceAddons,
            [_vehicleConfig] call _getParentChain,
            _driverWeapons,
            _turretRows,
            _weaponRows
        ];
    };
}
forEach
(
    "true"
    configClasses
    (
        configFile
        >> "CfgVehicles"
    )
);

private _report =
[
    "GAU8_COMPAT_DISCOVERY_V1",
    productVersion,
    _vehicleRows
];

private _serialized = str _report;

copyToClipboard _serialized;

diag_log text
(
    "GAU8 COMPAT DISCOVERY: "
    + _serialized
);

hint format
[
    "Copied %1 USAF/CUP A-10 config rows to clipboard.",
    count _vehicleRows
];
