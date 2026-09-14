class CfgPatches
{
    class gau_gau8_usaf_compat
    {
        name = "GAU-8 Acoustic Simulation - USAF A-10C Compatibility";
        author = "Biggie";
        requiredVersion = 2.14;
        requiredAddons[] =
        {
            "gau_gau8_main",
            "USAF_A10_C"
        };
        skipWhenMissingDependencies = 1;
        units[] = {};
        weapons[] =
        {
            "USAF_GAU8_GUN"
        };
    };
};

class CfgFunctions
{
    class gau_gau8_usaf_compat
    {
        tag = "gau_gau8_usaf_compat";

        class main
        {
            file = "\z\gau\addons\usaf_compat\functions";

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

    class USAF_GAU8_GUN: CannonCore
    {
        magazines[] =
        {
            "gau_gau8_USAF_GAU8_1150Rnd_ripSilent",
            "USAF_GAU8_1150Rnd"
        };

        class manual;

        class burst1: manual
        {
            weaponSoundEffect = "";

            class StandardSound
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };

        class burst2: burst1
        {
            weaponSoundEffect = "";

            class StandardSound
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };

        class close: burst1
        {
            weaponSoundEffect = "";

            class StandardSound
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };

        class short: burst2
        {
            weaponSoundEffect = "";

            class StandardSound
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };

        class medium: burst2
        {
            weaponSoundEffect = "";

            class StandardSound
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };

        class far: burst1
        {
            weaponSoundEffect = "";

            class StandardSound
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
    class USAF_GAU8_30mm_CM;

    class gau_gau8_USAF_GAU8_30mm_CM_ripSilent:
        USAF_GAU8_30mm_CM
    {

        soundSetExplosion[] =
        {
            "gau_GAU8_ImpactLight_SoundSet"
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
};

class CfgMagazines
{
    class USAF_GAU8_1150Rnd;

    class gau_gau8_USAF_GAU8_1150Rnd_ripSilent:
        USAF_GAU8_1150Rnd
    {
        ammo = "gau_gau8_USAF_GAU8_30mm_CM_ripSilent";
    };
};
