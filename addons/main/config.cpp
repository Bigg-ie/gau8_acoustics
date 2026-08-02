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

            // Allow each 60 ms sample to overlap the next shot.
            soundContinuous = 0;

            class StandardSound
            {
                begin1[] =
                {
                    "\z\big\addons\main\sounds\cannon\close_cola_1.wav",
                    5.62341,
                    1,
                    1500,
                    {25704,32159}
                };

                begin2[] =
                {
                    "\z\big\addons\main\sounds\cannon\close_cola_2.wav",
                    5.62341,
                    1,
                    1500,
                    {25704,32159}
                };

                begin3[] =
                {
                    "\z\big\addons\main\sounds\cannon\close_cola_3.wav",
                    5.62341,
                    1,
                    1500,
                    {25704,32159}
                };

                begin4[] =
                {
                    "\z\big\addons\main\sounds\cannon\close_cola_4.wav",
                    5.62341,
                    1,
                    1500,
                    {25704,32159}
                };

                soundBegin[] =
                {
                    "begin1", 0.25,
                    "begin2", 0.25,
                    "begin3", 0.25,
                    "begin4", 0.25
                };
            };
        };
    };
};
