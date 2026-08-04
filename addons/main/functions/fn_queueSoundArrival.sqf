/*
    V10.1 presence-EQ, sustain-density, and diffuse-tail queue.

    Source position, source velocity, and emission time are fixed for each
    queued event. Wavefront travel uses a real-time monotonic clock and a
    configurable sound speed. Listener position, listener velocity,
    obstruction, Doppler pitch, and single-voice ground response are
    evaluated when the wavefront reaches the listener.

    V10.1 retains V10.0 gain staging and maps body events to presence-EQ
    assets that add approximately 2.5 dB from 400 to 1200 Hz and 1.5 dB
    from 1.2 to 3 kHz without adding low-frequency gain. It also schedules
    diffuse, attack-free environmental tails at arrival time. Tail type,
    level, predelay, and cadence respond to listener distance, obstruction,
    enclosure, ground response, and Doppler state.

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

/*
    The legacy arrival-time argument remains in the public function contract,
    but the queue records the actual local emission tick directly. Recovering
    emission time from a previously calculated arrival estimate introduced
    drift when the listener or camera moved between calculations.
*/
private _speedOfSound =
    (
        _vehicle getVariable
        [
            "big_gau8_speedOfSound",
            343.0
        ]
    ) max 300 min 360;

private _emissionTick = diag_tickTime;

/*
    The muzzle report is emitted by the aircraft, not by the projectile.
    Store aircraft world velocity at emission so later aircraft motion does
    not alter the Doppler state of a wavefront already in flight.
*/
private _sourceVelocityAtEmission =
    velocity _vehicle;

private _listenerAtQueueASL =
    AGLToASL
    (
        positionCameraToWorld [0, 0, 0]
    );

private _initialDistance =
    _listenerAtQueueASL vectorDistance _emissionPositionASL;

private _arrivalHint =
    _emissionTick +
    (_initialDistance / _speedOfSound);

private _queue =
    _vehicle getVariable
    [
        "big_gau8_arrivalQueue",
        []
    ];

_queue pushBack
[
    _arrivalHint,
    _path,
    +_emissionPositionASL,
    _volume min 24,
    _pitch,
    _maxDistance,
    _generation,
    _emissionTick,
    +_sourceVelocityAtEmission
];

