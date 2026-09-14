params
[
    ["_vehicle", objNull],
    ["_generation", -1]
];

if (
    !hasInterface ||
    {isNull _vehicle}
) exitWith {};


private _attackPath =
    "z\gau\addons\main\sounds\rip\rip_attack.wav";


private _sustainPaths =
[
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_01.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_02.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_03.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_04.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_05.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_06.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_07.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_08.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_09.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_10.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_11.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_12.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_13.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_14.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_15.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_16.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_17.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_18.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_19.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_20.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_21.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_22.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_23.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_24.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_25.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_26.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_27.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_28.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_29.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_30.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_31.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_32.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_33.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_34.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_35.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_36.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_37.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_38.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_39.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_40.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_41.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_42.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_43.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_44.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_45.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_46.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_47.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_48.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_49.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_50.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_51.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_52.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_53.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_54.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_55.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_56.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_57.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_58.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_59.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_60.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_61.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_62.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_63.wav",
    "z\gau\addons\main\sounds\rip\rip_sustain_seq_64.wav"
];


private _releasePath =
    "z\gau\addons\main\sounds\rip\rip_release.wav";

private _releaseVariantCount =
    3;

private _master =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripMaster",
            3.00
        ]
    )
    max 0
    min 3;

private _attackVolume =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripAttackVolume",
            4.50
        ]
    )
    max 0
    min 8;

private _sustainVolume =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripSustainVolume",
            5.80
        ]
    )
    max 0
    min 8;

private _releaseVolume =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripReleaseVolume",
            5.80
        ]
    )
    max 0
    min 8;

private _maxDistance =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripMaxDistance",
            4000
        ]
    )
    max 100
    min 6000;


private _playbackMaxDistance =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripPlaybackMaxDistance",
            50000
        ]
    )
    max 10000
    min 50000;

private _releaseTimeout =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripReleaseTimeout",
            0.18
        ]
    )
    max 0.08
    min 0.40;

private _sustainArmDelay =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripSustainArmDelay",
            0.09
        ]
    )
    max 0.05
    min 0.25;

private _sustainInterval =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripSustainInterval",
            0.43
        ]
    )
    max 0.25
    min 0.60;


private _getRipDistanceGain =
{
    params
    [
        ["_sourcePositionASL", []]
    ];

    if (
        isNull player ||
        {(count _sourcePositionASL) != 3}
    ) exitWith
    {
        1.12
    };

    private _distance =
        vectorMagnitude
        (
            (eyePos player)
            vectorDiff
            _sourcePositionASL
        );

    if (_distance <= 50) exitWith
    {
        1.12
    };

    if (_distance <= 100) exitWith
    {
        linearConversion
        [
            50,
            100,
            _distance,
            1.12,
            1.05,
            true
        ]
    };

    if (_distance <= 200) exitWith
    {
        linearConversion
        [
            100,
            200,
            _distance,
            1.05,
            0.92,
            true
        ]
    };

    if (_distance <= 350) exitWith
    {
        linearConversion
        [
            200,
            350,
            _distance,
            0.92,
            0.82,
            true
        ]
    };

    if (_distance <= 500) exitWith
    {
        linearConversion
        [
            350,
            500,
            _distance,
            0.82,
            0.75,
            true
        ]
    };

    if (_distance <= 800) exitWith
    {
        linearConversion
        [
            500,
            800,
            _distance,
            0.75,
            0.64,
            true
        ]
    };

    if (_distance <= 1200) exitWith
    {
        linearConversion
        [
            800,
            1200,
            _distance,
            0.64,
            0.56,
            true
        ]
    };

    if (_distance <= 1800) exitWith
    {
        linearConversion
        [
            1200,
            1800,
            _distance,
            0.56,
            0.47,
            true
        ]
    };

    if (_distance <= 2600) exitWith
    {
        linearConversion
        [
            1800,
            2600,
            _distance,
            0.47,
            0.39,
            true
        ]
    };

    if (_distance <= 3500) exitWith
    {
        linearConversion
        [
            2600,
            3500,
            _distance,
            0.39,
            0.32,
            true
        ]
    };

    if (_distance <= 4000) exitWith
    {
        linearConversion
        [
            3500,
            4000,
            _distance,
            0.32,
            0.29,
            true
        ]
    };

    0.29
};


private _queueRip =
{
    params
    [
        "_path",
        "_positionASL",
        "_eventTime",
        "_volume",
        ["_lockedArrivalTick", -1]
    ];

    if (
        _path isEqualTo "" ||
        {_volume <= 0.000001} ||
        {(count _positionASL) != 3}
    ) exitWith {};

    private _distanceGain =
        [
            _positionASL
        ]
        call
            _getRipDistanceGain;

    private _effectiveVolume =
        _volume *
        _distanceGain;

    [
        _vehicle,
        _path,
        _positionASL,
        _eventTime,
        _effectiveVolume,
        1.0,
        _playbackMaxDistance,
        [0, 0, 0],
        _lockedArrivalTick
    ]
    call
        gau_gau8_fnc_queueSoundArrival;
};

private _positionASL =
    _vehicle getVariable
    [
        "gau_gau8_ripEventPositionASL",
        []
    ];

private _eventTime =
    _vehicle getVariable
    [
        "gau_gau8_ripEventTime",
        time
    ];

if ((count _positionASL) != 3) exitWith
{
    _vehicle setVariable
    [
        "gau_gau8_ripStreamRunning",
        false
    ];
};


private _phaseSoundSpeed =
    (
        _vehicle getVariable
        [
            "gau_gau8_speedOfSound",
            343.0
        ]
    )
    max 300
    min 360;

