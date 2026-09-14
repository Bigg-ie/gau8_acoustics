params ["_aircraft"];

if (!hasInterface) exitWith
{
    -1
};

if (isNull _aircraft) exitWith
{
    -1
};

private _oldHandler =
    _aircraft getVariable
    [
        "gau_gau8_firedHandler",
        -1
    ];

if (_oldHandler >= 0) then
{
    _aircraft removeEventHandler
    [
        "Fired",
        _oldHandler
    ];
};

private _oldSource =
    _aircraft getVariable
    [
        "gau_gau8_farBodySource",
        objNull
    ];

if (!isNull _oldSource) then
{
    deleteVehicle _oldSource;
};

private _oldIDs =
    _aircraft getVariable
    [
        "gau_gau8_grainIDs",
        []
    ];

{
    if (_x >= 0) then
    {
        stopSound _x;
    };
}
forEach _oldIDs;

private _generation =
    (
        _aircraft getVariable
        [
            "gau_gau8_handlerGeneration",
            0
        ]
    ) + 1;

_aircraft setVariable
[
    "gau_gau8_handlerGeneration",
    _generation
];

_aircraft setVariable
[
    "gau_gau8_grainPaths",
    [
        "z\gau\addons\main\sounds\cannon\far_body_grain_1.wav",
        "z\gau\addons\main\sounds\cannon\far_body_grain_2.wav",
        "z\gau\addons\main\sounds\cannon\far_body_grain_3.wav",
        "z\gau\addons\main\sounds\cannon\far_body_grain_4.wav",
        "z\gau\addons\main\sounds\cannon\far_body_grain_5.wav",
        "z\gau\addons\main\sounds\cannon\far_body_grain_6.wav"
    ]
];

_aircraft setVariable
[
    "gau_gau8_startPath",
    "z\gau\addons\main\sounds\cannon\far_body_start.wav"
];

_aircraft setVariable
[
    "gau_gau8_endPath",
    "z\gau\addons\main\sounds\cannon\far_body_end.wav"
];

_aircraft setVariable
[
    "gau_gau8_midBodyPaths",
    [
        "z\gau\addons\main\sounds\cannon\mid_body_grain_1.wav",
        "z\gau\addons\main\sounds\cannon\mid_body_grain_2.wav",
        "z\gau\addons\main\sounds\cannon\mid_body_grain_3.wav",
        "z\gau\addons\main\sounds\cannon\mid_body_grain_4.wav",
        "z\gau\addons\main\sounds\cannon\mid_body_grain_5.wav",
        "z\gau\addons\main\sounds\cannon\mid_body_grain_6.wav"
    ]
];

_aircraft setVariable
[
    "gau_gau8_midBodyStartPath",
    "z\gau\addons\main\sounds\cannon\mid_body_start.wav"
];

_aircraft setVariable
[
    "gau_gau8_midBodyEndPath",
    "z\gau\addons\main\sounds\cannon\mid_body_end.wav"
];
_aircraft setVariable
[
    "gau_gau8_closeBodyPaths",
    [
        "z\gau\addons\main\sounds\cannon\close_body_grain_1.wav",
        "z\gau\addons\main\sounds\cannon\close_body_grain_2.wav",
        "z\gau\addons\main\sounds\cannon\close_body_grain_3.wav",
        "z\gau\addons\main\sounds\cannon\close_body_grain_4.wav",
        "z\gau\addons\main\sounds\cannon\close_body_grain_5.wav",
        "z\gau\addons\main\sounds\cannon\close_body_grain_6.wav"
    ]
];

_aircraft setVariable
[
    "gau_gau8_closeBodyStartPath",
    "z\gau\addons\main\sounds\cannon\close_body_start.wav"
];