/*
    The hint keeps stationary-listener queues approximately ordered. The
    worker still recalculates every event because listener movement can
    change the true order of arrival.
*/
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
        private _emptySinceTick = -1.0;

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
                        if (_emptySinceTick < 0) then
                        {
                            _emptySinceTick = diag_tickTime;
                        };

                        if (
                            (diag_tickTime - _emptySinceTick) >
                            0.05
                        ) then
                        {
                            _finished = true;
                        }
                        else
                        {
                            uiSleep 0.005;
                        };
                    }
                    else
                    {
                        _emptySinceTick = -1.0;

                        private _listenerPositionASL =
                            AGLToASL
                            (
                                positionCameraToWorld [0, 0, 0]
                            );

                        private _speedOfSound =
                            (
                                _vehicle getVariable
                                [
                                    "big_gau8_speedOfSound",
                                    343.0
                                ]
                            ) max 300 min 360;

                        private _nowTick = diag_tickTime;
                        private _nextIndex = -1;
                        private _nextArrivalTick = 1e12;
                        private _nextDistance = 0.0;

                        /*
                            Recalculate every queued event. Sorting once by the
                            listener position at fire time is insufficient:
                            listener movement can change event order.
                        */
                        {
                            private _candidatePositionASL =
                                +(_x select 2);

                            private _candidateEmissionTick =
                                _x param
                                [
                                    7,
                                    _nowTick
                                ];

                            private _candidateDistance =
                                _listenerPositionASL
                                vectorDistance
                                _candidatePositionASL;

                            private _candidateArrivalTick =
                                _candidateEmissionTick +
                                (
                                    _candidateDistance /
                                    _speedOfSound
                                );

                            if (
                                _candidateArrivalTick <
                                _nextArrivalTick
                            ) then
                            {
                                _nextIndex = _forEachIndex;
                                _nextArrivalTick =
                                    _candidateArrivalTick;
                                _nextDistance =
                                    _candidateDistance;
                            };
                        }
                        forEach _queue;

                        if (_nextIndex < 0) then
                        {
                            _finished = true;
                        }
                        else
                        {
                            private _wait =
                                _nextArrivalTick - _nowTick;

                            if (_wait > 0) then
                            {
                                uiSleep
                                (
                                    (_wait min 0.01)
                                    max 0.001
                                );
                            }
                            else
                            {
                                private _event =
                                    _queue deleteAt _nextIndex;

                                _vehicle setVariable
                                [
                                    "big_gau8_arrivalQueue",
                                    _queue
                                ];

                                _event params
                                [
                                    "_eventArrivalHint",
                                    "_eventPath",
                                    "_eventPositionASL",
                                    "_eventVolume",
                                    "_eventPitch",
                                    "_eventMaxDistance",
                                    "_eventGeneration",
                                    "_storedEmissionTick",
                                    ["_storedSourceVelocity", [0, 0, 0]]
                                ];

                                private _currentDistance =
                                    _nextDistance;

                                if (
                                    _eventGeneration ==
                                    _generation
                                ) then
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

                                /*
                                    Classical line-of-sight Doppler ratio:

                                    f_observed / f_emitted =
                                        (c - observerVelocityAlongRay) /
                                        (c - sourceVelocityAlongRay)

                                    The ray points from the historical source
                                    position toward the listener. Positive
                                    source velocity along the ray means the
                                    aircraft was approaching the listener.
                                    Positive observer velocity along the ray
                                    means the listener is moving away.
                                */
                                private _rayDirection =
                                    if (_currentDistance > 0.01) then
                                    {
                                        [
                                            (
                                                _listenerPositionASL # 0
                                            ) -
                                            (
                                                _eventPositionASL # 0
                                            ),
                                            (
                                                _listenerPositionASL # 1
                                            ) -
                                            (
                                                _eventPositionASL # 1
                                            ),
                                            (
                                                _listenerPositionASL # 2
                                            ) -
                                            (
                                                _eventPositionASL # 2
                                            )
                                        ]
                                        vectorMultiply
                                        (1 / _currentDistance)
                                    }
                                    else
                                    {
                                        [0, 0, 0]
                                    };

                                private _listenerObject =
                                    if (!isNull cameraOn) then
                                    {
                                        vehicle cameraOn
                                    }
                                    else
                                    {
                                        if (!isNull player) then
                                        {
                                            vehicle player
                                        }
                                        else
                                        {
                                            objNull
                                        }
                                    };

                                private _listenerVelocity =
                                    if (!isNull _listenerObject) then
                                    {
                                        velocity _listenerObject
                                    }
                                    else
                                    {
                                        [0, 0, 0]
                                    };

                                private _sourceVelocityAlongRay =
                                    _storedSourceVelocity
                                    vectorDotProduct
                                    _rayDirection;

                                private _listenerVelocityAlongRay =
                                    _listenerVelocity
                                    vectorDotProduct
                                    _rayDirection;

                                private _dopplerEnabled =
                                    _vehicle getVariable
                                    [
                                        "big_gau8_dopplerEnabled",
                                        true
                                    ];

                                private _dopplerMaster =
                                    (
                                        _vehicle getVariable
                                        [
                                            "big_gau8_dopplerMaster",
                                            1.0
                                        ]
                                    ) max 0 min 1;

                                private _dopplerMinimum =
                                    (
                                        _vehicle getVariable
                                        [
                                            "big_gau8_dopplerMinimum",
                                            0.60
                                        ]
                                    ) max 0.25 min 1.0;

                                private _dopplerMaximum =
                                    (
                                        _vehicle getVariable
                                        [
                                            "big_gau8_dopplerMaximum",
                                            1.80
                                        ]
                                    ) max 1.0 min 3.0;

                                private _dopplerDenominator =
                                    (
                                        _speedOfSound -
                                        _sourceVelocityAlongRay
                                    )
                                    max 25.0;

                                private _rawDopplerFactor =
                                    (
                                        _speedOfSound -
                                        _listenerVelocityAlongRay
                                    ) /
                                    _dopplerDenominator;

                                private _dopplerFactor =
                                    if (_dopplerEnabled) then
                                    {
                                        (
                                            1 +
                                            (
                                                (
                                                    _rawDopplerFactor -
                                                    1
                                                ) *
                                                _dopplerMaster
                                            )
                                        )
                                        max _dopplerMinimum
                                        min _dopplerMaximum
                                    }
                                    else
                                    {
                                        1.0
                                    };

                                private _eventPlaybackPitch =
                                    (
                                        _eventPitch *
                                        _dopplerFactor
                                    )
                                    max 0.25
                                    min 4.0;

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

                                private _isBodyStart =
                                    (_pathLower find "_body_start") >= 0;

                                private _isBodyGrain =
                                    (_pathLower find "_body_grain_") >= 0;

                                private _isBodyEnd =
                                    (_pathLower find "_body_end") >= 0;

                                private _isMechanical =
                                    (_pathLower find "close_mechanical_") >= 0;

                                private _isMuzzle =
                                    (_pathLower find "close_muzzle_blast") >= 0;

                                /*
                                    V10.0 external presence gain staging.

                                    Defaults:
                                        close body: +2.0 dB
                                        mid body:   +3.0 dB
                                        far body:   +2.5 dB
                                        muzzle:     +1.0 dB
                                        mechanical: unchanged

                                    All values are linear amplitude gains.
                                    The external master remains neutral by
                                    default and provides one runtime control
                                    for A/B testing and final calibration.
                                */
                                private _externalMaster =
                                    (
                                        _vehicle getVariable
                                        [
                                            "big_gau8_externalMaster",
                                            1.0
                                        ]
                                    )
                                    max 0
                                    min 4;

                                private _closeBodyTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "big_gau8_closeBodyTrim",
                                            1.258925
                                        ]
                                    )
                                    max 0
                                    min 4;

                                private _midBodyTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "big_gau8_midBodyTrim",
                                            1.412538
                                        ]
                                    )
                                    max 0
                                    min 4;

                                private _farBodyTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "big_gau8_farBodyTrim",
                                            1.333521
                                        ]
                                    )
                                    max 0
                                    min 4;

                                private _muzzleTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "big_gau8_muzzleTrim",
                                            1.122018
                                        ]
                                    )
                                    max 0
                                    min 4;

                                private _mechanicalTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "big_gau8_mechanicalTrim",
                                            1.0
                                        ]
                                    )
                                    max 0
                                    min 4;

                                private _presenceEQEnabled =
                                    _vehicle getVariable
                                    [
                                        "big_gau8_presenceEQEnabled",
                                        true
                                    ];

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

                                    private _resolvedPath =
                                        _outputPath;

                                    if (_presenceEQEnabled) then
                                    {
                                        private _resolvedLower =
                                            toLower _resolvedPath;

                                        if (
                                            (_resolvedLower find
                                                "close_body_") >= 0
                                        ) then
                                        {
                                            _resolvedPath =
                                                [
                                                    _resolvedPath,
                                                    "close_body_",
                                                    "close_body_presence_"
                                                ]
                                                call _replaceToken;
                                        };

                                        if (
                                            (_resolvedLower find
                                                "mid_body_") >= 0
                                        ) then
                                        {
                                            _resolvedPath =
                                                [
                                                    _resolvedPath,
                                                    "mid_body_",
                                                    "mid_body_presence_"
                                                ]
                                                call _replaceToken;
                                        };

                                        if (
                                            (_resolvedLower find
                                                "far_body_") >= 0
                                        ) then
                                        {
                                            _resolvedPath =
                                                [
                                                    _resolvedPath,
                                                    "far_body_",
                                                    "far_body_presence_"
                                                ]
                                                call _replaceToken;
                                        };
                                    };

                                    private _soundID =
                                        playSound3D
                                        [
                                            _resolvedPath,
                                            _soundAnchor,
                                            false,
                                            _eventPositionASL,
                                            _outputVolume min 24,
                                            _eventPlaybackPitch,
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
                                            _externalMaster *
                                            _closeBodyTrim *
                                            _terrainCloseScale *
                                            _objectCloseScale *
                                            _closeGroundScale
                                        ]
                                        call _playExternalSound;

                                        [
                                            _midPath,
                                            _eventVolume *
                                            _externalMaster *
                                            _midBodyTrim *
                                            _midLeakScale *
                                            _midGroundScale
                                        ]
                                        call _playExternalSound;

                                        [
                                            _farPath,
                                            _eventVolume *
                                            _externalMaster *
                                            _farBodyTrim *
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
                                            _externalMaster *
                                            _midBodyTrim *
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
                                            _externalMaster *
                                            _farBodyTrim *
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
                                            _externalMaster *
                                            _farBodyTrim *
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
                                            _externalMaster *
                                            _midBodyTrim *
                                            _midLeakScale *
                                            _midGroundScale
                                        ]
                                        call _playExternalSound;
                                    };
                                }
                                else
                                {
                                    private _eventScale = 1.0;
                                    private _eventTrim = 1.0;

                                    if (_isMechanical) then
                                    {
                                        _eventScale =
                                            _terrainMechanicalScale *
                                            _objectMechanicalScale;

                                        _eventTrim = _mechanicalTrim;
                                    };

                                    if (_isMuzzle) then
                                    {
                                        _eventScale =
                                            _terrainMuzzleScale *
                                            _objectMuzzleScale;

                                        _eventTrim = _muzzleTrim;
                                    };

                                    [
                                        _eventPath,
                                        _eventVolume *
                                        _externalMaster *
                                        _eventTrim *
                                        _eventScale
                                    ]
                                    call _playExternalSound;
                                };

                                private _reverbEnabled =
                                    _vehicle getVariable
                                    [
                                        "big_gau8_reverbEnabled",
                                        true
                                    ];

                                if (
                                    _reverbEnabled &&
                                    (
                                        _isCloseBody ||
                                        {_isMidBody} ||
                                        {_isFarBody}
                                    ) &&
                                    (
                                        _isBodyStart ||
                                        {_isBodyGrain} ||
                                        {_isBodyEnd}
                                    )
                                ) then
                                {
                                    private _eventBucket =
                                        floor
                                        (
                                            _storedEmissionTick * 20
                                        );

                                    private _lastTailBucket =
                                        _vehicle getVariable
                                        [
                                            "big_gau8_lastTailBucket",
                                            -1
                                        ];

                                    private _nextTailTick =
                                        _vehicle getVariable
                                        [
                                            "big_gau8_nextTailTick",
                                            -1
                                        ];

                                    private _tailEligible = false;

                                    if (
                                        _eventBucket !=
                                        _lastTailBucket
                                    ) then
                                    {
                                        if (
                                            _isBodyStart ||
                                            {_isBodyEnd}
                                        ) then
                                        {
                                            _tailEligible = true;
                                        }
                                        else
                                        {
                                            _tailEligible =
                                                diag_tickTime >=
                                                _nextTailTick;
                                        };
                                    };

                                    if (_tailEligible) then
                                    {
                                        _vehicle setVariable
                                        [
                                            "big_gau8_lastTailBucket",
                                            _eventBucket
                                        ];

                                        private _tailIntervalMin =
                                            (
                                                _vehicle getVariable
                                                [
                                                    "big_gau8_reverbIntervalMin",
                                                    0.70
                                                ]
                                            )
                                            max 0.35
                                            min 2.0;

                                        private _tailIntervalSpread =
                                            (
                                                _vehicle getVariable
                                                [
                                                    "big_gau8_reverbIntervalSpread",
                                                    0.45
                                                ]
                                            )
                                            max 0
                                            min 1.5;

                                        _vehicle setVariable
                                        [
                                            "big_gau8_nextTailTick",
                                            diag_tickTime +
                                            _tailIntervalMin +
                                            (random _tailIntervalSpread)
                                        ];

                                        private _enclosedTail =
                                            (
                                                _objectOcclusion >
                                                0.18
                                            ) ||
                                            {_objectHitCount >= 2};

                                        private _tailType =
                                            [
                                                "open",
                                                "enclosed"
                                            ]
                                            select _enclosedTail;

                                        private _tailVariant =
                                            1 + floor (random 2);

                                        private _tailPath =
                                            format
                                            [
                                                "z\big\addons\main\sounds\cannon\environment_tail_%1_%2.wav",
                                                _tailType,
                                                _tailVariant
                                            ];

                                        private _tailRise =
                                            linearConversion
                                            [
                                                80,
                                                300,
                                                _currentDistance,
                                                0,
                                                1,
                                                true
                                            ];

                                        private _tailFall =
                                            linearConversion
                                            [
                                                900,
                                                2500,
                                                _currentDistance,
                                                1,
                                                0.25,
                                                true
                                            ];

                                        private _tailDistanceScale =
                                            _tailRise *
                                            _tailFall;

                                        private _tailEnvironmentScale =
                                            if (_enclosedTail) then
                                            {
                                                1.15
                                            }
                                            else
                                            {
                                                (
                                                    0.65 +
                                                    (
                                                        0.70 *
                                                        _reflectionPresence
                                                    )
                                                )
                                                min 1.15
                                            };

                                        private _tailOcclusionScale =
                                            linearConversion
                                            [
                                                0,
                                                1,
                                                _combinedOcclusion,
                                                1,
                                                0.35,
                                                true
                                            ];

                                        private _tailEventScale = 1.0;

                                        if (_isBodyStart) then
                                        {
                                            _tailEventScale = 0.85;
                                        };

                                        if (_isBodyEnd) then
                                        {
                                            _tailEventScale = 1.10;
                                        };

                                        private _tailSourceTrim =
                                            _farBodyTrim;

                                        if (_isCloseBody) then
                                        {
                                            _tailSourceTrim =
                                                _closeBodyTrim;
                                        };

                                        if (_isMidBody) then
                                        {
                                            _tailSourceTrim =
                                                _midBodyTrim;
                                        };

                                        private _reverbMaster =
                                            (
                                                _vehicle getVariable
                                                [
                                                    "big_gau8_reverbMaster",
                                                    1.0
                                                ]
                                            )
                                            max 0
                                            min 2;

                                        private _reverbLevel =
                                            (
                                                _vehicle getVariable
                                                [
                                                    "big_gau8_reverbLevel",
                                                    0.20
                                                ]
                                            )
                                            max 0
                                            min 0.60;

                                        private _tailVolume =
                                            _eventVolume *
                                            _externalMaster *
                                            _tailSourceTrim *
                                            _reverbMaster *
                                            _reverbLevel *
                                            _tailDistanceScale *
                                            _tailEnvironmentScale *
                                            _tailOcclusionScale *
                                            _tailEventScale;

                                        private _tailPredelay =
                                            if (_enclosedTail) then
                                            {
                                                0.080 +
                                                random 0.020
                                            }
                                            else
                                            {
                                                0.100 +
                                                random 0.030
                                            };

                                        private _tailPitch =
                                            (
                                                1 +
                                                (
                                                    (
                                                        _dopplerFactor -
                                                        1
                                                    ) *
                                                    0.65
                                                )
                                            )
                                            max 0.60
                                            min 1.80;

                                        if (
                                            _tailVolume >
                                            0.000001
                                        ) then
                                        {
                                            [
                                                _vehicle,
                                                _soundAnchor,
                                                _tailPath,
                                                +_eventPositionASL,
                                                _tailVolume min 12,
                                                _tailPitch,
                                                _eventMaxDistance,
                                                _tailPredelay,
                                                _generation
                                            ]
                                            spawn
                                            {
                                                params
                                                [
                                                    "_vehicle",
                                                    "_soundAnchor",
                                                    "_tailPath",
                                                    "_tailPositionASL",
                                                    "_tailVolume",
                                                    "_tailPitch",
                                                    "_tailMaxDistance",
                                                    "_tailPredelay",
                                                    "_generation"
                                                ];

                                                uiSleep _tailPredelay;

                                                if (
                                                    isNull _vehicle ||
                                                    {
                                                        (
                                                            _vehicle
                                                            getVariable
                                                            [
                                                                "big_gau8_handlerGeneration",
                                                                -1
                                                            ]
                                                        ) !=
                                                        _generation
                                                    }
                                                ) exitWith {};

                                                private _tailID =
                                                    playSound3D
                                                    [
                                                        _tailPath,
                                                        _soundAnchor,
                                                        false,
                                                        _tailPositionASL,
                                                        _tailVolume,
                                                        _tailPitch,
                                                        _tailMaxDistance,
                                                        0,
                                                        true
                                                    ];

                                                if (_tailID >= 0) then
                                                {
                                                    private _tailIDs =
                                                        _vehicle
                                                        getVariable
                                                        [
                                                            "big_gau8_reverbIDs",
                                                            []
                                                        ];

                                                    _tailIDs pushBack
                                                        _tailID;

                                                    while
                                                    {
                                                        (count _tailIDs)
                                                        > 32
                                                    }
                                                    do
                                                    {
                                                        _tailIDs
                                                            deleteAt 0;
                                                    };

                                                    _vehicle setVariable
                                                    [
                                                        "big_gau8_reverbIDs",
                                                        _tailIDs
                                                    ];
                                                };
                                            };
                                        };

                                        if (
                                            _vehicle getVariable
                                            [
                                                "big_gau8_debugReverb",
                                                false
                                            ]
                                        ) then
                                        {
                                            private _tailMessage =
                                                format
                                                [
                                                    "GAU-8 reverb: type=%1 distance=%2 m predelay=%3 ms volume=%4 pitch=%5 event=%6",
                                                    _tailType,
                                                    (
                                                        _currentDistance
                                                        toFixed 1
                                                    ),
                                                    (
                                                        (
                                                            _tailPredelay *
                                                            1000
                                                        )
                                                        toFixed 1
                                                    ),
                                                    (
                                                        _tailVolume
                                                        toFixed 3
                                                    ),
                                                    (
                                                        _tailPitch
                                                        toFixed 3
                                                    ),
                                                    _eventPath
                                                ];

                                            systemChat _tailMessage;
                                            diag_log _tailMessage;
                                        };
                                    };
                                };

                                if (
                                    _vehicle getVariable
                                    [
                                        "big_gau8_debugPresence",
                                        false
                                    ]
                                ) then
                                {
                                    private _nextPresenceDebug =
                                        _vehicle getVariable
                                        [
                                            "big_gau8_nextPresenceDebug",
                                            -1
                                        ];

                                    private _presenceDebugTick =
                                        diag_tickTime;

                                    if (
                                        _presenceDebugTick >=
                                        _nextPresenceDebug
                                    ) then
                                    {
                                        _vehicle setVariable
                                        [
                                            "big_gau8_nextPresenceDebug",
                                            _presenceDebugTick + 0.50
                                        ];

                                        private _presenceMessage =
                                            format
                                            [
                                                "GAU-8 presence: master=%1 close=%2 mid=%3 far=%4 muzzle=%5 mechanical=%6 eq=%7 path=%8",
                                                (_externalMaster toFixed 3),
                                                (_closeBodyTrim toFixed 3),
                                                (_midBodyTrim toFixed 3),
                                                (_farBodyTrim toFixed 3),
                                                (_muzzleTrim toFixed 3),
                                                (_mechanicalTrim toFixed 3),
                                                _presenceEQEnabled,
                                                _eventPath
                                            ];

                                        systemChat _presenceMessage;
                                        diag_log _presenceMessage;
                                    };
                                };

                                if (
                                    _vehicle getVariable
                                    [
                                        "big_gau8_debugDoppler",
                                        false
                                    ]
                                ) then
                                {
                                    private _nextDopplerDebug =
                                        _vehicle getVariable
                                        [
                                            "big_gau8_nextDopplerDebug",
                                            -1
                                        ];

                                    private _dopplerDebugTick =
                                        diag_tickTime;

                                    if (
                                        _dopplerDebugTick >=
                                        _nextDopplerDebug
                                    ) then
                                    {
                                        _vehicle setVariable
                                        [
                                            "big_gau8_nextDopplerDebug",
                                            _dopplerDebugTick + 0.25
                                        ];

                                        private _dopplerMessage =
                                            format
                                            [
                                                "GAU-8 Doppler: sourceRadial=%1 m/s listenerRadial=%2 m/s raw=%3 applied=%4 basePitch=%5 playbackPitch=%6",
                                                (
                                                    _sourceVelocityAlongRay
                                                    toFixed 1
                                                ),
                                                (
                                                    _listenerVelocityAlongRay
                                                    toFixed 1
                                                ),
                                                (
                                                    _rawDopplerFactor
                                                    toFixed 3
                                                ),
                                                (
                                                    _dopplerFactor
                                                    toFixed 3
                                                ),
                                                (_eventPitch toFixed 3),
                                                (
                                                    _eventPlaybackPitch
                                                    toFixed 3
                                                )
                                            ];

                                        systemChat _dopplerMessage;
                                        diag_log _dopplerMessage;
                                    };
                                };

                                if (
                                    _vehicle getVariable
                                    [
                                        "big_gau8_debugPropagation",
                                        false
                                    ]
                                ) then
                                {
                                    private _nextPropagationDebug =
                                        _vehicle getVariable
                                        [
                                            "big_gau8_nextPropagationDebug",
                                            -1
                                        ];

                                    private _debugTick = diag_tickTime;

                                    if (
                                        _debugTick >=
                                        _nextPropagationDebug
                                    ) then
                                    {
                                        _vehicle setVariable
                                        [
                                            "big_gau8_nextPropagationDebug",
                                            _debugTick + 0.50
                                        ];

                                        private _actualToF =
                                            _debugTick -
                                            _storedEmissionTick;

                                        private _geometricToF =
                                            _currentDistance /
                                            _speedOfSound;

                                        private _timingErrorMs =
                                            (
                                                _actualToF -
                                                _geometricToF
                                            ) *
                                            1000;

                                        private _propagationMessage =
                                            format
                                            [
                                                "GAU-8 propagation: distance=%1 m c=%2 m/s geometric=%3 s actual=%4 s error=%5 ms path=%6",
                                                (_currentDistance toFixed 1),
                                                (_speedOfSound toFixed 1),
                                                (_geometricToF toFixed 3),
                                                (_actualToF toFixed 3),
                                                (_timingErrorMs toFixed 1),
                                                _eventPath
                                            ];

                                        systemChat
                                            _propagationMessage;

                                        diag_log
                                            _propagationMessage;
                                    };
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
