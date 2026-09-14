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

    class CUP_Vacannon_GAU8_veh: CannonCore
    {
        magazines[] =
        {
            "gau_gau8_CUP_1350Rnd_TE1_Red_Tracer_30mm_GAU8_M_ripSilent",
            "CUP_1350Rnd_TE1_Red_Tracer_30mm_GAU8_M"
        };

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

class CfgAmmo
{
    class CUP_B_30mm_CAS_Red_Tracer;

    class gau_gau8_CUP_B_30mm_CAS_Red_Tracer_ripSilent:
        CUP_B_30mm_CAS_Red_Tracer
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
    class CUP_1350Rnd_TE1_Red_Tracer_30mm_GAU8_M;

    class gau_gau8_CUP_1350Rnd_TE1_Red_Tracer_30mm_GAU8_M_ripSilent:
        CUP_1350Rnd_TE1_Red_Tracer_30mm_GAU8_M
    {
        ammo = "gau_gau8_CUP_B_30mm_CAS_Red_Tracer_ripSilent";
    };
};