private _phaseGeometry =
    _vehicle getVariable
    [
        "gau_gau8_ripEventGeometry",
        []
    ];

if ((count _phaseGeometry) >= 7) then
{
    private _phaseGeometryPosition =
        _phaseGeometry param
        [
            0,
            []
        ];

    if (
        (count _phaseGeometryPosition) == 3 &&
        {
            (
                _phaseGeometryPosition
                vectorDistance
                _positionASL
            ) <= 5
        }
    ) then
    {
        _phaseSoundSpeed =
            (
                _phaseGeometry param
                [
                    6,
                    _phaseSoundSpeed
                ]
            )
            max 300
            min 360;
    };
};

private _phaseListenerPositionASL =
    AGLToASL
    (
        positionCameraToWorld [0, 0, 0]
    );

private _attackPhaseArrivalTick =
    _eventTime +
    (
        (
            _phaseListenerPositionASL
            vectorDistance
            _positionASL
        ) /
        _phaseSoundSpeed
    );

_vehicle setVariable
[
    "gau_gau8_ripPhaseAttackTargetTick",
    _attackPhaseArrivalTick
];

_vehicle setVariable
[
    "gau_gau8_ripPhaseGeneration",
    _generation
];

[
    _attackPath,
    _positionASL,
    _eventTime,
    _master * _attackVolume,
    _attackPhaseArrivalTick
]
call
    _queueRip;

private _startTick =
    diag_tickTime;

private _lastSustainQueueTick =
    _startTick;

private _sustainStarted =
    false;

private _sustainSequenceIndex =
    0;

private _sustainPhaseIndex =
    0;

private _finished =
    false;

while {!_finished} do
{
    if (isNull _vehicle) then
    {
        _finished = true;
    }
    else
    {
        private _currentGeneration =
            _vehicle getVariable
            [
                "gau_gau8_handlerGeneration",
                -1
            ];

        if (_currentGeneration != _generation) then
        {
            _finished = true;
        }
        else
        {
            private _nowTick =
                diag_tickTime;

            private _lastShotTick =
                _vehicle getVariable
                [
                    "gau_gau8_ripLastShotTick",
                    _nowTick
                ];

            if (
                (_nowTick - _lastShotTick) >
                _releaseTimeout
            ) then
            {
                _finished = true;
            }
            else
            {
                if (
                    (!_sustainStarted &&
                    {(_nowTick - _startTick) >= _sustainArmDelay}) ||
                    {_sustainStarted &&
                    {(_nowTick - _lastSustainQueueTick) >= _sustainInterval}}
                ) then
                {
                    _positionASL =
                        _vehicle getVariable
                        [
                            "gau_gau8_ripEventPositionASL",
                            _positionASL
                        ];

                    _eventTime =
                        _vehicle getVariable
                        [
                            "gau_gau8_ripEventTime",
                            _eventTime
                        ];

                    private _sustainVariantCount =
                        count _sustainPaths;

                    private _sustainPath =
                        _sustainPaths select
                        _sustainSequenceIndex;

                    _sustainSequenceIndex =
                        (
                            _sustainSequenceIndex +
                            1
                        )
                        mod
                        _sustainVariantCount;

                    private _sustainPhaseArrivalTick =
                        _attackPhaseArrivalTick +
                        (10 / 65) +
                        (
                            _sustainPhaseIndex *
                            _sustainInterval
                        );

                    [
                        _sustainPath,
                        _positionASL,
                        _eventTime,
                        _master * _sustainVolume,
                        _sustainPhaseArrivalTick
                    ]
                    call
                        _queueRip;

                    _vehicle setVariable
                    [
                        "gau_gau8_ripLastLockedSustainTarget",
                        _sustainPhaseArrivalTick
                    ];

                    _sustainPhaseIndex =
                        _sustainPhaseIndex + 1;

                    _sustainStarted =
                        true;

                    _lastSustainQueueTick =
                        _nowTick;
                };

                uiSleep 0.010;
            };
        };
    };
};

if (
    !isNull _vehicle &&
    {
        (
            _vehicle getVariable
            [
                "gau_gau8_handlerGeneration",
                -1
            ]
        ) == _generation
    }
) then
{
    _positionASL =
        _vehicle getVariable
        [
            "gau_gau8_ripEventPositionASL",
            _positionASL
        ];

    _eventTime =
        _vehicle getVariable
        [
            "gau_gau8_ripEventTime",
            _eventTime
        ];

    private _releaseEventTime =
        (
            _eventTime - 0.035
        )
        max time;


    private _releasePhaseIndex =
        _sustainSequenceIndex;

    private _releasePhaseNumber =
        _releasePhaseIndex + 1;

    private _releasePhaseLabel =
        if (_releasePhaseNumber < 10) then
        {
            format ["0%1", _releasePhaseNumber]
        }
        else
        {
            str _releasePhaseNumber
        };

    private _releaseEndVariant =
        1 + floor (random _releaseVariantCount);

    private _releaseEndLabel =
        format ["0%1", _releaseEndVariant];

    private _phaseReleasePath =
        format
        [
            "z\gau\addons\main\sounds\rip\rip_release_p%1_e%2.wav",
            _releasePhaseLabel,
            _releaseEndLabel
        ];

    private _releasePhaseArrivalTick =
        _attackPhaseArrivalTick +
        (10 / 65) +
        (
            _sustainPhaseIndex *
            _sustainInterval
        );

    [
        _phaseReleasePath,
        _positionASL,
        _releaseEventTime,
        _master * _releaseVolume,
        _releasePhaseArrivalTick
    ]
    call
        _queueRip;
};

if (!isNull _vehicle) then
{
    _vehicle setVariable
    [
        "gau_gau8_ripStreamRunning",
        false
    ];
};
