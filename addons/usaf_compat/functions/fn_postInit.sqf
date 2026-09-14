if (
    missionNamespace getVariable
    [
        "gau_gau8_usafRipMagazineSwapStarted",
        false
    ]
) exitWith {};

missionNamespace setVariable
[
    "gau_gau8_usafRipMagazineSwapStarted",
    true
];

[] spawn
{
    waitUntil
    {
        time > 0
    };

    private _weapon =
        "USAF_GAU8_GUN";

    private _mappings =
    [
        [
            "USAF_GAU8_1150Rnd",
            "gau_gau8_USAF_GAU8_1150Rnd_ripSilent"
        ]
    ];

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
                {
                    _x params
                    [
                        "_originalMagazine",
                        "_derivedMagazine"
                    ];

                    private _magazines =
                        _vehicle magazinesTurret [-1];

                    if (_originalMagazine in _magazines) then
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
                                "GAU8 USAF RIP: replaced %1 with %2 on %3; ammo=%4",
                                _originalMagazine,
                                _derivedMagazine,
                                typeOf _vehicle,
                                _ammoCount
                            ];
                        };
                    };
                }
                forEach _mappings;
            };
        }
        forEach vehicles;

        uiSleep 1;
    };
};
