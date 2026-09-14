class CfgPatches
{
    class gau_gau8_rhsusaf_compat
    {
        name = "GAU-8 Acoustic Simulation - RHSUSAF Compatibility";
        author = "Biggie";
        requiredVersion = 2.14;
        requiredAddons[] =
        {
            "gau_gau8_main",
            "rhsusf_c_heavyweapons"
        };
        skipWhenMissingDependencies = 1;
        units[] = {};
        weapons[] = {"RHS_weap_gau8"};
    };
};

class CfgFunctions
{
    class gau_gau8_rhsusaf_compat
    {
        tag = "gau_gau8_rhsusaf_compat";

        class main
        {
            file = "\z\gau\addons\rhsusaf_compat\functions";

            class preInit
            {
                preInit = 1;
            };

            class postInit
            {
                postInit = 1;
            };
        };
    };
};

class Mode_FullAuto;

class CfgWeapons
{
    class CannonCore;

    class Gatling_30mm_Plane_CAS_01_F: CannonCore
    {
        class LowROF: Mode_FullAuto
        {
        };
    };

    class RHS_weap_gau8: Gatling_30mm_Plane_CAS_01_F
    {
        magazines[] =
        {
            "gau_gau8_rhs_mag_1150Rnd_30x173_ripSilent",
            "gau_gau8_rhs_mag_1150Rnd_30x173_mixed_ripSilent",
            "gau_gau8_rhs_mag_1000Rnd_30x173_ripSilent",
            "gau_gau8_rhs_mag_1000Rnd_30x173_mixed_ripSilent",
            "rhs_mag_1150Rnd_30x173",
            "rhs_mag_1150Rnd_30x173_mixed",
            "rhs_mag_1000Rnd_30x173",
            "rhs_mag_1000Rnd_30x173_mixed"
        };

        class LowROF: LowROF
        {
            class BaseSoundModeType;

            class StandardSound: BaseSoundModeType
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };

        class HighROF: LowROF
        {
            class BaseSoundModeType;

            class StandardSound: BaseSoundModeType
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };
    };
};

class CfgAmmo
{
    class rhs_ammo_PGU14B_API;
    class rhs_ammo_PGU13B_HE;
    class rhs_ammo_30x173mm_GAU8_mixed;

    class gau_gau8_rhs_ammo_PGU14B_API_ripSilent:
        rhs_ammo_PGU14B_API
    {

        soundSetExplosion[] =
        {
            "gau_GAU8_ImpactAP_SoundSet"
        };

        soundHit[] = {"", 0, 1};
        soundHit1[] = {"", 0, 1};
        soundHit2[] = {"", 0, 1};
        soundHit3[] = {"", 0, 1};
        soundHit4[] = {"", 0, 1};
        soundHit5[] = {"", 0, 1};
        soundSetSonicCrack[] = {};
        soundSetBulletFly[] = {};
        soundFly[] = {"", 0, 1};
        supersonicCrackNear[] = {"", 0, 1, 1};
        supersonicCrackFar[] = {"", 0, 1, 1};

        gau_gau8_ripCrackSuppression = 40;
    };

    class gau_gau8_rhs_ammo_PGU13B_HE_ripSilent:
        rhs_ammo_PGU13B_HE
    {

        soundSetExplosion[] =
        {
            "gau_GAU8_ImpactHE_SoundSet"
        };

        soundHit[] = {"", 0, 1};
        soundHit1[] = {"", 0, 1};
        soundHit2[] = {"", 0, 1};
        soundHit3[] = {"", 0, 1};
        soundHit4[] = {"", 0, 1};
        soundHit5[] = {"", 0, 1};
        soundSetSonicCrack[] = {};
        soundSetBulletFly[] = {};
        soundFly[] = {"", 0, 1};
        supersonicCrackNear[] = {"", 0, 1, 1};
        supersonicCrackFar[] = {"", 0, 1, 1};

        gau_gau8_ripCrackSuppression = 40;
    };

    class gau_gau8_rhs_ammo_30x173mm_GAU8_mixed_ripSilent:
        rhs_ammo_30x173mm_GAU8_mixed
    {

        soundSetExplosion[] = {};
        soundHit[] = {"", 0, 1};
        soundHit1[] = {"", 0, 1};
        soundHit2[] = {"", 0, 1};
        soundHit3[] = {"", 0, 1};
        soundHit4[] = {"", 0, 1};
        soundHit5[] = {"", 0, 1};

        soundSetSonicCrack[] = {};
        soundSetBulletFly[] = {};
        soundFly[] = {"", 0, 1};
        supersonicCrackNear[] = {"", 0, 1, 1};
        supersonicCrackFar[] = {"", 0, 1, 1};

        submunitionAmmo[] =
        {
            "gau_gau8_rhs_ammo_PGU14B_API_ripSilent", 0.8,
            "gau_gau8_rhs_ammo_PGU13B_HE_ripSilent", 0.2
        };

        gau_gau8_ripCrackSuppression = 40;
    };
};

class CfgMagazines
{
    class rhs_mag_1150Rnd_30x173;
    class rhs_mag_1150Rnd_30x173_mixed;
    class rhs_mag_1000Rnd_30x173;
    class rhs_mag_1000Rnd_30x173_mixed;

    class gau_gau8_rhs_mag_1150Rnd_30x173_ripSilent:
        rhs_mag_1150Rnd_30x173
    {
        ammo = "gau_gau8_rhs_ammo_PGU14B_API_ripSilent";
    };

    class gau_gau8_rhs_mag_1150Rnd_30x173_mixed_ripSilent:
        rhs_mag_1150Rnd_30x173_mixed
    {
        ammo =
            "gau_gau8_rhs_ammo_30x173mm_GAU8_mixed_ripSilent";
    };

    class gau_gau8_rhs_mag_1000Rnd_30x173_ripSilent:
        rhs_mag_1000Rnd_30x173
    {
        ammo = "gau_gau8_rhs_ammo_PGU14B_API_ripSilent";
    };

    class gau_gau8_rhs_mag_1000Rnd_30x173_mixed_ripSilent:
        rhs_mag_1000Rnd_30x173_mixed
    {
        ammo =
            "gau_gau8_rhs_ammo_30x173mm_GAU8_mixed_ripSilent";
    };
};