_aircraft setVariable
[
    "gau_gau8_closeBodyEndPath",
    "z\gau\addons\main\sounds\cannon\close_body_end.wav"
];
_aircraft setVariable
[
    "gau_gau8_mrCloseStartPath",
    "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_start_close.wav"
];
_aircraft setVariable
[
    "gau_gau8_mrCloseGrainPaths",
    [
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_close_00.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_close_01.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_close_02.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_close_03.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_close_04.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_close_05.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_close_06.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_close_07.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_close_08.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_close_09.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_close_10.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_close_11.wav"
    ]
];
_aircraft setVariable
[
    "gau_gau8_mrCloseReleasePaths",
    [
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p00.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p01.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p02.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p03.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p04.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p05.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p06.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p07.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p08.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p09.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p10.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p11.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p12.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p13.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p14.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p15.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p16.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p17.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p18.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p19.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p20.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p21.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p22.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p23.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p24.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p25.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p26.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p27.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p28.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p29.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p30.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p31.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p32.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p33.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p34.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p35.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p36.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p37.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p38.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p39.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p40.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p41.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p42.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p43.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p44.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_close_p45.wav"
    ]
];
_aircraft setVariable
[
    "gau_gau8_mrMidStartPath",
    "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_start_mid.wav"
];
_aircraft setVariable
[
    "gau_gau8_mrMidGrainPaths",
    [
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_mid_00.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_mid_01.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_mid_02.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_mid_03.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_mid_04.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_mid_05.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_mid_06.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_mid_07.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_mid_08.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_mid_09.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_mid_10.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_mid_11.wav"
    ]
];
_aircraft setVariable
[
    "gau_gau8_mrMidReleasePaths",
    [
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p00.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p01.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p02.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p03.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p04.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p05.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p06.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p07.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p08.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p09.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p10.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p11.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p12.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p13.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p14.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p15.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p16.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p17.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p18.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p19.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p20.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p21.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p22.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p23.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p24.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p25.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p26.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p27.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p28.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p29.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p30.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p31.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p32.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p33.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p34.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p35.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p36.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p37.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p38.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p39.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p40.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p41.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p42.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p43.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p44.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_mid_p45.wav"
    ]
];
_aircraft setVariable
[
    "gau_gau8_mrFarStartPath",
    "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_start_far.wav"
];
_aircraft setVariable
[
    "gau_gau8_mrFarGrainPaths",
    [
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_far_00.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_far_01.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_far_02.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_far_03.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_far_04.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_far_05.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_far_06.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_far_07.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_far_08.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_far_09.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_far_10.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_v27_23_grain_far_11.wav"
    ]
];
_aircraft setVariable
[
    "gau_gau8_mrFarReleasePaths",
    [
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p00.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p01.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p02.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p03.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p04.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p05.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p06.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p07.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p08.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p09.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p10.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p11.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p12.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p13.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p14.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p15.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p16.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p17.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p18.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p19.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p20.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p21.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p22.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p23.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p24.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p25.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p26.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p27.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p28.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p29.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p30.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p31.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p32.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p33.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p34.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p35.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p36.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p37.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p38.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p39.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p40.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p41.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p42.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p43.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p44.wav",
        "z\gau\addons\main\sounds\cannon\mr_v27_11\mr_body_release_far_p45.wav"
    ]
];


_aircraft setVariable
[
    "gau_gau8_v27_23MRSourceOffsets",
    [0.000000000, 0.427416667, 0.854833333, 1.282250000, 1.709666667, 2.137083333, 2.564500000, 2.991916667, 3.419333333, 3.846750000, 4.274166667, 4.701583333]
];

_aircraft setVariable
[
    "gau_gau8_closeMechanicalPaths",
    [
        "z\gau\addons\main\sounds\cannon\close_mechanical_grain_1.wav",
        "z\gau\addons\main\sounds\cannon\close_mechanical_grain_2.wav",
        "z\gau\addons\main\sounds\cannon\close_mechanical_grain_3.wav",
        "z\gau\addons\main\sounds\cannon\close_mechanical_grain_4.wav",
        "z\gau\addons\main\sounds\cannon\close_mechanical_grain_5.wav",
        "z\gau\addons\main\sounds\cannon\close_mechanical_grain_6.wav"
    ]
];

_aircraft setVariable
[
    "gau_gau8_closeMechanicalStartPath",
    "z\gau\addons\main\sounds\cannon\close_mechanical_start.wav"
];

_aircraft setVariable
[
    "gau_gau8_closeMuzzlePath",
    "z\gau\addons\main\sounds\cannon\close_muzzle_blast.wav"
];

