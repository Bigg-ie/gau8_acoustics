class CfgPatches
{
    class big_gau8_rhsusaf_jsrs2025_compat
    {
        name = "GAU-8 Acoustic Simulation - RHSUSAF and JSRS 2025 Compatibility";
        author = "BIG";
        requiredVersion = 2.14;
        requiredAddons[] =
        {
            "big_gau8_rhsusaf_compat",
            "jsrs2025_compat_rhs_usf"
        };
        skipWhenMissingDependencies = 1;
        units[] = {};
        weapons[] = {"RHS_weap_gau8"};
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
