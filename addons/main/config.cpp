class CfgPatches
{
    class big_gau8_main
    {
        name = "GAU-8 Acoustic Simulation";
        author = "Biggie";

        requiredVersion = 2.18;
        requiredAddons[] =
        {
            "A3_Air_F_EPC_Plane_CAS_01"
        };

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
        displayName = "GAU-8/A Avenger [GAU-8 Acoustic Dev]";

        class LowROF: Mode_FullAuto
        {
            displayName = "GAU-8 Low ROF [Acoustic Dev]";
        };
    };
};