_aircraft setVariable
[
    "gau_gau8_cockpitBodyPaths",
    [
        "z\gau\addons\main\sounds\cannon\cockpit_body_grain_1.wav",
        "z\gau\addons\main\sounds\cannon\cockpit_body_grain_2.wav",
        "z\gau\addons\main\sounds\cannon\cockpit_body_grain_3.wav",
        "z\gau\addons\main\sounds\cannon\cockpit_body_grain_4.wav",
        "z\gau\addons\main\sounds\cannon\cockpit_body_grain_5.wav",
        "z\gau\addons\main\sounds\cannon\cockpit_body_grain_6.wav"
    ]
];

_aircraft setVariable
[
    "gau_gau8_cockpitBodyStartPath",
    "z\gau\addons\main\sounds\cannon\cockpit_body_start.wav"
];

_aircraft setVariable
[
    "gau_gau8_cockpitBodyEndPath",
    "z\gau\addons\main\sounds\cannon\cockpit_body_end.wav"
];

_aircraft setVariable
[
    "gau_gau8_cockpitAirframePaths",
    [
        "z\gau\addons\main\sounds\cannon\cockpit_airframe_grain_1.wav",
        "z\gau\addons\main\sounds\cannon\cockpit_airframe_grain_2.wav",
        "z\gau\addons\main\sounds\cannon\cockpit_airframe_grain_3.wav",
        "z\gau\addons\main\sounds\cannon\cockpit_airframe_grain_4.wav",
        "z\gau\addons\main\sounds\cannon\cockpit_airframe_grain_5.wav",
        "z\gau\addons\main\sounds\cannon\cockpit_airframe_grain_6.wav"
    ]
];

_aircraft setVariable
[
    "gau_gau8_cockpitAirframeStartPath",
    "z\gau\addons\main\sounds\cannon\cockpit_airframe_start.wav"
];

_aircraft setVariable
[
    "gau_gau8_cockpitAirframeEndPath",
    "z\gau\addons\main\sounds\cannon\cockpit_airframe_end.wav"
];


_aircraft setVariable
[
    "gau_gau8_playCockpitSound",
    {
        params
        [
            "_vehicle",
            "_path",
            "_volume",
            ["_pitch", 1.0]
        ];

        if (
            isNull _vehicle ||
            {_path isEqualTo ""} ||
            {_volume <= 0.000001}
        ) exitWith
        {
            -1
        };

        private _soundID =
            playSoundUI
            [
                _path,
                (_volume max 0) min 5,
                _pitch,
                true
            ];

        if (_soundID >= 0) then
        {
            private _ids =
                _vehicle getVariable
                [
                    "gau_gau8_grainIDs",
                    []
                ];

            _ids pushBack _soundID;

            while {(count _ids) > 160} do
            {
                _ids deleteAt 0;
            };

            _vehicle setVariable
            [
                "gau_gau8_grainIDs",
                _ids
            ];
        };

        _soundID
    }
];

_aircraft setVariable
[
    "gau_gau8_grainIDs",
    []
];

_aircraft setVariable
[
    "gau_gau8_arrivalQueue",
    []
];

_aircraft setVariable
[
    "gau_gau8_arrivalWorkerRunning",
    false
];

_aircraft setVariable
[
    "gau_gau8_arrivalWorkerToken",
    0
];

_aircraft setVariable
[
    "gau_gau8_reportBurstClock",
    []
];

_aircraft setVariable
[
    "gau_gau8_lastGrainIndex",
    -1
];

_aircraft setVariable ["gau_gau8_v27_23LastMRGrainTick", -1];
_aircraft setVariable ["gau_gau8_v27_23LastMRSourceOffset", 0];
_aircraft setVariable ["gau_gau8_v27_23LastMRPitch", 1.0];
_aircraft setVariable ["gau_gau8_v27_23MRCycleDuration", 5.129];

_aircraft setVariable
[
    "gau_gau8_shotCount",
    0
];

_aircraft setVariable
[
    "gau_gau8_nextGrainTick",
    -1
];
_aircraft setVariable
[
    "gau_gau8_nextMechanicalGrainTick",
    -1
];

_aircraft setVariable
[
    "gau_gau8_mrBurstToken",
    0
];

_aircraft setVariable
[
    "gau_gau8_mrBurstStartTick",
    -1
];

_aircraft setVariable
[
    "gau_gau8_mrNextOrdinal",
    0
];

_aircraft setVariable
[
    "gau_gau8_mrSustainArmed",
    false
];

