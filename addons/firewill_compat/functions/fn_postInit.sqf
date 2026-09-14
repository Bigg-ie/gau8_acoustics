if (
    missionNamespace getVariable
    [
        "gau_gau8_firewillRipMagazineSwapStarted",
        false
    ]
) exitWith {};

missionNamespace setVariable
[
    "gau_gau8_firewillRipMagazineSwapStarted",
    true
];

[] spawn
{
    waitUntil
    {
        time > 0
    };

    private _weapon =
        "FIR_GAU8";

    private _originalMagazine =
        "FIR_GAU8_1174rnd_M";

    private _derivedMagazine =
        "gau_gau8_FIR_GAU8_1174rnd_M";

    while {true} do
    {
        {
            private _vehicle = _x;

            if (
                _vehicle turretLocal [-1] &&
                {
                    _weapon in
                    (
                        _vehicle weaponsTurret [-1]
                    )
                }
            ) then
            {
                private _magazines =
                    _vehicle magazinesTurret [-1];

                if (
                    _originalMagazine in
                    _magazines
                ) then
                {
                    private _ammoCount =
                        _vehicle magazineTurretAmmo
                        [
                            _originalMagazine,
                            [-1]
                        ];

                    private _wasCurrent =
                        (
                            _vehicle currentMagazineTurret [-1]
                        )
                        isEqualTo
                        _originalMagazine;

                    _vehicle removeMagazineTurret
                    [
                        _originalMagazine,
                        [-1]
                    ];

                    _vehicle addMagazineTurret
                    [
                        _derivedMagazine,
                        [-1],
                        _ammoCount
                    ];

                    if (
                        _wasCurrent &&
                        {
                            !isNull
                            (
                                driver _vehicle
                            )
                        }
                    ) then
                    {
                        _vehicle loadMagazine
                        [
                            [-1],
                            _weapon,
                            _derivedMagazine
                        ];
                    };

                    _vehicle setVariable
                    [
                        "gau_gau8_firewillDerivedMagazine",
                        true
                    ];

                    if (
                        missionNamespace getVariable
                        [
                            "gau_gau8_debugRipMagazineSwap",
                            false
                        ]
                    ) then
                    {
                        diag_log format
                        [
                            "GAU8 FIR RIP: replaced %1 with %2 on %3; ammo=%4",
                            _originalMagazine,
                            _derivedMagazine,
                            typeOf _vehicle,
                            _ammoCount
                        ];
                    };
                };
            };
        }
        forEach vehicles;

        uiSleep 1;
    };
};
