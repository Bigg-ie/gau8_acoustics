class CfgPatches
{
    class big_gau8_firewill_compat
    {
        name = "GAU-8 Acoustic Simulation - Firewill Compatibility";
        author = "BIG";
        requiredVersion = 2.14;
        requiredAddons[] =
        {
            "big_gau8_main",
            "FIR_AirWeaponSystem_US"
        };
        skipWhenMissingDependencies = 1;
        units[] = {};
        weapons[] = {"FIR_GAU8"};
    };
};

class CfgFunctions
{
    class big_gau8_firewill_compat
    {
        tag = "big_gau8_firewill_compat";

        class main
        {
            file = "\z\big\addons\firewill_compat\functions";

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

    class FIR_GAU8: CannonCore
    {
        class StandardSound
        {
            soundBegin[] = {"begin1", 1};
            begin1[] = {"", 0, 1, 1};
            soundSetShot[] = {};
            weaponSoundEffect = "";
        };
    };
};