_aircraft setVariable
[
    "gau_gau8_mrReleasePending",
    false
];

_aircraft setVariable
[
    "gau_gau8_mrReleaseBoundaryTick",
    -1
];

_aircraft setVariable
[
    "gau_gau8_mrCancelSerial",
    0
];

_aircraft setVariable
[
    "gau_gau8_mrPhase0Offset",
    0.6493333333333333
];

_aircraft setVariable
[
    "gau_gau8_mrPhaseStep",
    0.1115
];

_aircraft setVariable
[
    "gau_gau8_mrReleaseGuard",
    0.14
];

_aircraft setVariable
[
    "gau_gau8_monitorRunning",
    false
];

_aircraft setVariable
[
    "gau_gau8_lastEmissionPositionASL",
    getPosASL _aircraft
];

_aircraft setVariable
[
    "gau_gau8_lastArrivalTime",
    time
];

_aircraft setVariable
[
    "gau_gau8_cockpitMix",
    0.0
];

_aircraft setVariable
[
    "gau_gau8_lastCockpitBodyGain",
    0.0
];

_aircraft setVariable
[
    "gau_gau8_lastCockpitAirframeGain",
    0.0
];

_aircraft setVariable
[
    "gau_gau8_nextCockpitGrainTick",
    -1
];

_aircraft setVariable
[
    "gau_gau8_lastCockpitGrainIndex",
    -1
];
_aircraft setVariable
[
    "gau_gau8_lastReflectionGain",
    0.0
];

_aircraft setVariable
[
    "gau_gau8_lastReflectionPositionASL",
    getPosASL _aircraft
];

_aircraft setVariable
[
    "gau_gau8_lastReflectionArrivalTime",
    time
];

_aircraft setVariable
[
    "gau_gau8_environmentCache",
    []
];

private _emitSustain =
    compile preprocessFileLineNumbers
    "z\gau\addons\main\functions\fn_emitSustain.sqf";

_aircraft setVariable
[
    "gau_gau8_emitSustain",
    _emitSustain
];


_aircraft setVariable
[
    "gau_gau8_impactClusterRunning",
    false
];

_aircraft setVariable
[
    "gau_gau8_impactEventCount",
    0
];

