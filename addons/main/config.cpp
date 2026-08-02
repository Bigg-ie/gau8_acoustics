class CfgPatches
{
    class big_gau8_main
    {
        name = "GAU-8 Acoustic Simulation";
        author = "Biggie";

        requiredVersion = 2.18;
        requiredAddons[] =
        {
            "A3_Sounds_F",
            "A3_Air_F_EPC_Plane_CAS_01"
        };

        units[] = {};
        weapons[] = {};
    };
};

class CfgSoundShaders
{
    class big_GAU8_CloseBody_SoundShader
    {
        samples[] =
        {
            {"\z\big\addons\main\sounds\cannon\close_cola_1.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cola_2.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cola_3.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cola_4.wav", 1}
        };

        volume = 1;
        range = 1200;
        rangeCurve = "closeShotCurve";
    };
};

class CfgSoundSets
{
    class big_GAU8_CloseBody_SoundSet
    {
        soundShaders[] =
        {
            "big_GAU8_CloseBody_SoundShader"
        };

        volumeFactor = 1;
        volumeCurve[] =
        {
            {0, 1},
            {1000, 1},
            {1200, 0}
        };

        spatial = 1;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "none";
    };
};

class Mode_FullAuto;
class BaseSoundModeType;

class CfgWeapons
{
    class CannonCore;

    class Gatling_30mm_Plane_CAS_01_F: CannonCore
    {
        displayName = "GAU-8/A Avenger [GAU-8 Acoustic Dev]";

        class LowROF: Mode_FullAuto
        {
            displayName = "GAU-8 Low ROF [Acoustic Dev]";

            sounds[] = {"StandardSound"};
            soundContinuous = 0;

            class StandardSound: BaseSoundModeType
            {
                soundSetShot[] =
                {
                    "big_GAU8_CloseBody_SoundSet"
                };
            };
        };
    };
};


