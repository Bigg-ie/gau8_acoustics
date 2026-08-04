class CfgPatches
{
    class big_gau8_jsrs2025_compat
    {
        name = "GAU-8 Acoustic Simulation - JSRS 2025 Compatibility";
        author = "BIG";
        requiredVersion = 2.14;
        requiredAddons[] =
        {
            "big_gau8_main",
            "jsrs2025_config_c"
        };
        skipWhenMissingDependencies = 1;
        units[] = {};
        weapons[] = {};
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
            class BaseSoundModeType;

            class StandardSound: BaseSoundModeType
            {
                soundSetShot[] = {};
            };
        };

        class burstHI: LowROF
        {
        };

        class close: burstHI
        {
            class BaseSoundModeType;

            class StandardSound: BaseSoundModeType
            {
                soundSetShot[] = {};
            };
        };

        class short: burstHI
        {
            class BaseSoundModeType;

            class StandardSound: BaseSoundModeType
            {
                soundSetShot[] = {};
            };
        };

        class medium: burstHI
        {
            class BaseSoundModeType;

            class StandardSound: BaseSoundModeType
            {
                soundSetShot[] = {};
            };
        };

        class far: burstHI
        {
            class BaseSoundModeType;

            class StandardSound: BaseSoundModeType
            {
                soundSetShot[] = {};
            };
        };
    };
};
