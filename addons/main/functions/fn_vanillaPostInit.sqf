if (
    missionNamespace getVariable
    [
        "gau_gau8_vanillaRipMagazineSwapStarted",
        false
    ]
) exitWith {};

missionNamespace setVariable
[
    "gau_gau8_vanillaRipMagazineSwapStarted",
    true
];

[] spawn
{
    waitUntil
    {
        time > 0
    };

    private _weapon =
        "Gatling_30mm_Plane_CAS_01_F";

    private _originalMagazine =
        "1000Rnd_Gatling_30mm_Plane_CAS_01_F";

    private _derivedMagazine =
        "gau_gau8_1000Rnd_Gatling_30mm_Plane_CAS_01_F_ripSilent";

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
                };
            };
        }
        forEach vehicles;

        uiSleep 1;
    };
};
