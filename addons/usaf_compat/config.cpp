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
        };
    };
};

class CfgWeapons
{
    class CannonCore;

    class USAF_GAU8_GUN: CannonCore
    {
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
