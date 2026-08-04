/*
    V9.6 arrival-time external sound queue.

    The source position and emission time are fixed. Listener position,
    propagation delay, terrain obstruction, object obstruction, and the
    single-voice ground-interference response are evaluated when the
    wavefront reaches the listener.

    Ground response never launches a second sound. It modifies the direct
    close/mid/far body gains using image-source path difference, preventing
    the doubled-report and flam artifacts produced by discrete reflection
    playback.
*/
params
[
    "_vehicle",
    "_path",
    "_emissionPositionASL",
    "_arrivalTime",
    "_volume",
    ["_pitch", 1.0],
    ["_maxDistance", 50000]
];

if (
    isNull _vehicle ||
    {_path isEqualTo ""} ||
    {_volume <= 0.000001}
) exitWith
{
    false
};

private _generation =
    _vehicle getVariable
    [
        "big_gau8_handlerGeneration",
        -1
    ];

private _listenerAtQueueASL =
    AGLToASL
    (
        positionCameraToWorld [0, 0, 0]
    );

private _initialDistance =
    _listenerAtQueueASL vectorDistance _emissionPositionASL;

/*
    Recover the physical emission time from the original direct-path
    arrival estimate. The worker updates the arrival estimate as the
    listener moves.
*/
private _emissionTime =
    _arrivalTime -
    (_initialDistance / 343.0);

private _queue =
    _vehicle getVariable
    [
        "big_gau8_arrivalQueue",
        []
    ];

_queue pushBack
[
    _arrivalTime,
    _path,
    +_emissionPositionASL,
    _volume min 24,
    _pitch,
    _maxDistance,
    _generation,
    _emissionTime
];

_queue sort true;

private _aircraftQueueLimit = 4096;

while {(count _queue) > _aircraftQueueLimit} do
{
    _queue deleteAt ((count _queue) - 1);
};

_vehicle setVariable
[
    "big_gau8_arrivalQueue",
    _queue
];

private _workerRunning =
    _vehicle getVariable
    [
        "big_gau8_arrivalWorkerRunning",
        false
    ];

