params
[
    "_vehicle",
    "_path",
    "_emissionPositionASL",
    "_arrivalTime",
    "_volume",
    ["_pitch", 1.0],
    ["_maxDistance", 50000],
    ["_sourceVelocityOverride", []],
    ["_lockedArrivalTick", -1],
    ["_emissionTickOverride", -1],
    ["_reportBurstToken", -1]
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
        "gau_gau8_handlerGeneration",
        -1
    ];


private _speedOfSound =
    (
        _vehicle getVariable
        [
            "gau_gau8_speedOfSound",
            343.0
        ]
    ) max 300 min 360;

private _queueCallTick =
    diag_tickTime;

private _pathLowerAtQueue =
    toLower _path;

private _isRipAtQueue =
    (_pathLowerAtQueue find "\sounds\rip\") >= 0;

private _lockedArrivalValid =
    false;

if (_isRipAtQueue) then
{
    if (_lockedArrivalTick >= (_queueCallTick - 0.25)) then
    {
        if (_lockedArrivalTick <= (_queueCallTick + 25.0)) then
        {
            _lockedArrivalValid =
                true;
        };
    };
};

private _emissionTick = [_queueCallTick, _emissionTickOverride] select (_emissionTickOverride >= 0);

private _ripCrossTrackAtQueue =
    -1.0;

private _eventPropagationSpeed =
    _speedOfSound;

if (_isRipAtQueue) then
{
    private _candidateEmissionTick =
        _arrivalTime;

    _ripCrossTrackAtQueue =
        _vehicle getVariable
        [
            "gau_gau8_ripCrossTrack",
            -1.0
        ];

    private _geometrySnapshot =
        _vehicle getVariable
        [
            "gau_gau8_ripEventGeometry",
            []
        ];

    if ((count _geometrySnapshot) >= 3) then
    {
        private _geometryPositionASL =
            _geometrySnapshot param
            [
                0,
                []
            ];

        if (
            (count _geometryPositionASL) == 3 &&
            {
                (
                    _geometryPositionASL
                    vectorDistance
                    _emissionPositionASL
                ) <= 5
            }
        ) then
        {
            _candidateEmissionTick =
                _geometrySnapshot param
                [
                    1,
                    _candidateEmissionTick
                ];

            _ripCrossTrackAtQueue =
                _geometrySnapshot param
                [
                    2,
                    _ripCrossTrackAtQueue
                ];

            _eventPropagationSpeed =
                (
                    _geometrySnapshot param
                    [
                        6,
                        _eventPropagationSpeed
                    ]
                ) max 300 min 360;
        };
    };

    if (
        _candidateEmissionTick >=
        (_queueCallTick - 1.5) &&
        {
            _candidateEmissionTick <=
            (_queueCallTick + 5.0)
        }
    ) then
    {
        _emissionTick =
            _candidateEmissionTick;
    };
};


private _sourceVelocityAtEmission =
    if ((count _sourceVelocityOverride) == 3) then
    {
        +_sourceVelocityOverride
    }
    else
    {
        if (_isRipAtQueue) then
        {
            [0, 0, 0]
        }
        else
        {
            velocity _vehicle
        }
    };

private _listenerAtQueueASL =
    AGLToASL
    (
        positionCameraToWorld [0, 0, 0]
    );

private _initialDistance =
    _listenerAtQueueASL vectorDistance _emissionPositionASL;

private _arrivalHint =
    if (_lockedArrivalValid) then
    {
        _lockedArrivalTick
    }
    else
    {
        _emissionTick +
        (_initialDistance / _eventPropagationSpeed)
    };


private _reportPathLowerAtQueue =
    _pathLowerAtQueue;

private _isReportBodyAtQueue =
    !_isRipAtQueue &&
    {
        (
            _reportPathLowerAtQueue find
            "\sounds\cannon\"
        ) >= 0
    } &&
    {
        (
            _reportPathLowerAtQueue find
            "_body_"
        ) >= 0
    };

private _isReportBodyStartAtQueue =
    _isReportBodyAtQueue &&
    {
        (
            _reportPathLowerAtQueue find
            "_body_start.wav"
        ) >= 0
    };

private _isReportBodyEndAtQueue =
    _isReportBodyAtQueue &&
    {
        (
            _reportPathLowerAtQueue find
            "_body_end"
        ) >= 0
    };

private _reportBurstClockEnabled =
    _vehicle getVariable
    [
        "gau_gau8_reportBurstClockEnabled",
        true
    ];

private _reportLockedArrivalTick =
    -1.0;

if (
    _reportBurstClockEnabled &&
    {_isReportBodyAtQueue} &&
    {_reportBurstToken >= 0}
) then
{


    private _clock =
        _vehicle getVariable
        [
            "gau_gau8_reportBurstClock",
            []
        ];

    private _clockValid =
        (count _clock) >= 5;

    private _clockGeneration =
        _clock param [0, -999];

    private _clockToken =
        _clock param [1, -999];

    private _clockStartEmission =
        _clock param [2, -1.0];

    private _clockBaseArrival =
        _clock param [3, -1.0];

    private _clockLastEmission =
        _clock param [4, -1.0];

    if (
        _clockGeneration isNotEqualTo _generation ||
        {
            (_reportBurstToken >= 0) &&
            {_clockToken isNotEqualTo _reportBurstToken}
        } ||
        {_emissionTick < (_clockLastEmission - 0.001)} ||
        {
            (
                _emissionTick -
                _clockLastEmission
            ) > 0.80
        }
    ) then
    {
        _clockValid = false;
    };

    if (
        _isReportBodyStartAtQueue ||
        {!_clockValid}
    ) then
    {
        _clockToken = _reportBurstToken;
        _clockStartEmission = _emissionTick;

        _clockBaseArrival =
            _emissionTick +
            (
                _initialDistance /
                _eventPropagationSpeed
            );

        _clockLastEmission = _emissionTick;
        _clockValid = true;
    };

    if (_clockValid) then
    {
        _reportLockedArrivalTick =
            _clockBaseArrival +
            (
                _emissionTick -
                _clockStartEmission
            );

        _vehicle setVariable
        [
            "gau_gau8_reportBurstClock",
            [
                _generation,
                _clockToken,
                _clockStartEmission,
                _clockBaseArrival,
                _emissionTick
            ]
        ];

        if (_isReportBodyEndAtQueue) then
        {
            _vehicle setVariable
            [
                "gau_gau8_reportBurstClock",
                []
            ];
        };
    };
};

private _queue =
    _vehicle getVariable
    [
        "gau_gau8_arrivalQueue",
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
    +_sourceVelocityAtEmission,
    _ripCrossTrackAtQueue,
    _eventPropagationSpeed,
    if (
        _reportLockedArrivalTick >= 0
    ) then
    {
        _reportLockedArrivalTick
    }
    else
    {
        [
            -1,
            _lockedArrivalTick
        ]
        select _lockedArrivalValid
    },
    _reportBurstToken
];


_queue sort true;

private _aircraftQueueLimit = 4096;

while {(count _queue) > _aircraftQueueLimit} do
{
    _queue deleteAt ((count _queue) - 1);
};

_vehicle setVariable
[
    "gau_gau8_arrivalQueue",
    _queue
];

private _workerRunning =
    _vehicle getVariable
    [
        "gau_gau8_arrivalWorkerRunning",
        false
    ];

if (!_workerRunning) then
{
    private _workerToken =
        (
            _vehicle getVariable
            [
                "gau_gau8_arrivalWorkerToken",
                0
            ]
        ) + 1;

    _vehicle setVariable
    [
        "gau_gau8_arrivalWorkerToken",
        _workerToken
    ];

    _vehicle setVariable
    [
        "gau_gau8_arrivalWorkerRunning",
        true
    ];

    [
        _vehicle,
        _generation,
        _workerToken
    ]
    spawn
    {
        params
        [
            "_vehicle",
            "_generation",
            "_workerToken"
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
                        "gau_gau8_handlerGeneration",
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
                            "gau_gau8_arrivalQueue",
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
                            private _ownedToken =
                                _vehicle getVariable
                                [
                                    "gau_gau8_arrivalWorkerToken",
                                    -1
                                ];

                            if (_ownedToken == _workerToken) then
                            {
                                _vehicle setVariable
                                [
                                    "gau_gau8_arrivalWorkerRunning",
                                    false
                                ];
                            };


                            uiSleep 0.001;

                            private _queueAfterRelease =
                                _vehicle getVariable
                                [
                                    "gau_gau8_arrivalQueue",
                                    []
                                ];

                            private _runningAfterRelease =
                                _vehicle getVariable
                                [
                                    "gau_gau8_arrivalWorkerRunning",
                                    false
                                ];

                            private _tokenAfterRelease =
                                _vehicle getVariable
                                [
                                    "gau_gau8_arrivalWorkerToken",
                                    -1
                                ];

                            if (
                                (count _queueAfterRelease) > 0 &&
                                {!_runningAfterRelease} &&
                                {_tokenAfterRelease == _workerToken}
                            ) then
                            {
                                _vehicle setVariable
                                [
                                    "gau_gau8_arrivalWorkerRunning",
                                    true
                                ];

                                _emptySinceTick = -1.0;
                            }
                            else
                            {
                                _finished = true;
                            };
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
                                    "gau_gau8_speedOfSound",
                                    343.0
                                ]
                            ) max 300 min 360;

                        private _nowTick = diag_tickTime;
                        private _nextIndex = -1;
                        private _nextArrivalTick = 1e12;
                        private _nextDistance = 0.0;


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

                            private _candidatePropagationSpeed =
                                (
                                    _x param
                                    [
                                        10,
                                        _speedOfSound
                                    ]
                                ) max 300 min 360;

                            private _candidateLockedArrivalTick =
                                _x param
                                [
                                    11,
                                    -1
                                ];

                            private _candidateArrivalTick =
                                if (_candidateLockedArrivalTick >= 0) then
                                {
                                    _candidateLockedArrivalTick
                                }
                                else
                                {
                                    _candidateEmissionTick +
                                    (
                                        _candidateDistance /
                                        _candidatePropagationSpeed
                                    )
                                };

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
                                    "gau_gau8_arrivalQueue",
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
                                    ["_storedSourceVelocity", [0, 0, 0]],
                                    ["_eventRipCrossTrack", -1.0],
                                    ["_eventPropagationSpeed", 343.0],
                                    ["_eventLockedArrivalTick", -1.0],
                                    ["_eventReportBurstToken", -1]
                                ];

                                private _currentDistance =
                                    _nextDistance;

                                if (
                                    _eventGeneration ==
                                    _generation
                                ) then
                                {


                                _listenerPositionASL =
                                    AGLToASL
                                    (
                                        positionCameraToWorld [0, 0, 0]
                                    );

                                _currentDistance =
                                    _listenerPositionASL
                                    vectorDistance
                                    _eventPositionASL;


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
                                        "gau_gau8_dopplerEnabled",
                                        true
                                    ];

                                private _dopplerMaster =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_dopplerMaster",
                                            1.0
                                        ]
                                    ) max 0 min 1;

                                private _dopplerMinimum =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_dopplerMinimum",
                                            0.60
                                        ]
                                    ) max 0.25 min 1.0;

                                private _dopplerMaximum =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_dopplerMaximum",
                                            1.80
                                        ]
                                    ) max 1.0 min 3.0;

                                private _dopplerDenominator =
                                    (
                                        _eventPropagationSpeed -
                                        _sourceVelocityAlongRay
                                    )
                                    max 25.0;

                                private _rawDopplerFactor =
                                    (
                                        _eventPropagationSpeed -
                                        _listenerVelocityAlongRay
                                    ) /
                                    _dopplerDenominator;


                                private _dopplerPathLower =
                                    toLower _eventPath;

                                private _isReportDopplerEvent =
                                    (


                                        _dopplerPathLower find
                                        "\sounds\cannon\"
                                    ) >= 0;


                                private _isMRReportPitchEvent =
                                    (
                                        (_dopplerPathLower find "\mr_v27_09\mr_body_") >= 0
                                    ) ||
                                    {
                                        (_dopplerPathLower find "\mr_v27_11\mr_body_") >= 0
                                    };

                                private _reportDopplerEnabled =
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_reportDopplerEnabled",
                                        missionNamespace getVariable
                                        [
                                            "gau_gau8_reportDopplerEnabledDefault",
                                            true
                                        ]
                                    ];

                                private _reportSourcePulseHz =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_reportSourcePulseHz",
                                            missionNamespace getVariable
                                            [
                                                "gau_gau8_reportSourcePulseHzDefault",
                                                107.623318
                                            ]
                                        ]
                                    )
                                    max 1;

                                private _reportStationaryPulseHz =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_reportStationaryPulseHz",
                                            missionNamespace getVariable
                                            [
                                                "gau_gau8_reportStationaryPulseHzDefault",
                                                65.0
                                            ]
                                        ]
                                    )
                                    max 1;

                                private _reportBasePitch =
                                    if (_isMRReportPitchEvent) then
                                    {
                                        _reportStationaryPulseHz /
                                        _reportSourcePulseHz
                                    }
                                    else
                                    {
                                        1.0
                                    };

                                private _reportRecedeMaster =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_reportDopplerRecedeMaster",
                                            missionNamespace getVariable
                                            [
                                                "gau_gau8_reportDopplerRecedeMasterDefault",
                                                1.0
                                            ]
                                        ]
                                    )
                                    max 0
                                    min 1;

                                private _reportApproachMaster =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_reportDopplerApproachMaster",
                                            missionNamespace getVariable
                                            [
                                                "gau_gau8_reportDopplerApproachMasterDefault",
                                                1.0
                                            ]
                                        ]
                                    )
                                    max 0
                                    min 1;

                                private _reportApproachPitchCap =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_reportApproachPitchCap",
                                            missionNamespace getVariable
                                            [
                                                "gau_gau8_reportApproachPitchCapDefault",
                                                1.0
                                            ]
                                        ]
                                    )
                                    max _reportBasePitch
                                    min 1.10;

                                private _applyEventDoppler =
                                    _dopplerEnabled &&
                                    (
                                        !_isReportDopplerEvent ||
                                        {_reportDopplerEnabled}
                                    );

                                private _dopplerFactor =
                                    if (_applyEventDoppler) then
                                    {
                                        if (
                                            _isMRReportPitchEvent &&
                                            {_isReportDopplerEvent}
                                        ) then
                                        {
                                            private _reportPhysicalFactor =
                                                if (_rawDopplerFactor <= 1.0) then
                                                {
                                                    1 +
                                                    (
                                                        (
                                                            _rawDopplerFactor -
                                                            1
                                                        ) *
                                                        _reportRecedeMaster
                                                    )
                                                }
                                                else
                                                {
                                                    1 +
                                                    (
                                                        (
                                                            _rawDopplerFactor -
                                                            1
                                                        ) *
                                                        _reportApproachMaster
                                                    )
                                                };

                                            if (_rawDopplerFactor > 1.0) then
                                            {
                                                private _relativeApproachCap =
                                                    _reportApproachPitchCap /
                                                    _reportBasePitch;

                                                _reportPhysicalFactor =
                                                    _reportPhysicalFactor min
                                                    _relativeApproachCap;
                                            };

                                            _reportPhysicalFactor
                                                max _dopplerMinimum
                                                min _dopplerMaximum
                                        }
                                        else
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
                                    }
                                    else
                                    {
                                        1.0
                                    };

                                private _eventPlaybackPitch =
                                    (
                                        _eventPitch *
                                        _reportBasePitch *
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
                                    call gau_gau8_fnc_getEnvironmentState;

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


                                private _terrainRipScale =
                                    linearConversion
                                    [
                                        0,
                                        1,
                                        _terrainOcclusion,
                                        1.00,
                                        0.12,
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

                                private _objectRipScale =
                                    linearConversion
                                    [
                                        0,
                                        1,
                                        _objectOcclusion,
                                        1.00,
                                        0.18,
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

                                private _isMRBody =
                                    ((_pathLower find "\mr_v27_09\mr_body_") >= 0) ||
                                    {((_pathLower find "\mr_v27_11\mr_body_") >= 0)};

                                private _isMRCloseBody =
                                    _isMRBody && {((_pathLower find "_close") >= 0)};

                                private _isMRMidBody =
                                    _isMRBody && {((_pathLower find "_mid") >= 0)};

                                private _isMRFarBody =
                                    _isMRBody && {((_pathLower find "_far") >= 0)};


                                private _isMRAttack =
                                    _isMRBody &&
                                    {((_pathLower find "mr_body_start_") >= 0)};

                                private _isMRSustain =
                                    _isMRBody &&
                                    {((_pathLower find "mr_body_v27_23_grain_") >= 0)};

                                private _isMRRelease =
                                    _isMRBody &&
                                    {((_pathLower find "mr_body_release_") >= 0)};

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

                                private _isRip =
                                    (_pathLower find "sounds\rip\rip_") >= 0;

                                private _isRipAttack =
                                    (_pathLower find "rip_attack.wav") >= 0;

                                private _isRipSustain =
                                    (_pathLower find "rip_sustain") >= 0;

                                private _isRipRelease =
                                    (_pathLower find "rip_release.wav") >= 0;

                                if (_isRipAttack) then
                                {
                                    _vehicle setVariable ["gau_gau8_ripHandoffAttackArrivalTick",diag_tickTime];
                                    _vehicle setVariable ["gau_gau8_ripHandoffAttackTargetTick",_eventLockedArrivalTick];
                                    _vehicle setVariable ["gau_gau8_ripHandoffAttackEmissionTick",_storedEmissionTick];
                                    _vehicle setVariable ["gau_gau8_ripHandoffAttackDistance",_currentDistance];
                                    _vehicle setVariable ["gau_gau8_ripHandoffAttackPropagationSpeed",_eventPropagationSpeed];
                                    _vehicle setVariable ["gau_gau8_ripHandoffSustainLogged",false];
                                };

                                if (_isRipSustain) then
                                {
                                    private _handoffLogged = _vehicle getVariable ["gau_gau8_ripHandoffSustainLogged",false];

                                    if (!_handoffLogged) then
                                    {
                                        _vehicle setVariable ["gau_gau8_ripHandoffSustainLogged",true];

                                        private _attackArrivalTick = _vehicle getVariable ["gau_gau8_ripHandoffAttackArrivalTick",-1];
                                        private _attackTargetTick = _vehicle getVariable ["gau_gau8_ripHandoffAttackTargetTick",-1];
                                        private _attackEmissionTick = _vehicle getVariable ["gau_gau8_ripHandoffAttackEmissionTick",-1];
                                        private _attackDistance = _vehicle getVariable ["gau_gau8_ripHandoffAttackDistance",-1];
                                        private _attackPropagationSpeed = _vehicle getVariable ["gau_gau8_ripHandoffAttackPropagationSpeed",_eventPropagationSpeed];
                                        private _intendedDelta = 10 / 65;
                                        private _actualArrivalDelta = -1;
                                        private _phaseErrorMs = -9999;
                                        private _lockedTargetDelta = -1;
                                        private _lockedPlaybackErrorMs = -9999;
                                        private _emissionDelta = -1;
                                        private _propagationDelta = 0;

                                        if (_attackArrivalTick >= 0) then
                                        {
                                            _actualArrivalDelta = diag_tickTime - _attackArrivalTick;
                                            _phaseErrorMs = (_actualArrivalDelta - _intendedDelta) * 1000;
                                        };

                                        if (
                                            _attackTargetTick >= 0 &&
                                            {_eventLockedArrivalTick >= 0}
                                        ) then
                                        {
                                            _lockedTargetDelta =
                                                _eventLockedArrivalTick -
                                                _attackTargetTick;

                                            _lockedPlaybackErrorMs =
                                                (
                                                    diag_tickTime -
                                                    _eventLockedArrivalTick
                                                ) *
                                                1000;
                                        };

                                        if (_attackEmissionTick >= 0) then
                                        {
                                            _emissionDelta = _storedEmissionTick - _attackEmissionTick;
                                        };

                                        if (_attackDistance >= 0) then
                                        {
                                            _propagationDelta =
                                                (_currentDistance / _eventPropagationSpeed) -
                                                (_attackDistance / _attackPropagationSpeed);
                                        };

                                        private _closeGain = _vehicle getVariable ["gau_gau8_lastCloseGain",0];
                                        private _midGain = _vehicle getVariable ["gau_gau8_lastMidBodyGain",0];
                                        private _farGain = _vehicle getVariable ["gau_gau8_lastFarBodyGain",0];
                                        private _bodyDistance = _vehicle getVariable ["gau_gau8_lastListenerDistance",-1];
                                        private _bodyTotal = _closeGain + _midGain + _farGain;
                                        private _closeShare = 0;
                                        private _midShare = 0;
                                        private _farShare = 0;

                                        if (_bodyTotal > 0.000001) then
                                        {
                                            _closeShare = _closeGain / _bodyTotal;
                                            _midShare = _midGain / _bodyTotal;
                                            _farShare = _farGain / _bodyTotal;
                                        };

                                        private _telemetry =
                                        [
                                            _actualArrivalDelta,
                                            _intendedDelta,
                                            _phaseErrorMs,
                                            _emissionDelta,
                                            _propagationDelta,
                                            _currentDistance,
                                            _bodyDistance,
                                            _closeGain,
                                            _midGain,
                                            _farGain,
                                            _closeShare,
                                            _midShare,
                                            _farShare,
                                            diag_tickTime - _nextArrivalTick,
                                            _lockedTargetDelta,
                                            _lockedPlaybackErrorMs
                                        ];

                                        _vehicle setVariable ["gau_gau8_lastRipHandoffTelemetry",_telemetry];

                                        if (_vehicle getVariable ["gau_gau8_debugRipHandoff",false]) then
                                        {
                                            private _handoffMessage = format ["GAU-8 handoff: actual=%1ms target=%2ms error=%3ms lockedDelta=%4ms lockedErr=%5ms emissionDelta=%6ms propagationDelta=%7ms processLag=%8ms | bodyDist=%9m gains=%10/%11/%12 shares=%13/%14/%15",round(_actualArrivalDelta*1000),round(_intendedDelta*1000),_phaseErrorMs toFixed 2,(_lockedTargetDelta*1000) toFixed 2,_lockedPlaybackErrorMs toFixed 2,(_emissionDelta*1000) toFixed 2,(_propagationDelta*1000) toFixed 2,((diag_tickTime-_nextArrivalTick)*1000) toFixed 2,round _bodyDistance,_closeGain toFixed 3,_midGain toFixed 3,_farGain toFixed 3,_closeShare toFixed 2,_midShare toFixed 2,_farShare toFixed 2];
                                            systemChat _handoffMessage;
                                            diag_log _handoffMessage;
                                        };
                                    };
                                };

                                private _isImpact =
                                    (_pathLower find "__removed_custom_impact_audio__") >= 0;


                                private _externalMaster =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_externalMaster",
                                            1.0
                                        ]
                                    )
                                    max 0
                                    min 4;


                                private _reportMaster =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_reportMaster",
                                            1.0
                                        ]
                                    )
                                    max 0
                                    min 16;


                                private _reportRangeMaster =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_reportRangeMaster",
                                            1.50
                                        ]
                                    )
                                    max 0.50
                                    min 3.00;


                                private _reportOutputCeiling =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_reportOutputCeiling",
                                            5.0
                                        ]
                                    )
                                    max 0
                                    min 5;


                                private _parallelReportEnabled =
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_parallelReportEnabled",
                                        false
                                    ];

                                private _parallelReportTrimA =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_parallelReportTrimA",
                                            0.85
                                        ]
                                    )
                                    max 0
                                    min 2;

                                private _parallelReportTrimB =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_parallelReportTrimB",
                                            0.65
                                        ]
                                    )
                                    max 0
                                    min 2;

                                private _closeBodyTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_closeBodyTrim",
                                            1.258925
                                        ]
                                    )
                                    max 0
                                    min 4;

                                private _midBodyTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_midBodyTrim",
                                            1.412538
                                        ]
                                    )
                                    max 0
                                    min 4;

                                private _farBodyTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_farBodyTrim",
                                            1.333521
                                        ]
                                    )
                                    max 0
                                    min 4;

                                private _muzzleTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_muzzleTrim",
                                            1.122018
                                        ]
                                    )
                                    max 0
                                    min 4;

                                private _mechanicalTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_mechanicalTrim",
                                            1.0
                                        ]
                                    )
                                    max 0
                                    min 4;

                                private _ripOutputMaster =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_ripOutputMaster",
                                            0.40
                                        ]
                                    )
                                    max 0
                                    min 2;

                                private _ripDryTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_ripDryTrim",
                                            0.70
                                        ]
                                    )
                                    max 0
                                    min 2;


                                private _ripReflectionSourceTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_ripReflectionSourceTrim",
                                            0.88
                                        ]
                                    )
                                    max 0
                                    min 2;


                                private _ripPhysicalBlendEnabled =
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_ripPhysicalBlendEnabled",
                                        false
                                    ];

                                private _ripScatterLevel =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_ripScatterLevel",
                                            0.20
                                        ]
                                    )
                                    max 0
                                    min 0.60;

                                private _ripScatterMaxDistance =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_ripScatterMaxDistance",
                                            5000
                                        ]
                                    )
                                    max 1000
                                    min 10000;


                                private _ripDistanceLayersEnabled =
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_ripDistanceLayersEnabled",
                                        true
                                    ];


                                private _ripBodyEnabled =
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_ripBodyEnabled",
                                        false
                                    ];

                                private _ripBodyTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_ripBodyTrim",
                                            0.95
                                        ]
                                    )
                                    max 0
                                    min 2.5;


                                private _ripDetailEnabled =
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_ripDetailEnabled",
                                        false
                                    ];

                                private _ripDetailTrim =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_ripDetailTrim",
                                            0.22
                                        ]
                                    )
                                    max 0
                                    min 0.70;

                                private _ripCrossTrackShapingEnabled =
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_ripCrossTrackShapingEnabled",
                                        true
                                    ];


                                private _ripBodyPredelay =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_ripBodyPredelay",
                                            0.000
                                        ]
                                    )
                                    max 0
                                    min 0.003;

                                private _ripDetailPredelay =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_ripDetailPredelay",
                                            0.000
                                        ]
                                    )
                                    max 0
                                    min 0.003;

                                private _sampleRipDistanceCurve =
                                {
                                    params
                                    [
                                        "_distance",
                                        "_points"
                                    ];

                                    if ((count _points) <= 0)
                                    exitWith
                                    {
                                        0
                                    };

                                    private _result =
                                        (_points select 0) select 1;

                                    private _lastPoint =
                                        _points select -1;

                                    if (
                                        _distance >=
                                        (_lastPoint select 0)
                                    )
                                    exitWith
                                    {
                                        _lastPoint select 1
                                    };

                                    for "_curveIndex" from 0 to
                                    (
                                        (count _points) - 2
                                    )
                                    do
                                    {
                                        private _pointA =
                                            _points select _curveIndex;

                                        private _pointB =
                                            _points select
                                            (
                                                _curveIndex + 1
                                            );

                                        private _distanceA =
                                            _pointA select 0;

                                        private _distanceB =
                                            _pointB select 0;

                                        if (
                                            _distance >= _distanceA &&
                                            {_distance <= _distanceB}
                                        )
                                        exitWith
                                        {
                                            _result =
                                                linearConversion
                                                [
                                                    _distanceA,
                                                    _distanceB,
                                                    _distance,
                                                    _pointA select 1,
                                                    _pointB select 1,
                                                    true
                                                ];
                                        };
                                    };

                                    _result
                                };

                                private _presenceEQEnabled =
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_presenceEQEnabled",
                                        true
                                    ];


                                private _groundResponseEnabled =
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_groundResponseEnabled",
                                        true
                                    ];

                                private _groundResponseMaster =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_groundResponseMaster",
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


                                private _ripGroundRawScale =
                                    [1400] call _groundInterferenceScale;

                                private _ripGroundScale =
                                    1 +
                                    (
                                        (
                                            _ripGroundRawScale -
                                            1
                                        ) *
                                        0.55
                                    );

                                private _soundAnchor =
                                    if (!isNull player) then
                                    {
                                        vehicle player
                                    }
                                    else
                                    {
                                        _vehicle
                                    };


                                private _alternateBodyGrainPath =
                                {
                                    params
                                    [
                                        "_sourcePath",
                                        "_offset"
                                    ];

                                    private _sourceLower =
                                        toLower _sourcePath;

                                    private _grainIndex = -1;

                                    {
                                        if (
                                            (
                                                _sourceLower find
                                                format
                                                [
                                                    "_grain_%1.wav",
                                                    _x
                                                ]
                                            ) >= 0
                                        ) exitWith
                                        {
                                            _grainIndex = _x;
                                        };
                                    }
                                    forEach [1,2,3,4,5,6];

                                    if (_grainIndex < 1) exitWith
                                    {
                                        _sourcePath
                                    };

                                    private _alternateIndex =
                                        (
                                            (
                                                _grainIndex -
                                                1 +
                                                _offset
                                            )
                                            mod 6
                                        ) +
                                        1;

                                    [
                                        _sourcePath,
                                        format
                                        [
                                            "_grain_%1.wav",
                                            _grainIndex
                                        ],
                                        format
                                        [
                                            "_grain_%1.wav",
                                            _alternateIndex
                                        ]
                                    ]
                                    call _replaceToken
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

                                    private _outputMaxDistance =
                                        _eventMaxDistance;

                                    if (
                                        !_isRip &&
                                        {!_isImpact}
                                    ) then
                                    {
                                        _outputMaxDistance =
                                            _eventMaxDistance *
                                            _reportRangeMaster;
                                    };

                                    private _outputCeiling =
                                        24;

                                    if (
                                        !_isRip &&
                                        {!_isImpact}
                                    ) then
                                    {
                                        _outputCeiling =
                                            _reportOutputCeiling;
                                    };

                                    private _soundID =
                                        playSound3D
                                        [
                                            _resolvedPath,
                                            _soundAnchor,
                                            false,
                                            _eventPositionASL,
                                            _outputVolume min _outputCeiling,
                                            _eventPlaybackPitch,
                                            _outputMaxDistance,
                                            0,
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

                                        while {(count _ids) > 128} do
                                        {
                                            _ids deleteAt 0;
                                        };

                                        _vehicle setVariable
                                        [
                                            "gau_gau8_grainIDs",
                                            _ids
                                        ];
                                    };
                                };


                                private _playRipSupportSound =
                                {
                                    params
                                    [
                                        "_supportPath",
                                        "_supportVolume",
                                        "_supportDelay"
                                    ];

                                    if (
                                        _supportPath isEqualTo "" ||
                                        {_supportVolume <= 0.000001}
                                    ) exitWith {};

                                    [
                                        _vehicle,
                                        _soundAnchor,
                                        _supportPath,
                                        +_eventPositionASL,
                                        _supportVolume min 5,
                                        _eventPlaybackPitch,
                                        _eventMaxDistance,
                                        _generation,
                                        _supportDelay
                                    ]
                                    spawn
                                    {
                                        params
                                        [
                                            "_vehicle",
                                            "_soundAnchor",
                                            "_supportPath",
                                            "_supportPositionASL",
                                            "_supportVolume",
                                            "_supportPitch",
                                            "_supportMaxDistance",
                                            "_generation",
                                            "_supportDelay"
                                        ];

                                        if (_supportDelay > 0) then
                                        {
                                            uiSleep _supportDelay;
                                        };

                                        if (
                                            isNull _vehicle ||
                                            {
                                                (
                                                    _vehicle getVariable
                                                    [
                                                        "gau_gau8_handlerGeneration",
                                                        -1
                                                    ]
                                                ) !=
                                                _generation
                                            }
                                        ) exitWith {};

                                        private _soundID =
                                            playSound3D
                                            [
                                                _supportPath,
                                                _soundAnchor,
                                                false,
                                                _supportPositionASL,
                                                _supportVolume,
                                                _supportPitch,
                                                _supportMaxDistance,
                                                0,
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

                                            while {(count _ids) > 128} do
                                            {
                                                _ids deleteAt 0;
                                            };

                                            _vehicle setVariable
                                            [
                                                "gau_gau8_grainIDs",
                                                _ids
                                            ];
                                        };
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
                                            _reportMaster *
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
                                            _reportMaster *
                                            _midBodyTrim *
                                            _midLeakScale *
                                            _midGroundScale
                                        ]
                                        call _playExternalSound;

                                        [
                                            _farPath,
                                            _eventVolume *
                                            _externalMaster *
                                            _reportMaster *
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
                                            _reportMaster *
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
                                            _reportMaster *
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
                                            _reportMaster *
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
                                            _reportMaster *
                                            _midBodyTrim *
                                            _midLeakScale *
                                            _midGroundScale
                                        ]
                                        call _playExternalSound;
                                    };


                                    if (
                                        _parallelReportEnabled &&
                                        {_isBodyGrain}
                                    ) then
                                    {
                                        private _parallelBaseVolume = 0;

                                        if (_isCloseBody) then
                                        {
                                            _parallelBaseVolume =
                                                _eventVolume *
                                                _externalMaster *
                                                _reportMaster *
                                                _closeBodyTrim *
                                                _terrainCloseScale *
                                                _objectCloseScale;
                                        };

                                        if (_isMidBody) then
                                        {
                                            _parallelBaseVolume =
                                                _eventVolume *
                                                _externalMaster *
                                                _reportMaster *
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
                                                );
                                        };

                                        if (_isFarBody) then
                                        {
                                            _parallelBaseVolume =
                                                _eventVolume *
                                                _externalMaster *
                                                _reportMaster *
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
                                                );
                                        };

                                        if (
                                            _parallelBaseVolume >
                                            0.000001
                                        ) then
                                        {
                                            private _parallelPathA =
                                                [
                                                    _eventPath,
                                                    2
                                                ]
                                                call
                                                _alternateBodyGrainPath;

                                            private _parallelPathB =
                                                [
                                                    _eventPath,
                                                    4
                                                ]
                                                call
                                                _alternateBodyGrainPath;

                                            if (
                                                _parallelPathA isNotEqualTo
                                                _eventPath
                                            ) then
                                            {
                                                [
                                                    _parallelPathA,
                                                    _parallelBaseVolume *
                                                    _parallelReportTrimA
                                                ]
                                                call
                                                _playExternalSound;
                                            };

                                            if (
                                                _parallelPathB isNotEqualTo
                                                _eventPath &&
                                                _parallelPathB isNotEqualTo
                                                _parallelPathA
                                            ) then
                                            {
                                                [
                                                    _parallelPathB,
                                                    _parallelBaseVolume *
                                                    _parallelReportTrimB
                                                ]
                                                call
                                                _playExternalSound;
                                            };
                                        };
                                    };
                                }
                                else
                                {
                                    private _eventScale = 1.0;
                                    private _eventTrim = 1.0;
                                    private _eventMaster =
                                        _externalMaster *
                                        _reportMaster;

                                    if (_isImpact) then
                                    {
                                        _eventMaster = 1.0;
                                    };

                                    if (_isRip) then
                                    {
                                        _eventMaster =
                                            _externalMaster *
                                            _ripOutputMaster;
                                    };

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

                                    if (_isMRBody) then
                                    {


                                        private _mrGroundResponseMaster =
                                            (
                                                _vehicle getVariable
                                                [
                                                    "gau_gau8_mrGroundResponseMaster",
                                                    missionNamespace getVariable
                                                    [
                                                        "gau_gau8_mrGroundResponseMasterDefault",
                                                        0.30
                                                    ]
                                                ]
                                            )
                                            max 0
                                            min 1;

                                        private _mrGroundScale = 1.0;

                                        if (_isMRCloseBody) then
                                        {
                                            _mrGroundScale =
                                                1 +
                                                (
                                                    (
                                                        _closeGroundScale -
                                                        1
                                                    ) *
                                                    _mrGroundResponseMaster
                                                );

                                            _eventScale =
                                                _terrainCloseScale *
                                                _objectCloseScale *
                                                _mrGroundScale;
                                        };

                                        if (_isMRMidBody) then
                                        {
                                            _mrGroundScale =
                                                1 +
                                                (
                                                    (
                                                        _midGroundScale -
                                                        1
                                                    ) *
                                                    _mrGroundResponseMaster
                                                );

                                            _eventScale =
                                                _terrainMidScale *
                                                _objectMidScale *
                                                _mrGroundScale;
                                        };

                                        if (_isMRFarBody) then
                                        {
                                            _mrGroundScale =
                                                1 +
                                                (
                                                    (
                                                        _farGroundScale -
                                                        1
                                                    ) *
                                                    _mrGroundResponseMaster
                                                );

                                            _eventScale =
                                                _terrainFarScale *
                                                _objectFarScale *
                                                _mrGroundScale;
                                        };

                                        _eventTrim =
                                            (
                                                _vehicle getVariable
                                                [
                                                    "gau_gau8_mrDirectTrim",
                                                    1.20
                                                ]
                                            )
                                            max 0
                                            min 4;
                                    };

                                    if (_isRip) then
                                    {
                                        private _ripDirectWeight =
                                            1.0;

                                        private _ripBodyWeight =
                                            0.0;

                                        private _ripDetailWeight =
                                            1.0;

                                        private _ripDirectCrossTrackScale =
                                            1.0;

                                        private _ripBodyCrossTrackScale =
                                            1.0;

                                        private _ripDetailCrossTrackScale =
                                            1.0;

                                        if (
                                            _ripCrossTrackShapingEnabled &&
                                            {_eventRipCrossTrack >= 0}
                                        ) then
                                        {
                                            _ripDirectCrossTrackScale =
                                                [
                                                    _eventRipCrossTrack,
                                                    [
                                                        [0,    1.00],
                                                        [25,   1.00],
                                                        [50,   0.95],
                                                        [100,  0.82],
                                                        [200,  0.64],
                                                        [350,  0.47],
                                                        [500,  0.35],
                                                        [750,  0.24],
                                                        [1000, 0.17],
                                                        [1200, 0.12]
                                                    ]
                                                ]
                                                call
                                                _sampleRipDistanceCurve;

                                            _ripBodyCrossTrackScale =
                                                [
                                                    _eventRipCrossTrack,
                                                    [
                                                        [0,    1.00],
                                                        [100,  1.00],
                                                        [250,  0.94],
                                                        [500,  0.84],
                                                        [750,  0.74],
                                                        [1000, 0.64],
                                                        [1200, 0.58]
                                                    ]
                                                ]
                                                call
                                                _sampleRipDistanceCurve;

                                            _ripDetailCrossTrackScale =
                                                [
                                                    _eventRipCrossTrack,
                                                    [
                                                        [0,    1.00],
                                                        [50,   0.95],
                                                        [100,  0.82],
                                                        [200,  0.65],
                                                        [350,  0.48],
                                                        [500,  0.34],
                                                        [750,  0.22],
                                                        [1000, 0.14],
                                                        [1200, 0.09]
                                                    ]
                                                ]
                                                call
                                                _sampleRipDistanceCurve;
                                        };

                                        if (_ripDistanceLayersEnabled) then
                                        {
                                            _ripDirectWeight =
                                                [
                                                    _currentDistance,
                                                    [
                                                        [0,    1.00],
                                                        [250,  1.00],
                                                        [500,  0.92],
                                                        [800,  0.80],
                                                        [1200, 0.64],
                                                        [1800, 0.46],
                                                        [2600, 0.30],
                                                        [3500, 0.20],
                                                        [4000, 0.14]
                                                    ]
                                                ]
                                                call
                                                _sampleRipDistanceCurve;

                                            _ripBodyWeight =
                                                [
                                                    _currentDistance,
                                                    [
                                                        [0,    0.16],
                                                        [250,  0.24],
                                                        [500,  0.38],
                                                        [800,  0.58],
                                                        [1200, 0.82],
                                                        [1800, 1.05],
                                                        [2600, 1.18],
                                                        [3500, 1.28],
                                                        [4000, 1.32]
                                                    ]
                                                ]
                                                call
                                                _sampleRipDistanceCurve;

                                            _ripDetailWeight =
                                                [
                                                    _currentDistance,
                                                    [
                                                        [0,    1.00],
                                                        [250,  1.00],
                                                        [500,  0.94],
                                                        [800,  0.84],
                                                        [1200, 0.68],
                                                        [1800, 0.46],
                                                        [2600, 0.27],
                                                        [3500, 0.14],
                                                        [4000, 0.08]
                                                    ]
                                                ]
                                                call
                                                _sampleRipDistanceCurve;
                                        };

                                        private _ripDirectSeatScale =
                                            linearConversion
                                            [
                                                0,
                                                0.18,
                                                _reflectionPresence,
                                                1.00,
                                                0.82,
                                                true
                                            ];

                                        _eventScale =
                                            _terrainRipScale *
                                            _objectRipScale *
                                            _ripGroundScale *
                                            _ripDirectSeatScale *
                                            _ripDirectWeight *
                                            _ripDirectCrossTrackScale;

                                        _eventTrim = _ripDryTrim;

                                        if (
                                            _ripDetailEnabled &&
                                            {
                                                _isRipAttack ||
                                                {_isRipSustain}
                                            } &&
                                            {
                                                _ripDetailWeight >
                                                0.000001
                                            }
                                        ) then
                                        {
                                            private _ripDetailPath =
                                                "";

                                            if (_isRipAttack) then
                                            {
                                                _ripDetailPath =
                                                    "z\gau\addons\main\sounds\rip\rip_attack_detail_v23.wav";
                                            };

                                            if (_isRipSustain) then
                                            {
                                                _ripDetailPath =
                                                    [
                                                        _eventPath,
                                                        "rip_sustain_seq_",
                                                        "rip_detail_seq_"
                                                    ]
                                                    call
                                                    _replaceToken;
                                            };

                                            if (_ripDetailPath isNotEqualTo "") then
                                            {
                                                private _ripDetailTerrainScale =
                                                    linearConversion
                                                    [
                                                        0,
                                                        1,
                                                        _terrainOcclusion,
                                                        1.00,
                                                        0.10,
                                                        true
                                                    ];

                                                private _ripDetailObjectScale =
                                                    linearConversion
                                                    [
                                                        0,
                                                        1,
                                                        _objectOcclusion,
                                                        1.00,
                                                        0.18,
                                                        true
                                                    ];

                                                private _ripDetailSeatScale =
                                                    linearConversion
                                                    [
                                                        0,
                                                        0.18,
                                                        _reflectionPresence,
                                                        0.96,
                                                        1.04,
                                                        true
                                                    ];

                                                [
                                                    _ripDetailPath,
                                                    _eventVolume *
                                                    _eventMaster *
                                                    _ripDetailTrim *
                                                    _ripDetailWeight *
                                                    _ripDetailTerrainScale *
                                                    _ripDetailObjectScale *
                                                    _ripDetailSeatScale *
                                                    _ripDetailCrossTrackScale,
                                                    _ripDetailPredelay
                                                ]
                                                call
                                                _playRipSupportSound;
                                            };
                                        };

                                        if (
                                            _ripBodyEnabled &&
                                            {_ripDistanceLayersEnabled} &&
                                            {
                                                _isRipAttack ||
                                                {_isRipSustain}
                                            } &&
                                            {
                                                _ripBodyWeight >
                                                0.000001
                                            }
                                        ) then
                                        {
                                            private _ripBodyPath =
                                                "";

                                            if (_isRipAttack) then
                                            {
                                                _ripBodyPath =
                                                    "z\gau\addons\main\sounds\rip\rip_attack_body_v22.wav";
                                            };

                                            if (_isRipSustain) then
                                            {
                                                _ripBodyPath =
                                                    [
                                                        _eventPath,
                                                        "rip_sustain_seq_",
                                                        "rip_body_seq_"
                                                    ]
                                                    call
                                                    _replaceToken;
                                            };

                                            if (_ripBodyPath isNotEqualTo "") then
                                            {
                                                private _ripBodyFarBlend =
                                                    linearConversion
                                                    [
                                                        600,
                                                        2600,
                                                        _currentDistance,
                                                        0,
                                                        1,
                                                        true
                                                    ];

                                                private _ripBodyTerrainScale =
                                                    _terrainMidScale +
                                                    (
                                                        (
                                                            _terrainFarScale -
                                                            _terrainMidScale
                                                        ) *
                                                        _ripBodyFarBlend
                                                    );

                                                private _ripBodyObjectScale =
                                                    _objectMidScale +
                                                    (
                                                        (
                                                            _objectFarScale -
                                                            _objectMidScale
                                                        ) *
                                                        _ripBodyFarBlend
                                                    );

                                                private _ripBodyGroundScale =
                                                    _midGroundScale +
                                                    (
                                                        (
                                                            _farGroundScale -
                                                            _midGroundScale
                                                        ) *
                                                        _ripBodyFarBlend
                                                    );

                                                private _ripBodySeatScale =
                                                    linearConversion
                                                    [
                                                        0,
                                                        0.18,
                                                        _reflectionPresence,
                                                        0.96,
                                                        1.08,
                                                        true
                                                    ];

                                                [
                                                    _ripBodyPath,
                                                    _eventVolume *
                                                    _eventMaster *
                                                    _ripBodyTrim *
                                                    _ripBodyWeight *
                                                    _ripBodyTerrainScale *
                                                    _ripBodyObjectScale *
                                                    _ripBodyGroundScale *
                                                    _ripBodySeatScale *
                                                    _ripBodyCrossTrackScale,
                                                    _ripBodyPredelay
                                                ]
                                                call
                                                _playRipSupportSound;
                                            };
                                        };


                                        if (
                                            (
                                                _isRipAttack ||
                                                {_isRipSustain}
                                            ) &&
                                            {
                                                _vehicle getVariable
                                                [
                                                    "gau_gau8_reverbEnabled",
                                                    true
                                                ]
                                            } &&
                                            {
                                                _vehicle getVariable
                                                [
                                                    "gau_gau8_ripReflectionEnabled",
                                                    true
                                                ]
                                            }
                                        ) then
                                        {
                                            private _ripReflectionMode =
                                                [
                                                    "emit",
                                                    "capture"
                                                ]
                                                select _isRipAttack;

                                            private _ripReflectionBaseVolume =
                                                _eventVolume *
                                                _eventMaster *
                                                _ripReflectionSourceTrim *
                                                _ripDirectWeight *
                                                _ripDirectCrossTrackScale;

                                            [
                                                _vehicle,
                                                _soundAnchor,
                                                +_eventPositionASL,
                                                +_listenerPositionASL,
                                                _currentDistance,
                                                _ripReflectionBaseVolume,
                                                _eventPlaybackPitch,
                                                _eventMaxDistance,
                                                _terrainOcclusion,
                                                _objectOcclusion,
                                                _combinedOcclusion,
                                                _reflectionPresence,
                                                +_reflectionPositionASL,
                                                _reflectionExtraDelay,
                                                _generation,
                                                _ripReflectionMode
                                            ]
                                            spawn
                                            gau_gau8_fnc_playRipReflectionField;
                                        };
                                    };

                                    [
                                        _eventPath,
                                        _eventVolume *
                                        _eventMaster *
                                        _eventTrim *
                                        _eventScale
                                    ]
                                    call _playExternalSound;
                                };


                                if (
                                    _ripPhysicalBlendEnabled &&
                                    {_isRip} &&
                                    {
                                        _isRipAttack ||
                                        {_isRipSustain}
                                    } &&
                                    {
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_reverbEnabled",
                                            true
                                        ]
                                    }
                                ) then
                                {
                                    private _ripScatterPath =
                                        "";

                                    if (_isRipAttack) then
                                    {
                                        _ripScatterPath =
                                            "z\gau\addons\main\sounds\rip\rip_attack_scatter_v21.wav";
                                    };

                                    if (_isRipSustain) then
                                    {
                                        _ripScatterPath =
                                            [
                                                _eventPath,
                                                "rip_sustain_seq_",
                                                "rip_sustain_scatter_seq_"
                                            ]
                                            call _replaceToken;
                                    };

                                    if (_ripScatterPath isNotEqualTo "") then
                                    {
                                        private _ripScatterDistanceScale =
                                            if (
                                                _ripDistanceLayersEnabled
                                            ) then
                                            {
                                                [
                                                    _currentDistance,
                                                    [
                                                        [0,    0.05],
                                                        [250,  0.07],
                                                        [500,  0.14],
                                                        [800,  0.26],
                                                        [1200, 0.42],
                                                        [1800, 0.60],
                                                        [2600, 0.74],
                                                        [3500, 0.84],
                                                        [4000, 0.88]
                                                    ]
                                                ]
                                                call
                                                _sampleRipDistanceCurve
                                            }
                                            else
                                            {
                                                (
                                                    linearConversion
                                                    [
                                                        35,
                                                        650,
                                                        _currentDistance,
                                                        0.52,
                                                        1.00,
                                                        true
                                                    ]
                                                ) *
                                                (
                                                    linearConversion
                                                    [
                                                        2200,
                                                        4000,
                                                        _currentDistance,
                                                        1.00,
                                                        0.62,
                                                        true
                                                    ]
                                                )
                                            };

                                        private _ripScatterCrossTrackScale =
                                            1.0;

                                        if (
                                            _ripCrossTrackShapingEnabled &&
                                            {_eventRipCrossTrack >= 0}
                                        ) then
                                        {
                                            _ripScatterCrossTrackScale =
                                                [
                                                    _eventRipCrossTrack,
                                                    [
                                                        [0,    1.00],
                                                        [200,  0.98],
                                                        [500,  0.88],
                                                        [800,  0.76],
                                                        [1200, 0.64]
                                                    ]
                                                ]
                                                call
                                                _sampleRipDistanceCurve;
                                        };

                                        private _ripScatterEnvironmentScale =
                                            (
                                                0.55 +
                                                (
                                                    1.75 *
                                                    _reflectionPresence
                                                ) +
                                                (
                                                    0.24 *
                                                    _objectOcclusion
                                                ) +
                                                (
                                                    0.14 *
                                                    _terrainOcclusion
                                                )
                                            )
                                            max 0.45
                                            min 1.15;

                                        private _ripScatterOcclusionScale =
                                            linearConversion
                                            [
                                                0,
                                                1,
                                                _combinedOcclusion,
                                                1.00,
                                                0.58,
                                                true
                                            ];

                                        private _ripScatterEventScale =
                                            [
                                                1.00,
                                                1.14
                                            ]
                                            select _isRipAttack;

                                        private _ripScatterVolume =
                                            _eventVolume *
                                            _externalMaster *
                                            _ripOutputMaster *
                                            _ripScatterLevel *
                                            _ripScatterDistanceScale *
                                            _ripScatterEnvironmentScale *
                                            _ripScatterOcclusionScale *
                                            _ripScatterEventScale *
                                            _ripScatterCrossTrackScale;

                                        private _ripScatterPredelay =
                                            (
                                                0.018 +
                                                (
                                                    (
                                                        _reflectionExtraDelay
                                                        max 0
                                                    )
                                                    min 0.060
                                                ) +
                                                random 0.012
                                            )
                                            min 0.090;

                                        private _ripScatterPositionASL =
                                            if (
                                                _reflectionPresence >
                                                0.015
                                            ) then
                                            {
                                                +_reflectionPositionASL
                                            }
                                            else
                                            {
                                                +_eventPositionASL
                                            };

                                        if (
                                            _ripScatterVolume >
                                            0.000001
                                        ) then
                                        {
                                            [
                                                _vehicle,
                                                _soundAnchor,
                                                _ripScatterPath,
                                                _ripScatterPositionASL,
                                                _ripScatterVolume min 5,
                                                _eventPlaybackPitch,
                                                _eventMaxDistance min
                                                _ripScatterMaxDistance,
                                                _ripScatterPredelay,
                                                _generation
                                            ]
                                            spawn
                                            {
                                                params
                                                [
                                                    "_vehicle",
                                                    "_soundAnchor",
                                                    "_scatterPath",
                                                    "_scatterPositionASL",
                                                    "_scatterVolume",
                                                    "_scatterPitch",
                                                    "_scatterMaxDistance",
                                                    "_scatterPredelay",
                                                    "_generation"
                                                ];

                                                uiSleep _scatterPredelay;

                                                if (
                                                    isNull _vehicle ||
                                                    {
                                                        (
                                                            _vehicle getVariable
                                                            [
                                                                "gau_gau8_handlerGeneration",
                                                                -1
                                                            ]
                                                        ) !=
                                                        _generation
                                                    }
                                                ) exitWith {};

                                                private _scatterID =
                                                    playSound3D
                                                    [
                                                        _scatterPath,
                                                        _soundAnchor,
                                                        false,
                                                        _scatterPositionASL,
                                                        _scatterVolume,
                                                        _scatterPitch,
                                                        _scatterMaxDistance,
                                                        0,
                                                        true
                                                    ];

                                                if (_scatterID >= 0) then
                                                {
                                                    private _scatterIDs =
                                                        _vehicle getVariable
                                                        [
                                                            "gau_gau8_reverbIDs",
                                                            []
                                                        ];

                                                    _scatterIDs pushBack
                                                        _scatterID;

                                                    while
                                                    {
                                                        (count _scatterIDs) >
                                                        48
                                                    }
                                                    do
                                                    {
                                                        _scatterIDs deleteAt 0;
                                                    };

                                                    _vehicle setVariable
                                                    [
                                                        "gau_gau8_reverbIDs",
                                                        _scatterIDs
                                                    ];
                                                };
                                            };
                                        };
                                    };
                                };

                                private _reverbEnabled =
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_reverbEnabled",
                                        true
                                    ];


                                private _isLegacyReportTailEvent =
                                    (
                                        _isCloseBody ||
                                        {_isMidBody} ||
                                        {_isFarBody}
                                    ) &&
                                    (
                                        _isBodyStart ||
                                        {_isBodyGrain} ||
                                        {_isBodyEnd}
                                    );

                                private _isMRReportTailEvent =
                                    _isMRBody &&
                                    (
                                        _isMRAttack ||
                                        {_isMRSustain} ||
                                        {_isMRRelease}
                                    );

                                if (
                                    _reverbEnabled &&
                                    (
                                        _isLegacyReportTailEvent ||
                                        {_isMRReportTailEvent}
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
                                            "gau_gau8_lastTailBucket",
                                            -1
                                        ];

                                    private _nextTailTick =
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_nextTailTick",
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
                                            {_isBodyEnd} ||
                                            {_isMRAttack} ||
                                            {_isMRRelease}
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
                                            "gau_gau8_lastTailBucket",
                                            _eventBucket
                                        ];

                                        private _tailIntervalMin =
                                            (
                                                _vehicle getVariable
                                                [
                                                    "gau_gau8_reverbIntervalMin",
                                                    0.42
                                                ]
                                            )
                                            max 0.35
                                            min 2.0;

                                        private _tailIntervalSpread =
                                            (
                                                _vehicle getVariable
                                                [
                                                    "gau_gau8_reverbIntervalSpread",
                                                    0.18
                                                ]
                                            )
                                            max 0
                                            min 1.5;

                                        _vehicle setVariable
                                        [
                                            "gau_gau8_nextTailTick",
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
                                                "z\gau\addons\main\sounds\cannon\environment_tail_%1_%2.wav",
                                                _tailType,
                                                _tailVariant
                                            ];

                                        private _tailRise =
                                            linearConversion
                                            [
                                                0,
                                                700,
                                                _currentDistance,
                                                0.18,
                                                1,
                                                true
                                            ];

                                        private _tailFall =
                                            linearConversion
                                            [
                                                1200,
                                                3200,
                                                _currentDistance,
                                                1,
                                                0.35,
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

                                        if (
                                            _isBodyStart ||
                                            {_isMRAttack}
                                        ) then
                                        {
                                            _tailEventScale = 0.85;
                                        };

                                        if (
                                            _isBodyEnd ||
                                            {_isMRRelease}
                                        ) then
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

                                        if (_isMRBody) then
                                        {


                                            _tailSourceTrim =
                                                (
                                                    _vehicle getVariable
                                                    [
                                                        "gau_gau8_mrDirectTrim",
                                                        1.20
                                                    ]
                                                )
                                                max 0
                                                min 4;
                                        };

                                        private _reverbMaster =
                                            (
                                                _vehicle getVariable
                                                [
                                                    "gau_gau8_reverbMaster",
                                                    1.0
                                                ]
                                            )
                                            max 0
                                            min 2;

                                        private _reverbLevel =
                                            (
                                                _vehicle getVariable
                                                [
                                                    "gau_gau8_reverbLevel",
                                                    0.34
                                                ]
                                            )
                                            max 0
                                            min 0.80;

                                        private _tailVolume =
                                            _eventVolume *
                                            _externalMaster *
                                            _reportMaster *
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
                                                0.030 +
                                                random 0.020
                                            }
                                            else
                                            {
                                                0.055 +
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
                                                (
                                                    _eventMaxDistance *
                                                    _reportRangeMaster
                                                ),
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
                                                                "gau_gau8_handlerGeneration",
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
                                                            "gau_gau8_reverbIDs",
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
                                                        "gau_gau8_reverbIDs",
                                                        _tailIDs
                                                    ];
                                                };
                                            };
                                        };

                                        if (
                                            _vehicle getVariable
                                            [
                                                "gau_gau8_debugReverb",
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
                                    _reverbEnabled &&
                                    {_isRip} &&
                                    {_isRipRelease} &&
                                    {
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_ripTerminalTailEnabled",
                                            true
                                        ]
                                    }
                                ) then
                                {
                                    private _ripTerminalEnclosed =
                                        (
                                            _objectOcclusion >
                                            0.18
                                        ) ||
                                        {_objectHitCount >= 2};

                                    private _ripTerminalType =
                                        [
                                            "open",
                                            "enclosed"
                                        ]
                                        select _ripTerminalEnclosed;

                                    private _ripTerminalVariantCount =
                                        [
                                            3,
                                            2
                                        ]
                                        select _ripTerminalEnclosed;

                                    private _ripTerminalVariant =
                                        1 +
                                        floor
                                        (
                                            random
                                            _ripTerminalVariantCount
                                        );

                                    private _ripTerminalPath =
                                        format
                                        [
                                            "z\gau\addons\main\sounds\rip\environment\rip_terminal_tail_%1_%2.wav",
                                            _ripTerminalType,
                                            _ripTerminalVariant
                                        ];

                                    private _ripTerminalLevel =
                                        (
                                            _vehicle getVariable
                                            [
                                                "gau_gau8_ripTerminalTailLevel",
                                                0.72
                                            ]
                                        )
                                        max 0
                                        min 2.0;

                                    private _ripTerminalDistanceScale =
                                        if (_currentDistance <= 120) then
                                        {
                                            linearConversion
                                            [
                                                0,
                                                120,
                                                _currentDistance,
                                                0.58,
                                                0.82,
                                                true
                                            ]
                                        }
                                        else
                                        {
                                            if (_currentDistance <= 800) then
                                            {
                                                linearConversion
                                                [
                                                    120,
                                                    800,
                                                    _currentDistance,
                                                    0.82,
                                                    1.10,
                                                    true
                                                ]
                                            }
                                            else
                                            {
                                                if (_currentDistance <= 1800) then
                                                {
                                                    linearConversion
                                                    [
                                                        800,
                                                        1800,
                                                        _currentDistance,
                                                        1.10,
                                                        1.00,
                                                        true
                                                    ]
                                                }
                                                else
                                                {
                                                    linearConversion
                                                    [
                                                        1800,
                                                        4000,
                                                        _currentDistance,
                                                        1.00,
                                                        0.52,
                                                        true
                                                    ]
                                                };
                                            };
                                        };

                                    private _ripTerminalEnvironmentScale =
                                        if (_ripTerminalEnclosed) then
                                        {
                                            (
                                                1.08 +
                                                (0.28 * _objectOcclusion)
                                            )
                                            min 1.32
                                        }
                                        else
                                        {
                                            (
                                                0.82 +
                                                (0.58 * _reflectionPresence)
                                            )
                                            min 1.25
                                        };

                                    private _ripTerminalOcclusionScale =
                                        linearConversion
                                        [
                                            0,
                                            1,
                                            _combinedOcclusion,
                                            1.00,
                                            0.82,
                                            true
                                        ];

                                    private _ripTerminalVolume =
                                        _eventVolume *
                                        _externalMaster *
                                        _ripOutputMaster *
                                        _ripTerminalLevel *
                                        _ripTerminalDistanceScale *
                                        _ripTerminalEnvironmentScale *
                                        _ripTerminalOcclusionScale;

                                    private _ripTerminalPredelay =
                                        if (_ripTerminalEnclosed) then
                                        {
                                            0.006 +
                                            random 0.012
                                        }
                                        else
                                        {
                                            0.010 +
                                            random 0.018
                                        };

                                    if (
                                        _ripTerminalVolume >
                                        0.000001
                                    ) then
                                    {
                                        [
                                            _vehicle,
                                            _soundAnchor,
                                            _ripTerminalPath,
                                            +_eventPositionASL,
                                            _ripTerminalVolume min 8,
                                            _eventPlaybackPitch,
                                            _eventMaxDistance min 5000,
                                            _ripTerminalPredelay,
                                            _ripTerminalEnclosed,
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
                                                "_tailInside",
                                                "_generation"
                                            ];

                                            uiSleep _tailPredelay;

                                            if (
                                                isNull _vehicle ||
                                                {
                                                    (
                                                        _vehicle getVariable
                                                        [
                                                            "gau_gau8_handlerGeneration",
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
                                                    _tailInside,
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
                                                    _vehicle getVariable
                                                    [
                                                        "gau_gau8_reverbIDs",
                                                        []
                                                    ];

                                                _tailIDs pushBack
                                                    _tailID;

                                                while
                                                {
                                                    (count _tailIDs) >
                                                    48
                                                }
                                                do
                                                {
                                                    _tailIDs deleteAt 0;
                                                };

                                                _vehicle setVariable
                                                [
                                                    "gau_gau8_reverbIDs",
                                                    _tailIDs
                                                ];
                                            };
                                        };
                                    };

                                    if (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_debugReverb",
                                            false
                                        ]
                                    ) then
                                    {
                                        private _message =
                                            format
                                            [
                                                "GAU-8 terminal rip tail: type=%1 variant=%2 distance=%3m volume=%4 predelay=%5ms path=%6",
                                                _ripTerminalType,
                                                _ripTerminalVariant,
                                                round _currentDistance,
                                                _ripTerminalVolume toFixed 3,
                                                round (_ripTerminalPredelay * 1000),
                                                _ripTerminalPath
                                            ];

                                        systemChat _message;
                                        diag_log _message;
                                    };
                                };


                                if (
                                    _reverbEnabled &&
                                    {_isRip} &&
                                    {
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_ripLegacyTailEnabled",
                                            false
                                        ]
                                    } &&
                                    {
                                        !(
                                            _vehicle getVariable
                                            [
                                                "gau_gau8_ripTerminalTailEnabled",
                                                true
                                            ]
                                        )
                                    }
                                ) then
                                {
                                    private _ripTailNow =
                                        diag_tickTime;

                                    private _nextRipTailTick =
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_nextRipEnvironmentTailTick",
                                            -1
                                        ];

                                    private _ripTailEligible =
                                        _isRipAttack ||
                                        {
                                            _isRipSustain &&
                                            {_ripTailNow >= _nextRipTailTick}
                                        };

                                    if (_ripTailEligible) then
                                    {
                                        _vehicle setVariable
                                        [
                                            "gau_gau8_nextRipEnvironmentTailTick",
                                            _ripTailNow +
                                            0.90 +
                                            random 0.55
                                        ];

                                        private _ripTailEnclosed =
                                            (
                                                _objectOcclusion >
                                                0.18
                                            ) ||
                                            {_objectHitCount >= 2};

                                        private _ripTailType =
                                            [
                                                "open",
                                                "enclosed"
                                            ]
                                            select _ripTailEnclosed;

                                        private _ripTailVariant =
                                            1 + floor (random 2);

                                        private _ripTailPath =
                                            format
                                            [
                                                "z\gau\addons\main\sounds\cannon\environment_tail_%1_%2.wav",
                                                _ripTailType,
                                                _ripTailVariant
                                            ];

                                        private _ripTailRise =
                                            linearConversion
                                            [
                                                25,
                                                180,
                                                _currentDistance,
                                                0.35,
                                                1.00,
                                                true
                                            ];

                                        private _ripTailFall =
                                            linearConversion
                                            [
                                                1200,
                                                4000,
                                                _currentDistance,
                                                1.00,
                                                0.20,
                                                true
                                            ];

                                        private _ripTailEnvironmentScale =
                                            if (_ripTailEnclosed) then
                                            {
                                                1.15
                                            }
                                            else
                                            {
                                                (
                                                    0.70 +
                                                    (
                                                        0.55 *
                                                        _reflectionPresence
                                                    )
                                                )
                                                min 1.10
                                            };

                                        private _ripTailOcclusionScale =
                                            linearConversion
                                            [
                                                0,
                                                1,
                                                _combinedOcclusion,
                                                1.00,
                                                0.55,
                                                true
                                            ];

                                        private _ripTailLevel =
                                            (
                                                _vehicle getVariable
                                                [
                                                    "gau_gau8_ripEnvironmentTailLevel",
                                                    0.045
                                                ]
                                            )
                                            max 0
                                            min 0.20;

                                        private _ripTailEventScale =
                                            [
                                                0.82,
                                                1.00
                                            ]
                                            select _isRipAttack;

                                        private _ripTailVolume =
                                            _eventVolume *
                                            _externalMaster *
                                            _ripOutputMaster *
                                            _ripTailLevel *
                                            _ripTailRise *
                                            _ripTailFall *
                                            _ripTailEnvironmentScale *
                                            _ripTailOcclusionScale *
                                            _ripTailEventScale;

                                        private _ripTailPredelay =
                                            if (_ripTailEnclosed) then
                                            {
                                                0.055 +
                                                random 0.025
                                            }
                                            else
                                            {
                                                0.075 +
                                                random 0.035
                                            };

                                        if (
                                            _ripTailVolume >
                                            0.000001
                                        ) then
                                        {
                                            [
                                                _vehicle,
                                                _soundAnchor,
                                                _ripTailPath,
                                                +_eventPositionASL,
                                                _ripTailVolume min 8,
                                                _eventPlaybackPitch,
                                                _eventMaxDistance min 5000,
                                                _ripTailPredelay,
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
                                                            _vehicle getVariable
                                                            [
                                                                "gau_gau8_handlerGeneration",
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
                                                        _vehicle getVariable
                                                        [
                                                            "gau_gau8_reverbIDs",
                                                            []
                                                        ];

                                                    _tailIDs pushBack
                                                        _tailID;

                                                    while
                                                    {
                                                        (count _tailIDs) >
                                                        32
                                                    }
                                                    do
                                                    {
                                                        _tailIDs deleteAt 0;
                                                    };

                                                    _vehicle setVariable
                                                    [
                                                        "gau_gau8_reverbIDs",
                                                        _tailIDs
                                                    ];
                                                };
                                            };
                                        };
                                    };
                                };

                                if (
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_debugPresence",
                                        false
                                    ]
                                ) then
                                {
                                    private _nextPresenceDebug =
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_nextPresenceDebug",
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
                                            "gau_gau8_nextPresenceDebug",
                                            _presenceDebugTick + 0.50
                                        ];

                                        private _presenceMessage =
                                            format
                                            [
                                                "GAU-8 presence: master=%1 report=%2 range=%3 ceiling=%4 parallel=%5/%6 close=%7 mid=%8 far=%9 muzzle=%10 mechanical=%11 eq=%12 path=%13",
                                                (_externalMaster toFixed 3),
                                                (_reportMaster toFixed 3),
                                                (_reportRangeMaster toFixed 3),
                                                (_reportOutputCeiling toFixed 1),
                                                (_parallelReportTrimA toFixed 2),
                                                (_parallelReportTrimB toFixed 2),
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
                                        "gau_gau8_debugDoppler",
                                        false
                                    ]
                                ) then
                                {
                                    private _nextDopplerDebug =
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_nextDopplerDebug",
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
                                            "gau_gau8_nextDopplerDebug",
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
                                        "gau_gau8_debugPropagation",
                                        false
                                    ]
                                ) then
                                {
                                    private _nextPropagationDebug =
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_nextPropagationDebug",
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
                                            "gau_gau8_nextPropagationDebug",
                                            _debugTick + 0.50
                                        ];

                                        private _actualToF =
                                            _debugTick -
                                            _storedEmissionTick;

                                        private _geometricToF =
                                            _currentDistance /
                                            _eventPropagationSpeed;

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
                                                (_eventPropagationSpeed toFixed 1),
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
                                        "gau_gau8_debugEnvironment",
                                        false
                                    ]
                                ) then
                                {
                                    private _nextDebug =
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_nextEnvironmentDebug",
                                            -1
                                        ];

                                    if (time >= _nextDebug) then
                                    {
                                        _vehicle setVariable
                                        [
                                            "gau_gau8_nextEnvironmentDebug",
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
                    "gau_gau8_handlerGeneration",
                    -1
                ];

            private _ownedToken =
                _vehicle getVariable
                [
                    "gau_gau8_arrivalWorkerToken",
                    -1
                ];

            if (
                _currentGeneration == _generation &&
                {_ownedToken == _workerToken}
            ) then
            {
                _vehicle setVariable
                [
                    "gau_gau8_arrivalWorkerRunning",
                    false
                ];
            };
        };
    };
};

true
