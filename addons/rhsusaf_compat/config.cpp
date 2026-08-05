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