private _handler =
    _aircraft addEventHandler
    [
        "Fired",
        {
            params
            [
                "_vehicle",
                "_weapon",
                "_muzzle",
                "_mode",
                "_ammo",
                "_magazine",
                "_projectile",
                "_gunner"
            ];

            private _weaponRegistry =
                missionNamespace getVariable
                [
                    "gau_gau8_weaponRegistry",
                    [
                        [
                            "Gatling_30mm_Plane_CAS_01_F",
                            [
                                "LowROF",
                                "close",
                                "short",
                                "medium",
                                "far"
                            ]
                        ]
                    ]
                ];

            private _weaponEntryIndex =
                _weaponRegistry findIf
                {
                    (_x select 0) isEqualTo _weapon
                };

            if (_weaponEntryIndex < 0) exitWith {};

            private _allowedModes =
                (
                    _weaponRegistry
                    select _weaponEntryIndex
                )
                select 1;
            private _modeAccepted =
                "*" in _allowedModes;

            if (!_modeAccepted) then
            {
                _modeAccepted =
                    _mode in _allowedModes;
            };

            if (!_modeAccepted) exitWith {};
            private _impactAmmoClasses =
                (
                    _weaponRegistry
                    select _weaponEntryIndex
                )
                param
                [
                    2,
                    []
                ];

            if (
                !isNull _projectile &&
                {_ammo in _impactAmmoClasses}
            ) then
            {
                _projectile setVariable
                [
                    "gau_gau8_impactVehicle",
                    _vehicle
                ];


            };

            private _shotTick = diag_tickTime;

            _vehicle setVariable
            [
                "gau_gau8_lastShotTick",
                _shotTick
            ];

            private _shotCount =
                _vehicle getVariable
                [
                    "gau_gau8_shotCount",
                    0
                ];

            if (_shotCount == 0) then
            {
                private _newBurstToken =
                    (_vehicle getVariable ["gau_gau8_mrBurstToken", 0]) + 1;

                _vehicle setVariable ["gau_gau8_mrBurstToken", _newBurstToken];
                _vehicle setVariable ["gau_gau8_mrBurstStartTick", _shotTick];
                _vehicle setVariable ["gau_gau8_lastGrainIndex", -1];
                _vehicle setVariable ["gau_gau8_v27_23LastMRGrainTick", -1];
                _vehicle setVariable ["gau_gau8_v27_23LastMRSourceOffset", 0];
                _vehicle setVariable ["gau_gau8_v27_23LastMRPitch", 1.0];


                _vehicle setVariable ["gau_gau8_nextGrainTick", _shotTick + (9 / 65)];
                _vehicle setVariable ["gau_gau8_nextMechanicalGrainTick", _shotTick + (9 / 65)];
                _vehicle setVariable ["gau_gau8_nextCockpitGrainTick", _shotTick + 0.24];
            };

            private _acousticState =
                [
                    _vehicle,
                    _projectile
                ]
                call gau_gau8_fnc_getAcousticState;

            _acousticState params
            [
                "_listenerPositionASL",
                "_emissionPositionASL",
                "_listenerDistance",
                "_propagationDelay",
                "_distanceGain",
                "_closeBodyGain",
                "_midBodyGain",
                "_farBodyGain",
                "_mechanicalGain",
                "_muzzleGain",
                "_forwardDot",
                "_offAxisAngle",
                "_closeBodyDirectivity",
                "_midBodyDirectivity",
                "_farBodyDirectivity",
                "_mechanicalDirectivity",
                "_muzzleDirectivity",
                "_cameraMode",
                "_cockpitTarget",
                "_cockpitMix",
                "_externalMix",
                "_cockpitBodyGain",
                "_cockpitAirframeGain",
                "_terrainOcclusion",
                "_objectOcclusion",
                "_combinedOcclusion",
                "_reflectionGain",
                "_reflectionPositionASL",
                "_reflectionPropagationDelay",
                "_reflectionExtraDelay",
                "_sourceHeightAGL",
                "_listenerHeightAGL",
                "_objectHitCount"
            ];

            private _arrivalTime = time + _propagationDelay;


            _vehicle setVariable
            [
                "gau_gau8_lastEmissionPositionASL",
                +_emissionPositionASL
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastArrivalTime",
                _arrivalTime
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastMuzzleGain",
                _muzzleGain
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastListenerDistance",
                _listenerDistance
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastPropagationDelay",
                _propagationDelay
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastDistanceGain",
                _distanceGain
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastCloseGain",
                _closeBodyGain
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastMidBodyGain",
                _midBodyGain
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastFarBodyGain",
                _farBodyGain
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastMechanicalGain",
                _mechanicalGain
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastForwardDot",
                _forwardDot
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastOffAxisAngle",
                _offAxisAngle
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastDirectivity",
                [
                    _closeBodyDirectivity,
                    _midBodyDirectivity,
                    _farBodyDirectivity,
                    _mechanicalDirectivity,
                    _muzzleDirectivity
                ]
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastCockpitBodyGain",
                _cockpitBodyGain
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastCockpitAirframeGain",
                _cockpitAirframeGain
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastCockpitMix",
                _cockpitMix
            ];

            private _reflectionArrivalTime =
                time + _reflectionPropagationDelay;

            _vehicle setVariable
            [
                "gau_gau8_lastEnvironmentState",
                [
                    _terrainOcclusion,
                    _objectOcclusion,
                    _combinedOcclusion,
                    _reflectionGain,
                    _reflectionExtraDelay,
                    _sourceHeightAGL,
                    _listenerHeightAGL,
                    _objectHitCount
                ]
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastReflectionGain",
                _reflectionGain
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastReflectionPositionASL",
                +_reflectionPositionASL
            ];

            _vehicle setVariable
            [
                "gau_gau8_lastReflectionArrivalTime",
                _reflectionArrivalTime
            ];

            if
            (
                _shotCount == 0 &&
                {
                    _vehicle getVariable
                    [
                        "gau_gau8_debugDirectivity",
                        false
                    ]
                }
            ) then
            {
                private _directivityMessage = format
                [
                    "GAU-8 directivity: angle=%1 deg | close=%2 mid=%3 far=%4 mech=%5 muzzle=%6",
                    (_offAxisAngle toFixed 1),
                    (_closeBodyDirectivity toFixed 3),
                    (_midBodyDirectivity toFixed 3),
                    (_farBodyDirectivity toFixed 3),
                    (_mechanicalDirectivity toFixed 3),
                    (_muzzleDirectivity toFixed 3)
                ];

                systemChat _directivityMessage;
                diag_log _directivityMessage;
            };

            if
            (
                _shotCount == 0 &&
                {
                    _vehicle getVariable
                    [
                        "gau_gau8_debugCockpit",
                        false
                    ]
                }
            ) then
            {
                private _cockpitMessage = format
                [
                    "GAU-8 cockpit: mode=%1 target=%2 mix=%3 external=%4 body=%5 airframe=%6",
                    _cameraMode,
                    _cockpitTarget,
                    (_cockpitMix toFixed 3),
                    (_externalMix toFixed 3),
                    (_cockpitBodyGain toFixed 3),
                    (_cockpitAirframeGain toFixed 3)
                ];

                systemChat _cockpitMessage;
                diag_log _cockpitMessage;
            };


            if (
                _shotCount == 0 &&
                {!isNull _projectile}
            ) then
            {
                private _shockGeometry =
                    [
                        getPosASL _projectile,
                        velocity _projectile,
                        _listenerPositionASL,
                        343.0
                    ]
                    call gau_gau8_fnc_calculateShockGeometry;

                _vehicle setVariable
                [
                    "gau_gau8_lastShockGeometry",
                    _shockGeometry
                ];

                if (
                    _vehicle getVariable
                    [
                        "gau_gau8_debugShock",
                        false
                    ] &&
                    {(count _shockGeometry) == 10}
                ) then
                {
                    _shockGeometry params
                    [
                        "_shockDistinct",
                        "_shockDownrange",
                        "_shockCrossTrack",
                        "_shockProjectileSpeed",
                        "_shockMach",
                        "_shockMinimumDownrange",
                        "_muzzleArrival",
                        "_shockArrival",
                        "_shockSeparation",
                        "_shockEmissionPosition"
                    ];

                    private _message = format
                    [
                        "GAU-8 shock: distinct=%1, x=%2 m, d=%3 m, Mach=%4, separation=%5 ms",
                        _shockDistinct,
                        _shockDownrange,
                        _shockCrossTrack,
                        _shockMach,
                        _shockSeparation * 1000
                    ];

                    systemChat _message;

                    diag_log format
                    [
                        "GAU8 LIVE SHOCK: %1 | speed=%2 m/s | minimumX=%3 m | muzzleArrival=%4 s | shockArrival=%5 s | emission=%6",
                        _message,
                        _shockProjectileSpeed,
                        _shockMinimumDownrange,
                        _muzzleArrival,
                        _shockArrival,
                        _shockEmissionPosition
                    ];
                };
            };

            if (_shotCount == 0) then
            {
                private _mechanicalStartPath =
                    _vehicle getVariable
                    [
                        "gau_gau8_closeMechanicalStartPath",
                        ""
                    ];

                private _muzzlePath =
                    _vehicle getVariable
                    [
                        "gau_gau8_closeMuzzlePath",
                        ""
                    ];
                private _cockpitBodyStartPath =
                    _vehicle getVariable
                    [
                        "gau_gau8_cockpitBodyStartPath",
                        ""
                    ];

                private _cockpitAirframeStartPath =
                    _vehicle getVariable
                    [
                        "gau_gau8_cockpitAirframeStartPath",
                        ""
                    ];
private _playCockpitSound =
                    _vehicle getVariable
                    [
                        "gau_gau8_playCockpitSound",
                        {}
                    ];

                private _mrMaster =
                    (
                        _vehicle getVariable
                        [
                            "gau_gau8_mrAttackMaster",
                            missionNamespace getVariable ["gau_gau8_mrAttackMasterDefault", 5.0]
                        ]
                    ) max 0 min 5;

                private _mrAttackVoices =
                [
                    ["gau_gau8_mrCloseStartPath", _closeBodyGain],
                    ["gau_gau8_mrMidStartPath", _midBodyGain],
                    ["gau_gau8_mrFarStartPath", _farBodyGain]
                ];

                {
                    _x params ["_pathVariable", "_bodyGain"];

                    if (_bodyGain > 0.000001) then
                    {
                        private _mrStartPath =
                            _vehicle getVariable [_pathVariable, ""];

                        [
                            _vehicle,
                            _mrStartPath,
                            _emissionPositionASL,
                            _arrivalTime,
                            _mrMaster * _bodyGain,
                            1.0,
                            50000
                        ]
                        call gau_gau8_fnc_queueSoundArrival;
                    };
                }
                forEach _mrAttackVoices;

                [
                    _vehicle,
                    _mechanicalStartPath,
                    _emissionPositionASL,
                    _arrivalTime,
                    4.8 * _mechanicalGain,
                    1.0,
                    500
                ]
                call gau_gau8_fnc_queueSoundArrival;

                [
                    _vehicle,
                    _muzzlePath,
                    _emissionPositionASL,
                    _arrivalTime,
                    4.8 * _muzzleGain,
                    1.0,
                    2000
                ]
                call gau_gau8_fnc_queueSoundArrival;
[
                    _vehicle,
                    _cockpitBodyStartPath,
                    1.85 * _cockpitBodyGain,
                    1.0
                ]
                call _playCockpitSound;

                [
                    _vehicle,
                    _cockpitAirframeStartPath,
                    2.05 * _cockpitAirframeGain,
                    1.0
                ]
                call _playCockpitSound;
            };

            _vehicle setVariable
            [
                "gau_gau8_shotCount",
                _shotCount + 1
            ];

            private _running =
                _vehicle getVariable ["gau_gau8_monitorRunning", false];

            if (!_running) then
            {
                _vehicle setVariable ["gau_gau8_monitorRunning", true];

                private _generation =
                    _vehicle getVariable ["gau_gau8_handlerGeneration", 0];

                [_vehicle, _generation] spawn
                {
                    params ["_vehicle", "_generation"];

                    private _finished = false;

                    while {!_finished} do
                    {
                        uiSleep 0.01;

                        if (isNull _vehicle) then
                        {
                            _finished = true;
                        }
                        else
                        {
                            private _currentGeneration =
                                _vehicle getVariable ["gau_gau8_handlerGeneration", -1];

                            if (_currentGeneration != _generation) then
                            {
                                _finished = true;
                            }
                            else
                            {


                                private _emitSustain =
                                    _vehicle getVariable ["gau_gau8_emitSustain", {}];

                                [_vehicle] call _emitSustain;

                                private _lastShotTick =
                                    _vehicle getVariable ["gau_gau8_lastShotTick", -1000];

                                private _burstTimeout =
                                    (_vehicle getVariable ["gau_gau8_burstTimeout", 0.18])
                                    max 0.14 min 0.35;

                                if ((diag_tickTime - _lastShotTick) > _burstTimeout) then
                                {
                                    _finished = true;
                                };
                            };
                        };
                    };

                    if (!isNull _vehicle) then
                    {
                        private _currentGeneration =
                            _vehicle getVariable ["gau_gau8_handlerGeneration", -1];

                        if (_currentGeneration == _generation) then
                        {


                            private _releasePosition =
                                _vehicle getVariable
                                [
                                    "gau_gau8_lastEmissionPositionASL",
                                    getPosASL _vehicle
                                ];

                            private _releaseArrival =
                                _vehicle getVariable ["gau_gau8_lastArrivalTime", time];

                            private _releaseCloseGain =
                                _vehicle getVariable ["gau_gau8_lastCloseGain", 0];

                            private _releaseMidGain =
                                _vehicle getVariable ["gau_gau8_lastMidBodyGain", 0];

                            if (_releaseMidGain <= 0.000001) then
                            {
                                _releaseMidGain =
                                    _vehicle getVariable ["gau_gau8_lastMidGain", 0];
                            };

                            private _releaseFarGain =
                                _vehicle getVariable ["gau_gau8_lastFarBodyGain", 0];

                            if (_releaseFarGain <= 0.000001) then
                            {
                                _releaseFarGain =
                                    _vehicle getVariable ["gau_gau8_lastFarGain", 0];
                            };

                            private _lastMRGrainTick =
                                _vehicle getVariable ["gau_gau8_v27_23LastMRGrainTick", -1];

                            private _sourceOffset =
                                _vehicle getVariable ["gau_gau8_v27_23LastMRSourceOffset", 0];

                            private _lastMRPitch =
                                _vehicle getVariable ["gau_gau8_v27_23LastMRPitch", 1.0];

                            private _cycleDuration =
                                _vehicle getVariable ["gau_gau8_v27_23MRCycleDuration", 5.129];

                            private _phaseStep = 0.1115;
                            private _phaseTime = 0;

                            if (_lastMRGrainTick >= 0) then
                            {
                                _phaseTime =
                                    _sourceOffset +
                                    (((diag_tickTime - _lastMRGrainTick) max 0) * _lastMRPitch);
                            };

                            if (_cycleDuration > 0.001) then
                            {
                                _phaseTime = _phaseTime mod _cycleDuration;
                            };

                            private _phaseIndex = floor (_phaseTime / _phaseStep);
                            _phaseIndex = _phaseIndex max 0 min 45;

                            private _releaseClosePaths =
                                _vehicle getVariable ["gau_gau8_mrCloseReleasePaths", []];
                            private _releaseMidPaths =
                                _vehicle getVariable ["gau_gau8_mrMidReleasePaths", []];
                            private _releaseFarPaths =
                                _vehicle getVariable ["gau_gau8_mrFarReleasePaths", []];

                            private _phaseCount =
                                (count _releaseClosePaths) min
                                (count _releaseMidPaths) min
                                (count _releaseFarPaths);

                            if (_phaseCount > 0) then
                            {
                                _phaseIndex = _phaseIndex mod _phaseCount;

                                private _mrMaster =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_mrDirectMaster",
                                            missionNamespace getVariable ["gau_gau8_mrDirectMasterDefault", 5.0]
                                        ]
                                    ) max 0 min 5;

                                private _releaseVoices =
                                [
                                    [_releaseClosePaths select _phaseIndex, _releaseCloseGain],
                                    [_releaseMidPaths select _phaseIndex, _releaseMidGain],
                                    [_releaseFarPaths select _phaseIndex, _releaseFarGain]
                                ];

                                {
                                    _x params ["_releasePath", "_releaseGain"];

                                    if (_releaseGain > 0.000001) then
                                    {
                                        [
                                            _vehicle,
                                            _releasePath,
                                            _releasePosition,
                                            _releaseArrival,
                                            _mrMaster * _releaseGain,
                                            1.0,
                                            50000
                                        ]
                                        call gau_gau8_fnc_queueSoundArrival;
                                    };
                                }
                                forEach _releaseVoices;
                            };

                            private _releaseCockpitBodyGain =
                                _vehicle getVariable ["gau_gau8_lastCockpitBodyGain", 0];
                            private _releaseCockpitAirframeGain =
                                _vehicle getVariable ["gau_gau8_lastCockpitAirframeGain", 0];
                            private _cockpitBodyEndPath =
                                _vehicle getVariable ["gau_gau8_cockpitBodyEndPath", ""];
                            private _cockpitAirframeEndPath =
                                _vehicle getVariable ["gau_gau8_cockpitAirframeEndPath", ""];
                            private _playCockpitSound =
                                _vehicle getVariable ["gau_gau8_playCockpitSound", {}];

                            [
                                _vehicle,
                                _cockpitBodyEndPath,
                                1.55 * _releaseCockpitBodyGain,
                                1.0
                            ] call _playCockpitSound;

                            [
                                _vehicle,
                                _cockpitAirframeEndPath,
                                1.70 * _releaseCockpitAirframeGain,
                                1.0
                            ] call _playCockpitSound;

                            _vehicle setVariable ["gau_gau8_shotCount", 0];
                            _vehicle setVariable ["gau_gau8_nextGrainTick", -1];
                            _vehicle setVariable ["gau_gau8_nextMechanicalGrainTick", -1];
                            _vehicle setVariable ["gau_gau8_nextCockpitGrainTick", -1];
                            _vehicle setVariable ["gau_gau8_lastCockpitGrainIndex", -1];
                            _vehicle setVariable ["gau_gau8_lastGrainIndex", -1];
                            _vehicle setVariable ["gau_gau8_v27_23LastMRGrainTick", -1];
                            _vehicle setVariable ["gau_gau8_monitorRunning", false];
                        };
                    };
                };
            };
        }
    ];

_aircraft setVariable
[
    "gau_gau8_firedHandler",
    _handler
];

_handler
