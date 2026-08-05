class CfgPatches
{
    class gau_gau8_cup_compat
    {
        name = "GAU-8 Acoustic Simulation - CUP A-10 Compatibility";
        author = "Biggie";
        requiredVersion = 2.14;
        requiredAddons[] =
        {
            "gau_gau8_main",
            "CUP_Weapons_VehicleWeapons"
        };
        skipWhenMissingDependencies = 1;
        units[] = {};
        weapons[] =
        {
            "CUP_Vacannon_GAU8_veh"
        };
    };
};

class CfgFunctions
{
    class gau_gau8_cup_compat
    {
        tag = "gau_gau8_cup_compat";

        class main
        {
            file = "\z\gau\addons\cup_compat\functions";

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

    class CUP_Vacannon_GAU8_veh: CannonCore
    {
        class halfsec: CannonCore
        {
            weaponSoundEffect = "";

            class StandardSound
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };

        class 1sec: halfsec
        {
            weaponSoundEffect = "";

            class StandardSound
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };

        class 2sec: halfsec
        {
            weaponSoundEffect = "";

            class StandardSound
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };

        class Close: halfsec
        {
            weaponSoundEffect = "";

            class StandardSound
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };

        class short: Close
        {
            weaponSoundEffect = "";

            class StandardSound
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };

        class medium: Close
        {
            weaponSoundEffect = "";

            class StandardSound
            {
                soundBegin[] = {"begin1", 1};
                begin1[] = {"", 0, 1, 1};
                soundSetShot[] = {};
            };
        };

        class Far: Close
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
