class CfgPatches
{
    class gau_gau8_a10tastic_compat
    {
        name = "GAU-8 Acoustic Simulation - A-10-tastic Compatibility";
        author = "Biggie";
        requiredVersion = 2.14;
        requiredAddons[] =
        {
            "gau_gau8_main",
            "A10tastic_Core"
        };
        skipWhenMissingDependencies = 1;
        units[] = {};
        weapons[] = {};
    };
};


class CfgFunctions
{
    class gau_gau8_a10tastic
    {
        tag = "gau_gau8_a10tastic";

        class compat
        {
            file = "\z\gau\addons\a10tastic_compat\functions";

            class preInit
            {
                preInit = 1;
            };
        };
    };
};

class CfgSoundSets
{
    class A10tastic_Ext_GAU8_1sec_SoundSet
    {
        soundShaders[] = {};
        volumeFactor = 0;
    };

    class A10tastic_Int_GAU8_1sec_SoundSet
    {
        soundShaders[] = {};
        volumeFactor = 0;
    };

    class A10tastic_Ext_GAU8_2sec_SoundSet
    {
        soundShaders[] = {};
        volumeFactor = 0;
    };

    class A10tastic_Int_GAU8_2sec_SoundSet
    {
        soundShaders[] = {};
        volumeFactor = 0;
    };
};
