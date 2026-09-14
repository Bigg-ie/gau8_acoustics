class CfgPatches
{
    class gau_gau8_main
    {
        name = "GAU-8 Acoustic Overhaul";
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

class CfgDistanceFilters
{
    class gau_GAU8_CannonDistanceFilter
    {
        type = "lowPassFilter";
        minCutoffFrequency = 6000;
        qFactor = 1;
        innerRange = 150;
        range = 600;
        powerFactor = 1;
    };
};

class CfgSoundCurves
{

    class gau_GAU8_FarShaderCurve
    {
        points[] =
        {
            {0.00, 1.00},
            {1.00, 1.00}
        };
    };


    class gau_GAU8_FarSetCurve
    {
        points[] =
        {
            {0.00, 1.00},
            {0.20, 1.00},
            {0.50, 0.70},
            {0.75, 0.30},
            {1.00, 0.00}
        };
    };
    class gau_GAU8_FarPulseShaderCurve
    {
        points[] =
        {
            {0.00, 0.00},
            {0.05, 0.00},
            {0.075, 0.65},
            {0.10, 1.00},
            {0.20, 1.00},
            {0.35, 0.70},
            {0.50, 0.30},
            {0.70, 0.00},
            {1.00, 0.00}
        };
    };

    class gau_GAU8_FarPulseSetCurve
    {
        points[] =
        {
            {0.00, 1.00},
            {0.65, 1.00},
            {0.85, 0.65},
            {1.00, 0.00}
        };
    };
    class gau_GAU8_MidReportShaderCurve
    {
        points[] =
        {
            {0.00, 0.00},
            {0.08, 0.00},
            {0.16, 1.00},
            {0.65, 1.00},
            {1.00, 0.00}
        };
    };

    class gau_GAU8_MidReportSetCurve
    {
        points[] =
        {
            {0.00, 1.00},
            {0.20, 1.00},
            {0.50, 0.75},
            {0.75, 0.40},
            {1.00, 0.00}
        };
    };
    class gau_GAU8_CloseRecordedSetCurve
{
    points[] =
    {
        {0, 1.0000},
        {50, 1.0000},
        {100, 0.4467},
        {200, 0.2239},
        {500, 0.0794},
        {1000, 0.0398},
        {1500, 0.0150},
        {2000, 0.0000}
    };
};

};

class CfgSoundShaders
{

    class gau_GAU8_ImpactHE_SoundShader
    {
        samples[] =
        {
            {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_01.wss", 1},
            {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_02.wss", 1},
            {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_03.wss", 1},
            {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_04.wss", 1}
        };

        volume = 0.90;
        range = 1100;
        rangeCurve = "closeShotCurve";
    };

    class gau_GAU8_ImpactLight_SoundShader
    {
        samples[] =
        {
            {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_01.wss", 1},
            {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_02.wss", 1},
            {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_03.wss", 1},
            {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_04.wss", 1}
        };

        volume = 0.80;
        range = 950;
        rangeCurve = "closeShotCurve";
    };

    class gau_GAU8_ImpactAP_SoundShader
    {
        samples[] =
        {
            {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_01.wss", 1},
            {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_02.wss", 1},
            {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_03.wss", 1},
            {"A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_04.wss", 1}
        };

        volume = 0.70;
        range = 850;
        rangeCurve = "closeShotCurve";
    };
    class gau_GAU8_CloseBody_SoundShader
    {
        samples[] =
        {
            {"\z\gau\addons\main\sounds\cannon\close_cola_1.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cola_2.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cola_3.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cola_4.wav", 1}
        };

        volume = 1;
        range = 300;
        rangeCurve = "closeShotCurve";
    };

    class gau_GAU8_FarPulse_SoundShader
    {
        samples[] =
        {
            {"\z\gau\addons\main\sounds\cannon\far_pulse_1.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\far_pulse_2.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\far_pulse_3.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\far_pulse_4.wav", 1}
        };

        volume = 1;
        range = 3000;
        rangeCurve = "gau_GAU8_FarPulseShaderCurve";
    };
    class gau_GAU8_CloseTransient_SoundShader
    {
        samples[] =
        {
            {"\z\gau\addons\main\sounds\cannon\close_transient_1.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_transient_2.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_transient_3.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_transient_4.wav", 1}
        };

        volume = 1;
        range = 220;
        rangeCurve = "closeShotCurve";
    };
    class gau_GAU8_CloseMechanical_SoundShader
    {
        samples[] =
        {
            {"\z\gau\addons\main\sounds\cannon\close_mechanical_1.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_mechanical_2.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_mechanical_3.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_mechanical_4.wav", 1}
        };

        volume = 1;
        range = 100;
        rangeCurve = "closeShotCurve";
    };

    class gau_GAU8_MidReport_SoundShader
    {
        samples[] =
        {
            {"\z\gau\addons\main\sounds\cannon\mid_report_1.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\mid_report_2.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\mid_report_3.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\mid_report_4.wav", 1}
        };

        volume = 1;
        range = 1200;
        rangeCurve = "gau_GAU8_MidReportShaderCurve";
    };

    class gau_GAU8_AirframeResponse_SoundShader
    {
        samples[] =
        {
            {"\z\gau\addons\main\sounds\cannon\airframe_response_1.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\airframe_response_2.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\airframe_response_3.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\airframe_response_4.wav", 1}
        };

        volume = 1;
        range = 70;
        rangeCurve = "closeShotCurve";
    };

    class gau_GAU8_CloseBodyReal_SoundShader
    {
        samples[] =
        {
            {"\z\gau\addons\main\sounds\cannon\close_body_real_1.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_body_real_2.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_body_real_3.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_body_real_4.wav", 1}
        };

        volume = 1;
        range = 300;
        rangeCurve = "closeShotCurve";
    };

    class gau_GAU8_CloseRecorded_SoundShader
    {
        samples[] =
        {
            {"\z\gau\addons\main\sounds\cannon\close_cell_01.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_02.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_03.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_04.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_05.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_06.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_07.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_08.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_09.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_10.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_11.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_12.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_13.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_14.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_15.wav", 1},
            {"\z\gau\addons\main\sounds\cannon\close_cell_16.wav", 1}
        };

        volume = 1;
        range = 2000;
        rangeCurve = "closeShotCurve";
    };

};

class CfgSoundSets
{

    class gau_GAU8_ImpactHE_SoundSet
    {
        soundShaders[] =
        {
            "gau_GAU8_ImpactHE_SoundShader"
        };

        volumeFactor = 1.0;
        spatial = 1;
        doppler = 0;
        loop = 0;
    };

    class gau_GAU8_ImpactLight_SoundSet
    {
        soundShaders[] =
        {
            "gau_GAU8_ImpactLight_SoundShader"
        };

        volumeFactor = 1.0;
        spatial = 1;
        doppler = 0;
        loop = 0;
    };

    class gau_GAU8_ImpactAP_SoundSet
    {
        soundShaders[] =
        {
            "gau_GAU8_ImpactAP_SoundShader"
        };

        volumeFactor = 1.0;
        spatial = 1;
        doppler = 0;
        loop = 0;
    };
    class gau_GAU8_CloseBody_SoundSet
    {
        soundShaders[] =
        {
            "gau_GAU8_CloseBody_SoundShader"
        };

        volumeFactor = 1;
        volumeCurve = "InverseSquare2Curve";

        spatial = 1;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "weaponShotDistanceFreqAttenuationFilter";
    };

    class gau_GAU8_FarPulse_SoundSet
    {
        soundShaders[] =
        {
            "gau_GAU8_FarPulse_SoundShader"
        };

        volumeFactor = 0.55;
        volumeCurve = "gau_GAU8_FarPulseSetCurve";

        spatial = 1;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "none";
    };
    class gau_GAU8_CloseTransient_SoundSet
    {
        soundShaders[] =
        {
            "gau_GAU8_CloseTransient_SoundShader"
        };

        volumeFactor = 0.55;
        volumeCurve = "InverseSquare2Curve";

        spatial = 1;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "weaponShotDistanceFreqAttenuationFilter";
    };
    class gau_GAU8_CloseMechanical_SoundSet
    {
        soundShaders[] =
        {
            "gau_GAU8_CloseMechanical_SoundShader"
        };

        volumeFactor = 0.20;
        volumeCurve = "InverseSquare2Curve";

        spatial = 1;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "weaponShotDistanceFreqAttenuationFilter";
    };

    class gau_GAU8_MidReport_SoundSet
    {
        soundShaders[] =
        {
            "gau_GAU8_MidReport_SoundShader"
        };

        volumeFactor = 0.65;
        volumeCurve = "gau_GAU8_MidReportSetCurve";

        spatial = 1;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "weaponShotDistanceFreqAttenuationFilter";
    };

    class gau_GAU8_AirframeResponse_SoundSet
    {
        soundShaders[] =
        {
            "gau_GAU8_AirframeResponse_SoundShader"
        };

        volumeFactor = 0.40;
        volumeCurve = "InverseSquare2Curve";

        spatial = 1;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "weaponShotDistanceFreqAttenuationFilter";
    };

    class gau_GAU8_CloseBodyReal_SoundSet
    {
        soundShaders[] =
        {
            "gau_GAU8_CloseBodyReal_SoundShader"
        };

        volumeFactor = 1;
        volumeCurve = "InverseSquare2Curve";

        spatial = 1;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "weaponShotDistanceFreqAttenuationFilter";
    };

    class gau_GAU8_CloseRecorded_SoundSet
    {
        soundShaders[] =
        {
            "gau_GAU8_CloseRecorded_SoundShader"
        };

        volumeFactor = 3.2;
        volumeCurve = "gau_GAU8_CloseRecordedSetCurve";

        spatial = 1;
        spatialityRange = 15;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "gau_GAU8_CannonDistanceFilter";
    };

};

class Mode_FullAuto;
class BaseSoundModeType;

class CfgWeapons
{
    class CannonCore;

    class Gatling_30mm_Plane_CAS_01_F: CannonCore
    {
        displayName = "GAU-8/A Avenger";

        magazines[] =
        {
            "gau_gau8_1000Rnd_Gatling_30mm_Plane_CAS_01_F_ripSilent",
            "1000Rnd_Gatling_30mm_Plane_CAS_01_F"
        };

        class LowROF: Mode_FullAuto
        {
            displayName = "GAU-8/A Avenger Low ROF";

            sounds[] = {"StandardSound"};
            soundContinuous = 0;
            soundBurst = 0;


            reloadTime = 0.0153846;


            burst = 39;

            class StandardSound: BaseSoundModeType
            {


                soundSetShot[] = {};
            };
        };
    };
};

class CfgFunctions
{
    class gau_gau8
    {
        tag = "gau_gau8";

        class main
        {
            file = "\z\gau\addons\main\functions";

            class preInit
            {
                preInit = 1;
            };

            class vanillaPostInit
            {
                postInit = 1;
            };

            class calculateShockGeometry
            {
            };

            class getAcousticState
            {
            };

            class getEnvironmentState
            {
            };

            class playRipReflectionField
            {
            };

            class queueSoundArrival
            {
            };

            class cancelMRPending
            {
            };
class registerRipShot {};

            class runRipStream {};


            class runRipMagazineSwapWorker {};
            class registerRipMagazineMapping {};
            class clientInit
            {
                postInit = 1;
            };
            class registerWeapon
            {
            };

            class registerRipAmmo
            {
            };

            class installGrainHandler
            {
            };
        };
    };
};

class CfgAmmo
{
    class Gatling_30mm_HE_Plane_CAS_01_F;

    class gau_gau8_Gatling_30mm_HE_Plane_CAS_01_F_ripSilent:
        Gatling_30mm_HE_Plane_CAS_01_F
    {
        soundSetSonicCrack[] = {};
        soundSetBulletFly[] = {};
        soundFly[] = {"", 0, 1};
        supersonicCrackNear[] = {"", 0, 1, 1};
        supersonicCrackFar[] = {"", 0, 1, 1};

        soundSetExplosion[] =
        {
            "gau_GAU8_ImpactHE_SoundSet"
        };

        soundHit[] = {"", 0, 1};
        soundHit1[] = {"", 0, 1};
        soundHit2[] = {"", 0, 1};
        soundHit3[] = {"", 0, 1};
        soundHit4[] = {"", 0, 1};
        soundHit5[] = {"", 0, 1};

        gau_gau8_ripCrackSuppression = 40;
    };
};

class CfgMagazines
{
    class 1000Rnd_Gatling_30mm_Plane_CAS_01_F;

    class gau_gau8_1000Rnd_Gatling_30mm_Plane_CAS_01_F_ripSilent:
        1000Rnd_Gatling_30mm_Plane_CAS_01_F
    {
        ammo =
            "gau_gau8_Gatling_30mm_HE_Plane_CAS_01_F_ripSilent";
    };
};