if (!_workerRunning) then
{
    _vehicle setVariable
    [
        "big_gau8_arrivalWorkerRunning",
        true
    ];

    [
        _vehicle,
        _generation
    ]
    spawn
    {
        params
        [
            "_vehicle",
            "_generation"
        ];

        private _replaceToken =
        {
            params
            [
                "_source",
                "_from",
                "_to"
            ];

            private _index = _source find _from;

            if (_index < 0) exitWith
            {
                _source
            };

            (_source select [0, _index]) +
            _to +
            (
                _source select
                [
                    _index + (count _from)
                ]
            )
        };

        private _finished = false;

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
                        "big_gau8_handlerGeneration",
                        -1
                    ];

                if (_currentGeneration != _generation) then
                {
                    _finished = true;
                }
                else
                {
                    private _queue =
                        _vehicle getVariable
                        [
                            "big_gau8_arrivalQueue",
                            []
                        ];

                    if ((count _queue) == 0) then
                    {
                        _finished = true;
                    }
                    else
                    {
                        private _event = _queue select 0;
                        private _eventPositionASL =
                            +(_event select 2);

                        private _listenerPositionASL =
                            AGLToASL
                            (
                                positionCameraToWorld [0, 0, 0]
                            );

                        private _eventEmissionTime =
                            _event param
                            [
                                7,
                                (_event select 0) -
                                (
                                    (
                                        _listenerPositionASL
                                        vectorDistance
                                        _eventPositionASL
                                    ) /
                                    343.0
                                )
                            ];

                        private _currentDistance =
                            _listenerPositionASL
                            vectorDistance
                            _eventPositionASL;

                        private _dynamicArrival =
                            _eventEmissionTime +
                            (_currentDistance / 343.0);

                        private _wait =
                            _dynamicArrival - time;

                        if (_wait > 0) then
                        {
                            sleep ((_wait min 0.02) max 0.001);
                        }
                        else
                        {
                            _queue deleteAt 0;

                            _vehicle setVariable
                            [
                                "big_gau8_arrivalQueue",
                                _queue
                            ];

                            _event params
                            [
                                "_eventArrival",
                                "_eventPath",
                                "_eventPositionASL",
                                "_eventVolume",
                                "_eventPitch",
                                "_eventMaxDistance",
                                "_eventGeneration",
                                "_storedEmissionTime"
                            ];

                            if (_eventGeneration == _generation) then
                            {
                                /*
                                    Environment is sampled when the wavefront
                                    reaches the listener, using the listener's
                                    current camera position.
                                */
                                _listenerPositionASL =
                                    AGLToASL
                                    (
                                        positionCameraToWorld [0, 0, 0]
                                    );

                                _currentDistance =
                                    _listenerPositionASL
                                    vectorDistance
                                    _eventPositionASL;

                                private _environmentState =
                                    [
                                        _vehicle,
                                        _eventPositionASL,
                                        _listenerPositionASL,
                                        _currentDistance,
                                        1.0
                                    ]
                                    call big_gau8_fnc_getEnvironmentState;

                                _environmentState params
                                [
                                    "_terrainOcclusion",
                                    "_objectOcclusion",
                                    "_combinedOcclusion",
                                    "_reflectionPresence",
                                    "_reflectionPositionASL",
                                    "_reflectionPropagationDelay",
                                    "_reflectionExtraDelay",
                                    "_sourceHeightAGL",
                                    "_listenerHeightAGL",
                                    "_objectHitCount"
                                ];

                                private _terrainCloseScale =
                                    linearConversion
                                    [
                                        0,
                                        1,
                                        _terrainOcclusion,
                                        1.00,
                                        0.01,
                                        true
                                    ];

                                private _terrainMidScale =
                                    linearConversion
                                    [
                                        0,
                                        1,
                                        _terrainOcclusion,
                                        1.00,
                                        0.04,
                                        true
                                    ];

                                private _terrainFarScale =
                                    linearConversion
                                    [
                                        0,
                                        1,
                                        _terrainOcclusion,
                                        1.00,
                                        0.20,
                                        true
                                    ];

                                private _terrainMechanicalScale =
                                    linearConversion
                                    [
                                        0,
                                        1,
                                        _terrainOcclusion,
                                        1.00,
                                        0.02,
                                        true
                                    ];

                                private _terrainMuzzleScale =
                                    linearConversion
                                    [
                                        0,
                                        1,
                                        _terrainOcclusion,
                                        1.00,
                                        0.002,
                                        true
                                    ];

                                private _objectCloseScale =
                                    linearConversion
                                    [
                                        0,
                                        1,
                                        _objectOcclusion,
                                        1.00,
                                        0.04,
                                        true
                                    ];

                                private _objectMidScale =
                                    linearConversion
                                    [
                                        0,
                                        1,
                                        _objectOcclusion,
                                        1.00,
                                        0.12,
                                        true
                                    ];

                                private _objectFarScale =
                                    linearConversion
                                    [
                                        0,
                                        1,
                                        _objectOcclusion,
                                        1.00,
                                        0.28,
                                        true
                                    ];

                                private _objectMechanicalScale =
                                    linearConversion
                                    [
                                        0,
                                        1,
                                        _objectOcclusion,
                                        1.00,
                                        0.08,
                                        true
                                    ];

                                private _objectMuzzleScale =
                                    linearConversion
                                    [
                                        0,
                                        1,
                                        _objectOcclusion,
                                        1.00,
                                        0.015,
                                        true
                                    ];

                                private _midLeakScale =
                                    (0.025 * _terrainOcclusion) +
                                    (
                                        0.030 *
                                        _objectOcclusion *
                                        (1 - _terrainOcclusion)
                                    );

                                private _farLeakScale =
                                    (0.055 * _terrainOcclusion) +
                                    (
                                        0.055 *
                                        _objectOcclusion *
                                        (1 - _terrainOcclusion)
                                    );

                                private _pathLower =
                                    toLower _eventPath;

                                private _isCloseBody =
                                    (_pathLower find "close_body_") >= 0;

                                private _isMidBody =
                                    (_pathLower find "mid_body_") >= 0;

                                private _isFarBody =
                                    (_pathLower find "far_body_") >= 0;

                                private _isMechanical =
                                    (_pathLower find "close_mechanical_") >= 0;

                                private _isMuzzle =
                                    (_pathLower find "close_muzzle_blast") >= 0;

                                /*
                                    Single-voice ground-interference model.

                                    The image-source calculation returns the
                                    reflected/direct path difference. We use
                                    that delay to estimate broad-band phase
                                    interaction for each existing body layer.
                                    No reflected playSound3D event is created.

                                    Representative layer frequencies:
                                        close: 3.2 kHz
                                        mid:   0.9 kHz
                                        far:   0.24 kHz
                                */
                                private _groundResponseEnabled =
                                    _vehicle getVariable
                                    [
                                        "big_gau8_groundResponseEnabled",
                                        true
                                    ];

                                private _groundResponseMaster =
                                    (
                                        _vehicle getVariable
                                        [
                                            "big_gau8_groundResponseMaster",
                                            1.0
                                        ]
                                    )
                                    max 0
                                    min 2;

                                private _groundCoefficient =
                                    if (_groundResponseEnabled) then
                                    {
                                        (
                                            _reflectionPresence *
                                            _groundResponseMaster
                                        )
                                        min 0.30
                                    }
                                    else
                                    {
                                        0
                                    };

                                private _groundInterferenceScale =
                                {
                                    params ["_effectiveFrequency"];

                                    if (_groundCoefficient <= 0.000001)
                                    exitWith
                                    {
                                        1.0
                                    };

                                    private _phaseDegrees =
                                        (
                                            360 *
                                            _effectiveFrequency *
                                            _reflectionExtraDelay
                                        )
                                        mod 360;

                                    private _scale =
                                        sqrt
                                        (
                                            1 +
                                            (
                                                _groundCoefficient *
                                                _groundCoefficient
                                            ) +
                                            (
                                                2 *
                                                _groundCoefficient *
                                                cos _phaseDegrees
                                            )
                                        );

                                    (_scale max 0.70) min 1.35
                                };

                                private _closeGroundScale =
                                    [3200] call _groundInterferenceScale;

                                private _midGroundScale =
                                    [900] call _groundInterferenceScale;

                                private _farGroundScale =
                                    [240] call _groundInterferenceScale;

                                private _soundAnchor =
                                    if (!isNull player) then
                                    {
                                        vehicle player
                                    }
                                    else
                                    {
                                        _vehicle
                                    };

                                private _playExternalSound =
                                {
                                    params
                                    [
                                        "_outputPath",
                                        "_outputVolume"
                                    ];

                                    if (
                                        _outputPath isEqualTo "" ||
                                        {_outputVolume <= 0.000001}
                                    ) exitWith {};

                                    private _soundID =
                                        playSound3D
                                        [
                                            _outputPath,
                                            _soundAnchor,
                                            false,
                                            _eventPositionASL,
                                            _outputVolume min 24,
                                            _eventPitch,
                                            _eventMaxDistance,
                                            0,
                                            true
                                        ];

                                    if (_soundID >= 0) then
                                    {
                                        private _ids =
                                            _vehicle getVariable
                                            [
                                                "big_gau8_grainIDs",
                                                []
                                            ];

                                        _ids pushBack _soundID;

                                        while {(count _ids) > 128} do
                                        {
                                            _ids deleteAt 0;
                                        };

                                        _vehicle setVariable
                                        [
                                            "big_gau8_grainIDs",
                                            _ids
                                        ];
                                    };
                                };

                                if (
                                    _isCloseBody ||
                                    {_isMidBody} ||
                                    {_isFarBody}
                                ) then
                                {
                                    private _midPath = _eventPath;
                                    private _farPath = _eventPath;

                                    if (_isCloseBody) then
                                    {
                                        _midPath =
                                            [
                                                _eventPath,
                                                "close_body_",
                                                "mid_body_"
                                            ]
                                            call _replaceToken;

                                        _farPath =
                                            [
                                                _eventPath,
                                                "close_body_",
                                                "far_body_"
                                            ]
                                            call _replaceToken;

                                        [
                                            _eventPath,
                                            _eventVolume *
                                            _terrainCloseScale *
                                            _objectCloseScale *
                                            _closeGroundScale
                                        ]
                                        call _playExternalSound;

                                        [
                                            _midPath,
                                            _eventVolume *
                                            _midLeakScale *
                                            _midGroundScale
                                        ]
                                        call _playExternalSound;

                                        [
                                            _farPath,
                                            _eventVolume *
                                            _farLeakScale *
                                            _farGroundScale
                                        ]
                                        call _playExternalSound;
                                    };

                                    if (_isMidBody) then
                                    {
                                        _farPath =
                                            [
                                                _eventPath,
                                                "mid_body_",
                                                "far_body_"
                                            ]
                                            call _replaceToken;

                                        [
                                            _eventPath,
                                            _eventVolume *
                                            (
                                                (
                                                    (
                                                        _terrainMidScale *
                                                        _objectMidScale
                                                    ) +
                                                    _midLeakScale
                                                ) *
                                                _midGroundScale
                                            )
                                        ]
                                        call _playExternalSound;

                                        [
                                            _farPath,
                                            _eventVolume *
                                            _farLeakScale *
                                            _farGroundScale
                                        ]
                                        call _playExternalSound;
                                    };

                                    if (_isFarBody) then
                                    {
                                        _midPath =
                                            [
                                                _eventPath,
                                                "far_body_",
                                                "mid_body_"
                                            ]
                                            call _replaceToken;

                                        [
                                            _eventPath,
                                            _eventVolume *
                                            (
                                                (
                                                    (
                                                        _terrainFarScale *
                                                        _objectFarScale
                                                    ) +
                                                    _farLeakScale
                                                ) *
                                                _farGroundScale
                                            )
                                        ]
                                        call _playExternalSound;

                                        [
                                            _midPath,
                                            _eventVolume *
                                            _midLeakScale *
                                            _midGroundScale
                                        ]
                                        call _playExternalSound;
                                    };
                                }
                                else
                                {
                                    private _eventScale = 1.0;

                                    if (_isMechanical) then
                                    {
                                        _eventScale =
                                            _terrainMechanicalScale *
                                            _objectMechanicalScale;
                                    };

                                    if (_isMuzzle) then
                                    {
                                        _eventScale =
                                            _terrainMuzzleScale *
                                            _objectMuzzleScale;
                                    };

                                    [
                                        _eventPath,
                                        _eventVolume * _eventScale
                                    ]
                                    call _playExternalSound;
                                };

                                if (
                                    _vehicle getVariable
                                    [
                                        "big_gau8_debugEnvironment",
                                        false
                                    ]
                                ) then
                                {
                                    private _nextDebug =
                                        _vehicle getVariable
                                        [
                                            "big_gau8_nextEnvironmentDebug",
                                            -1
                                        ];

                                    if (time >= _nextDebug) then
                                    {
                                        _vehicle setVariable
                                        [
                                            "big_gau8_nextEnvironmentDebug",
                                            time + 0.50
                                        ];

                                        private _message = format
                                        [
                                            "GAU-8 arrival environment: terrain=%1 object=%2 combined=%3 distance=%4 m hits=%5 ground=%6 delay=%7 ms scales=[%8,%9,%10]",
                                            (_terrainOcclusion toFixed 3),
                                            (_objectOcclusion toFixed 3),
                                            (_combinedOcclusion toFixed 3),
                                            (_currentDistance toFixed 1),
                                            _objectHitCount,
                                            (_groundCoefficient toFixed 3),
                                            ((_reflectionExtraDelay * 1000) toFixed 2),
                                            (_closeGroundScale toFixed 3),
                                            (_midGroundScale toFixed 3),
                                            (_farGroundScale toFixed 3)
                                        ];

                                        systemChat _message;
                                        diag_log _message;
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };

        if (!isNull _vehicle) then
        {
            private _currentGeneration =
                _vehicle getVariable
                [
                    "big_gau8_handlerGeneration",
                    -1
                ];

            if (_currentGeneration == _generation) then
            {
                _vehicle setVariable
                [
                    "big_gau8_arrivalWorkerRunning",
                    false
                ];
            };
        };
    };
};

true
