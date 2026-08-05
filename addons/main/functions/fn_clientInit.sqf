if (!hasInterface) exitWith {};

[
    "Gatling_30mm_Plane_CAS_01_F",
    [
        "LowROF",
        "close",
        "short",
        "medium",
        "far"
    ]
]
call big_gau8_fnc_registerWeapon;

private _installOnSupportedAircraft =
{
    params ["_aircraft"];

    if (isNull _aircraft) exitWith {};
    if !(_aircraft isKindOf "Air") exitWith {};

    private _weaponClasses =
        weapons _aircraft;

    private _turrets =
        [[-1]];

    {
        _turrets pushBackUnique _x;
    }
    forEach
    (
        allTurrets
        [
            _aircraft,
            true
        ]
    );

    {
        {
            _weaponClasses pushBackUnique _x;
        }
        forEach
        (
            _aircraft weaponsTurret _x
        );
    }
    forEach _turrets;

    private _registry =
        missionNamespace getVariable
        [
            "big_gau8_weaponRegistry",
            []
        ];

    private _supported =
        _weaponClasses findIf
        {
            private _weapon = _x;

            _registry findIf
            {
                (_x select 0) isEqualTo _weapon
            }
            >= 0
        };

    if (_supported < 0) exitWith {};

    [_aircraft] call big_gau8_fnc_installGrainHandler;
};

missionNamespace setVariable
[
    "big_gau8_installOnSupportedAircraft",
    _installOnSupportedAircraft
];

private _oldEntityCreatedHandler =
    missionNamespace getVariable
    [
        "big_gau8_entityCreatedHandler",
        -1
    ];

if (_oldEntityCreatedHandler >= 0) then
{
    removeMissionEventHandler
    [
        "EntityCreated",
        _oldEntityCreatedHandler
    ];
};

private _entityCreatedHandler =
    addMissionEventHandler
    [
        "EntityCreated",
        {
            params ["_entity"];

            if (isNull _entity) exitWith {};
            if !(_entity isKindOf "Air") exitWith {};

            _entity spawn
            {
                uiSleep 0.05;

                private _installer =
                    missionNamespace getVariable
                    [
                        "big_gau8_installOnSupportedAircraft",
                        {}
                    ];

                [_this] call _installer;
            };
        }
    ];

missionNamespace setVariable
[
    "big_gau8_entityCreatedHandler",
    _entityCreatedHandler
];

{
    [_x] call _installOnSupportedAircraft;
}
forEach vehicles;

diag_log format
[
    "GAU8: compatibility-aware client bootstrap active; scanned %1 vehicles; registry=%2",
    count vehicles,
    missionNamespace getVariable
    [
        "big_gau8_weaponRegistry",
        []
    ]
];
