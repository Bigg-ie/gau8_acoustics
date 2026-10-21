private _modes =
[
    "A10tastic_GAU8_3secburstx",
    "A10tastic_GAU8_1secburstx",
    "A10tastic_GAU8_2secburstx"
];

{
    [
        _x,
        _modes,
        []
    ]
    call gau_gau8_fnc_registerWeapon;
}
forEach
[
    "Gatling_30mm_Plane_CAS_01_F",
    "FIR_GAU8",
    "RHS_weap_gau8",
    "USAF_GAU8_GUN",
    "CUP_Vacannon_GAU8_veh"
];
