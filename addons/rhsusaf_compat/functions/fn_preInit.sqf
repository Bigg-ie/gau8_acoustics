[
    "RHS_weap_gau8",
    [
        "LowROF",
        "HighROF",
        "close",
        "short",
        "medium",
        "far"
    ],
    []
]
call gau_gau8_fnc_registerWeapon;

[
    [
        "rhs_ammo_PGU14B_API",
        "rhs_ammo_PGU13B_HE",
        "gau_gau8_rhs_ammo_PGU14B_API_ripSilent",
        "gau_gau8_rhs_ammo_PGU13B_HE_ripSilent"
    ]
]
call gau_gau8_fnc_registerRipAmmo;
