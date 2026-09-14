class CfgPatches
{
    class gau_gau8_firewill_compat
    {
        name = "GAU-8 Acoustic Simulation - Firewill Compatibility";
        author = "Biggie";
        requiredVersion = 2.14;
        requiredAddons[] =
        {
            "gau_gau8_main",
            "FIR_AirWeaponSystem_US"
        };
        skipWhenMissingDependencies = 1;
        units[] = {};
        weapons[] = {"FIR_GAU8"};
    };
};

class CfgFunctions
{
    class gau_gau8_firewill_compat
    {
        tag = "gau_gau8_firewill_compat";

        class main
        {
            file = "\z\gau\addons\firewill_compat\functions";

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

class CfgWeapons
{
    class CannonCore;

    class FIR_GAU8: CannonCore
    {
        magazines[] =
        {
            "gau_gau8_FIR_GAU8_1174rnd_M",
            "FIR_GAU8_1174rnd_M",
            "1174Rnd_GAU8_30mm_Plane_CAS_01_F"
        };

        class StandardSound
        {
            soundBegin[] = {"begin1", 1};
            begin1[] = {"", 0, 1, 1};
            soundSetShot[] = {};
            weaponSoundEffect = "";
        };
    };
};

class CfgAmmo
{

    class FIR_GAU8_CM_ammo;
    class FIR_GAU8_ammo_API;
    class FIR_GAU8_ammo_HEI;

    class gau_gau8_FIR_GAU8_ammo_API_ripSilent:
        FIR_GAU8_ammo_API
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

    class gau_gau8_FIR_GAU8_ammo_HEI_ripSilent:
        FIR_GAU8_ammo_HEI
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


    class gau_gau8_FIR_GAU8_CM_ammo: FIR_GAU8_CM_ammo
{

    soundSetExplosion[] = {};
    soundHit[] = {"", 0, 1};
    soundHit1[] = {"", 0, 1};
    soundHit2[] = {"", 0, 1};
    soundHit3[] = {"", 0, 1};
    soundHit4[] = {"", 0, 1};
    soundHit5[] = {"", 0, 1};


    gau_gau8_firNativeImpactRestoreVersion = 1;


    soundSetSonicCrack[] = {};
    soundSetBulletFly[] = {};
    soundFly[] = {"", 0, 1};
    supersonicCrackNear[] = {"", 0, 1, 1};
    supersonicCrackFar[] = {"", 0, 1, 1};

    submunitionAmmo[] =
    {
        "gau_gau8_FIR_GAU8_ammo_API_ripSilent", 0.8,
        "gau_gau8_FIR_GAU8_ammo_HEI_ripSilent", 0.2
    };

    gau_gau8_ripCrackSuppression = 40;


};


};

class CfgMagazines
{
    class FIR_GAU8_1174rnd_M;

    class gau_gau8_FIR_GAU8_1174rnd_M: FIR_GAU8_1174rnd_M
    {
        ammo = "gau_gau8_FIR_GAU8_CM_ammo";
    };
};
