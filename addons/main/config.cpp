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

class CfgDistanceFilters
{
    class big_GAU8_CannonDistanceFilter
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
    // Far layer fades in between approximately 300 and 750 metres.
    class big_GAU8_FarShaderCurve
    {
        points[] =
        {
            {0.00, 1.00},
            {1.00, 1.00}
        };
    };

    // Far-layer output remains strong through the middle distance,
    // then falls to zero at the configured maximum range.
    class big_GAU8_FarSetCurve
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
    class big_GAU8_FarPulseShaderCurve
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

    class big_GAU8_FarPulseSetCurve
    {
        points[] =
        {
            {0.00, 1.00},
            {0.65, 1.00},
            {0.85, 0.65},
            {1.00, 0.00}
        };
    };
    class big_GAU8_MidReportShaderCurve
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

    class big_GAU8_MidReportSetCurve
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
    class big_GAU8_CloseRecordedSetCurve
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
        range = 300;
        rangeCurve = "closeShotCurve";
    };

    class big_GAU8_FarPulse_SoundShader
    {
        samples[] =
        {
            {"\z\big\addons\main\sounds\cannon\far_pulse_1.wav", 1},
            {"\z\big\addons\main\sounds\cannon\far_pulse_2.wav", 1},
            {"\z\big\addons\main\sounds\cannon\far_pulse_3.wav", 1},
            {"\z\big\addons\main\sounds\cannon\far_pulse_4.wav", 1}
        };

        volume = 1;
        range = 3000;
        rangeCurve = "big_GAU8_FarPulseShaderCurve";
    };
    class big_GAU8_CloseTransient_SoundShader
    {
        samples[] =
        {
            {"\z\big\addons\main\sounds\cannon\close_transient_1.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_transient_2.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_transient_3.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_transient_4.wav", 1}
        };

        volume = 1;
        range = 220;
        rangeCurve = "closeShotCurve";
    };
    class big_GAU8_CloseMechanical_SoundShader
    {
        samples[] =
        {
            {"\z\big\addons\main\sounds\cannon\close_mechanical_1.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_mechanical_2.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_mechanical_3.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_mechanical_4.wav", 1}
        };

        volume = 1;
        range = 100;
        rangeCurve = "closeShotCurve";
    };

    class big_GAU8_MidReport_SoundShader
    {
        samples[] =
        {
            {"\z\big\addons\main\sounds\cannon\mid_report_1.wav", 1},
            {"\z\big\addons\main\sounds\cannon\mid_report_2.wav", 1},
            {"\z\big\addons\main\sounds\cannon\mid_report_3.wav", 1},
            {"\z\big\addons\main\sounds\cannon\mid_report_4.wav", 1}
        };

        volume = 1;
        range = 1200;
        rangeCurve = "big_GAU8_MidReportShaderCurve";
    };

    class big_GAU8_AirframeResponse_SoundShader
    {
        samples[] =
        {
            {"\z\big\addons\main\sounds\cannon\airframe_response_1.wav", 1},
            {"\z\big\addons\main\sounds\cannon\airframe_response_2.wav", 1},
            {"\z\big\addons\main\sounds\cannon\airframe_response_3.wav", 1},
            {"\z\big\addons\main\sounds\cannon\airframe_response_4.wav", 1}
        };

        volume = 1;
        range = 70;
        rangeCurve = "closeShotCurve";
    };

    class big_GAU8_CloseBodyReal_SoundShader
    {
        samples[] =
        {
            {"\z\big\addons\main\sounds\cannon\close_body_real_1.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_body_real_2.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_body_real_3.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_body_real_4.wav", 1}
        };

        volume = 1;
        range = 300;
        rangeCurve = "closeShotCurve";
    };

    class big_GAU8_CloseRecorded_SoundShader
    {
        samples[] =
        {
            {"\z\big\addons\main\sounds\cannon\close_cell_01.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_02.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_03.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_04.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_05.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_06.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_07.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_08.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_09.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_10.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_11.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_12.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_13.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_14.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_15.wav", 1},
            {"\z\big\addons\main\sounds\cannon\close_cell_16.wav", 1}
        };

        volume = 1;
        range = 2000;
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
        volumeCurve = "InverseSquare2Curve";

        spatial = 1;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "weaponShotDistanceFreqAttenuationFilter";
    };

    class big_GAU8_FarPulse_SoundSet
    {
        soundShaders[] =
        {
            "big_GAU8_FarPulse_SoundShader"
        };

        volumeFactor = 0.55;
        volumeCurve = "big_GAU8_FarPulseSetCurve";

        spatial = 1;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "none";
    };
    class big_GAU8_CloseTransient_SoundSet
    {
        soundShaders[] =
        {
            "big_GAU8_CloseTransient_SoundShader"
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
    class big_GAU8_CloseMechanical_SoundSet
    {
        soundShaders[] =
        {
            "big_GAU8_CloseMechanical_SoundShader"
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

    class big_GAU8_MidReport_SoundSet
    {
        soundShaders[] =
        {
            "big_GAU8_MidReport_SoundShader"
        };

        volumeFactor = 0.65;
        volumeCurve = "big_GAU8_MidReportSetCurve";

        spatial = 1;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "weaponShotDistanceFreqAttenuationFilter";
    };

    class big_GAU8_AirframeResponse_SoundSet
    {
        soundShaders[] =
        {
            "big_GAU8_AirframeResponse_SoundShader"
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

    class big_GAU8_CloseBodyReal_SoundSet
    {
        soundShaders[] =
        {
            "big_GAU8_CloseBodyReal_SoundShader"
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

    class big_GAU8_CloseRecorded_SoundSet
    {
        soundShaders[] =
        {
            "big_GAU8_CloseRecorded_SoundShader"
        };

        volumeFactor = 3.2;
        volumeCurve = "big_GAU8_CloseRecordedSetCurve";

        spatial = 1;
        spatialityRange = 15;
        doppler = 1;
        speedOfSound = 1;
        loop = 0;

        sound3DProcessingType = "WeaponMediumShot3DProcessingType";
        distanceFilter = "big_GAU8_CannonDistanceFilter";
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
            soundBurst = 0;

            // 3,900 RPM / 65 rounds per second.
            reloadTime = 0.0153846;

            // Preserve an approximately 0.6-second minimum burst.
            burst = 39;

            class StandardSound: BaseSoundModeType
            {
                /*
                    Accepted body, mechanical, and muzzle files are emitted
                    by the scripted propagation scheduler. Per-projectile
                    SoundSets would stack 0.48-second grains at 65 Hz.
                */
                soundSetShot[] = {};
            };
        };
    };
};
class CfgFunctions
{
    class big_gau8
    {
        tag = "big_gau8";

        class main
        {
            file = "\z\big\addons\main\functions";

            class calculateShockGeometry
            {
            };

            class getAcousticState
            {
            };

            class queueSoundArrival
            {
            };

            class clientInit
            {
                postInit = 1;
            };
            class installGrainHandler
            {
            };
        };
    };
};
