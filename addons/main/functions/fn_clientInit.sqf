if (!hasInterface) exitWith {};

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
            "gau_gau8_weaponRegistry",
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

    [_aircraft] call gau_gau8_fnc_installGrainHandler;
};

missionNamespace setVariable
[
    "gau_gau8_installOnSupportedAircraft",
    _installOnSupportedAircraft
];

private _oldEntityCreatedHandler =
    missionNamespace getVariable
    [
        "gau_gau8_entityCreatedHandler",
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
                        "gau_gau8_installOnSupportedAircraft",
                        {}
                    ];

                [_this] call _installer;
            };
        }
    ];

missionNamespace setVariable
[
    "gau_gau8_entityCreatedHandler",
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
        "gau_gau8_weaponRegistry",
        []
    ]
];


if (hasInterface) then
{
    private _oldReplacementEH =
        missionNamespace getVariable
        [
            "gau_gau8_ripReplacementProjectileEH",
            -1
        ];

    if (_oldReplacementEH >= 0) then
    {
        removeMissionEventHandler
        [
            "ProjectileCreated",
            _oldReplacementEH
        ];
    };

    missionNamespace setVariable
    [
        "gau_gau8_ripReplacementProjectileEH",
        -1
    ];

    private _oldReadOnlyEH =
        missionNamespace getVariable
        [
            "gau_gau8_ripReadOnlyProjectileEH",
            -1
        ];

    if (_oldReadOnlyEH >= 0) then
    {
        removeMissionEventHandler
        [
            "ProjectileCreated",
            _oldReadOnlyEH
        ];
    };

    missionNamespace setVariable
    [
        "gau_gau8_ripReadOnlyAmmo",
        +
        (
            missionNamespace getVariable
            [
                "gau_gau8_ripAmmoRegistry",
                []
            ]
        )
    ];

    private _eh =
        addMissionEventHandler
        [
            "ProjectileCreated",
            {
                params ["_projectile"];

                if (isNull _projectile) exitWith {};

                private _ammo = typeOf _projectile;

                private _supported =
                    missionNamespace getVariable
                    [
                        "gau_gau8_ripAmmoRegistry",
                        []
                    ];

                if !(_ammo in _supported) exitWith {};

                private _cfg =
                    configFile
                    >> "CfgAmmo"
                    >> _ammo;

                if (!isClass _cfg) exitWith {};

                if (
                    (
                        toLower
                        (
                            getText
                            (
                                _cfg
                                >> "simulation"
                            )
                        )
                    )
                    !=
                    "shotbullet"
                ) exitWith {};

                private _parents =
                    getShotParents _projectile;

                private _source =
                    _parents param
                    [
                        0,
                        objNull
                    ];

                if (isNull _source) then
                {
                    _source =
                        _parents param
                        [
                            1,
                            objNull
                        ];
                };

                private _vehicle =
                    if (
                        !isNull _source &&
                        {_source isKindOf "Man"}
                    ) then
                    {
                        vehicle _source
                    }
                    else
                    {
                        _source
                    };

                if (isNull _vehicle) exitWith {};

                missionNamespace setVariable
                [
                    "gau_gau8_lastRipDetectedProjectile",
                    [
                        _ammo,
                        _vehicle,
                        getPosASL _projectile,
                        velocity _projectile,
                        diag_tickTime
                    ]
                ];

                [
                    _vehicle,
                    _projectile
                ]
                call
                    gau_gau8_fnc_registerRipShot;
            }
        ];

    missionNamespace setVariable
    [
        "gau_gau8_ripReadOnlyProjectileEH",
        _eh
    ];

    missionNamespace setVariable
    [
        "gau_gau8_ripProjectileReplacementMappings",
        []
    ];

    missionNamespace setVariable
    [
        "gau_gau8_ripGlobalPatchVersion",
        40
    ];
};
