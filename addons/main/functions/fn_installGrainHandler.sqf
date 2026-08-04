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
        "big_gau8_firedHandler",
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
        "big_gau8_farBodySource",
        objNull
    ];

if (!isNull _oldSource) then
{
    deleteVehicle _oldSource;
};

private _oldIDs =
    _aircraft getVariable
    [
        "big_gau8_grainIDs",
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
            "big_gau8_handlerGeneration",
            0
        ]
    ) + 1;

_aircraft setVariable
[
    "big_gau8_handlerGeneration",
    _generation
];

_aircraft setVariable
[
    "big_gau8_grainPaths",
    [
        "z\big\addons\main\sounds\cannon\far_body_grain_1.wav",
        "z\big\addons\main\sounds\cannon\far_body_grain_2.wav",
        "z\big\addons\main\sounds\cannon\far_body_grain_3.wav",
        "z\big\addons\main\sounds\cannon\far_body_grain_4.wav",
        "z\big\addons\main\sounds\cannon\far_body_grain_5.wav",
        "z\big\addons\main\sounds\cannon\far_body_grain_6.wav"
    ]
];

_aircraft setVariable
[
    "big_gau8_startPath",
    "z\big\addons\main\sounds\cannon\far_body_start.wav"
];

_aircraft setVariable
[
    "big_gau8_endPath",
    "z\big\addons\main\sounds\cannon\far_body_end.wav"
];

_aircraft setVariable
[
    "big_gau8_closeBodyPaths",
    [
        "z\big\addons\main\sounds\cannon\close_body_grain_1.wav",
        "z\big\addons\main\sounds\cannon\close_body_grain_2.wav",
        "z\big\addons\main\sounds\cannon\close_body_grain_3.wav",
        "z\big\addons\main\sounds\cannon\close_body_grain_4.wav",
        "z\big\addons\main\sounds\cannon\close_body_grain_5.wav",
        "z\big\addons\main\sounds\cannon\close_body_grain_6.wav"
    ]
];

_aircraft setVariable
[
    "big_gau8_closeBodyStartPath",
    "z\big\addons\main\sounds\cannon\close_body_start.wav"
];

_aircraft setVariable
[
    "big_gau8_closeBodyEndPath",
    "z\big\addons\main\sounds\cannon\close_body_end.wav"
];

_aircraft setVariable
[
    "big_gau8_closeMechanicalPaths",
    [
        "z\big\addons\main\sounds\cannon\close_mechanical_grain_1.wav",
        "z\big\addons\main\sounds\cannon\close_mechanical_grain_2.wav",
        "z\big\addons\main\sounds\cannon\close_mechanical_grain_3.wav",
        "z\big\addons\main\sounds\cannon\close_mechanical_grain_4.wav",
        "z\big\addons\main\sounds\cannon\close_mechanical_grain_5.wav",
        "z\big\addons\main\sounds\cannon\close_mechanical_grain_6.wav"
    ]
];

_aircraft setVariable
[
    "big_gau8_closeMechanicalStartPath",
    "z\big\addons\main\sounds\cannon\close_mechanical_start.wav"
];

_aircraft setVariable
[
    "big_gau8_closeMuzzlePath",
    "z\big\addons\main\sounds\cannon\close_muzzle_blast.wav"
];

_aircraft setVariable
[
    "big_gau8_shockPaths",
    [
        "z\big\addons\main\sounds\cannon\shock_crack_1.wav",
        "z\big\addons\main\sounds\cannon\shock_crack_2.wav",
        "z\big\addons\main\sounds\cannon\shock_crack_3.wav",
        "z\big\addons\main\sounds\cannon\shock_crack_4.wav",
        "z\big\addons\main\sounds\cannon\shock_crack_5.wav",
        "z\big\addons\main\sounds\cannon\shock_crack_6.wav"
    ]
];

_aircraft setVariable
[
    "big_gau8_grainIDs",
    []
];

_aircraft setVariable
[
    "big_gau8_arrivalQueue",
    []
];

_aircraft setVariable
[
    "big_gau8_arrivalWorkerRunning",
    false
];

_aircraft setVariable
[
    "big_gau8_lastGrainIndex",
    -1
];

_aircraft setVariable
[
    "big_gau8_shotCount",
    0
];

_aircraft setVariable
[
    "big_gau8_nextGrainShot",
    9
];

_aircraft setVariable
[
    "big_gau8_monitorRunning",
    false
];

_aircraft setVariable
[
    "big_gau8_lastEmissionPositionASL",
    getPosASL _aircraft
];

_aircraft setVariable
[
    "big_gau8_lastArrivalTime",
    time
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

            if (
                _weapon !=
                "Gatling_30mm_Plane_CAS_01_F"
            ) exitWith {};

            if (_mode != "LowROF") exitWith {};

            _vehicle setVariable
            [
                "big_gau8_lastShotTime",
                time
            ];

            private _shotCount =
                _vehicle getVariable
                [
                    "big_gau8_shotCount",
                    0
                ];

            private _acousticState =
                [
                    _vehicle,
                    _projectile
                ]
                call big_gau8_fnc_getAcousticState;

            _acousticState params
            [
                "_listenerPositionASL",
                "_emissionPositionASL",
                "_listenerDistance",
                "_propagationDelay",
                "_distanceGain",
                "_closeBodyGain",
                "_farBodyGain",
                "_mechanicalGain",
                "_muzzleGain",
                "_forwardDot"
            ];

            private _arrivalTime = time + _propagationDelay;

            /*
                Preserve the final emission state so the release recording
                can arrive from the last-shot position at the correct time.
            */
            _vehicle setVariable
            [
                "big_gau8_lastEmissionPositionASL",
                +_emissionPositionASL
            ];

            _vehicle setVariable
            [
                "big_gau8_lastArrivalTime",
                _arrivalTime
            ];

            _vehicle setVariable
            [
                "big_gau8_lastMuzzleGain",
                _muzzleGain
            ];

            _vehicle setVariable
            [
                "big_gau8_lastListenerDistance",
                _listenerDistance
            ];

            _vehicle setVariable
            [
                "big_gau8_lastPropagationDelay",
                _propagationDelay
            ];

            _vehicle setVariable
            [
                "big_gau8_lastDistanceGain",
                _distanceGain
            ];

            _vehicle setVariable
            [
                "big_gau8_lastCloseGain",
                _closeBodyGain
            ];

            _vehicle setVariable
            [
                "big_gau8_lastFarBodyGain",
                _farBodyGain
            ];

            _vehicle setVariable
            [
                "big_gau8_lastMechanicalGain",
                _mechanicalGain
            ];

            _vehicle setVariable
            [
                "big_gau8_lastForwardDot",
                _forwardDot
            ];

            /*
                Every supersonic projectile produces a short N-wave only
                when the listener lies inside its forward Mach cone. The
                playback position is the point on the trajectory from which
                the earliest wavefront reaches the listener.
            */
            if (!isNull _projectile) then
            {
                private _shockGeometry =
                    [
                        getPosASL _projectile,
                        velocity _projectile,
                        _listenerPositionASL,
                        343.0
                    ]
                    call big_gau8_fnc_calculateShockGeometry;

                if ((count _shockGeometry) == 10) then
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

                    _vehicle setVariable
                    [
                        "big_gau8_lastShockGeometry",
                        _shockGeometry
                    ];

                    if (_shockDistinct) then
                    {
                        private _crossTrackGain =
                            if (_shockCrossTrack <= 25) then
                            {
                                1.00
                            }
                            else
                            {
                                if (_shockCrossTrack <= 50) then
                                {
                                    linearConversion
                                    [25, 50, _shockCrossTrack, 1.00, 0.90, true]
                                }
                                else
                                {
                                    if (_shockCrossTrack <= 100) then
                                    {
                                        linearConversion
                                        [50, 100, _shockCrossTrack, 0.90, 0.68, true]
                                    }
                                    else
                                    {
                                        if (_shockCrossTrack <= 200) then
                                        {
                                            linearConversion
                                            [100, 200, _shockCrossTrack, 0.68, 0.42, true]
                                        }
                                        else
                                        {
                                            if (_shockCrossTrack <= 350) then
                                            {
                                                linearConversion
                                                [200, 350, _shockCrossTrack, 0.42, 0.22, true]
                                            }
                                            else
                                            {
                                                if (_shockCrossTrack <= 500) then
                                                {
                                                    linearConversion
                                                    [350, 500, _shockCrossTrack, 0.22, 0.10, true]
                                                }
                                                else
                                                {
                                                    linearConversion
                                                    [500, 750, _shockCrossTrack, 0.10, 0.00, true]
                                                };
                                            };
                                        };
                                    };
                                };
                            };

                        private _separationGain =
                            linearConversion
                            [
                                0.008,
                                0.120,
                                _shockSeparation,
                                0.20,
                                1.00,
                                true
                            ];

                        private _machGain =
                            linearConversion
                            [
                                1.05,
                                3.20,
                                _shockMach,
                                0.65,
                                1.05,
                                true
                            ];

                        private _shockGain =
                            _crossTrackGain *
                            _separationGain *
                            _machGain;

                        private _shockPaths =
                            _vehicle getVariable
                            [
                                "big_gau8_shockPaths",
                                []
                            ];

                        if (
                            _shockGain > 0.0001 &&
                            {(count _shockPaths) > 0}
                        ) then
                        {
                            private _shockIndex =
                                _shotCount mod (count _shockPaths);

                            [
                                _vehicle,
                                _shockPaths select _shockIndex,
                                _shockEmissionPosition,
                                time + _shockArrival,
                                9.0 * _shockGain,
                                0.985 + random 0.030,
                                5000
                            ]
                            call big_gau8_fnc_queueSoundArrival;
                        };
                    };

                    if (
                        _shotCount == 0 &&
                        {
                            _vehicle getVariable
                            [
                                "big_gau8_debugShock",
                                false
                            ]
                        }
                    ) then
                    {
                        private _message = format
                        [
                            "GAU-8 shock: distinct=%1, x=%2 m, d=%3 m, Mach=%4, lead=%5 ms",
                            _shockDistinct,
                            _shockDownrange,
                            _shockCrossTrack,
                            _shockMach,
                            _shockSeparation * 1000
                        ];

                        systemChat _message;
                        diag_log format
                        [
                            "GAU8 LIVE SHOCK: %1 | speed=%2 m/s | coneX=%3 m | muzzleArrival=%4 s | shockArrival=%5 s | emission=%6",
                            _message,
                            _shockProjectileSpeed,
                            _shockMinimumDownrange,
                            _muzzleArrival,
                            _shockArrival,
                            _shockEmissionPosition
                        ];
                    };
                };
            };

            if (_shotCount == 0) then
            {
                private _farStartPath =
                    _vehicle getVariable
                    [
                        "big_gau8_startPath",
                        ""
                    ];

                private _closeStartPath =
                    _vehicle getVariable
                    [
                        "big_gau8_closeBodyStartPath",
                        ""
                    ];

                private _mechanicalStartPath =
                    _vehicle getVariable
                    [
                        "big_gau8_closeMechanicalStartPath",
                        ""
                    ];

                private _muzzlePath =
                    _vehicle getVariable
                    [
                        "big_gau8_closeMuzzlePath",
                        ""
                    ];

                [
                    _vehicle,
                    _farStartPath,
                    _emissionPositionASL,
                    _arrivalTime,
                    4.8 * _farBodyGain,
                    1.0,
                    50000
                ]
                call big_gau8_fnc_queueSoundArrival;

                [
                    _vehicle,
                    _closeStartPath,
                    _emissionPositionASL,
                    _arrivalTime,
                    4.8 * _closeBodyGain,
                    1.0,
                    50000
                ]
                call big_gau8_fnc_queueSoundArrival;

                [
                    _vehicle,
                    _mechanicalStartPath,
                    _emissionPositionASL,
                    _arrivalTime,
                    4.8 * _mechanicalGain,
                    1.0,
                    500
                ]
                call big_gau8_fnc_queueSoundArrival;

                [
                    _vehicle,
                    _muzzlePath,
                    _emissionPositionASL,
                    _arrivalTime,
                    4.8 * _muzzleGain,
                    1.0,
                    2000
                ]
                call big_gau8_fnc_queueSoundArrival;
            };

            private _farPaths =
                _vehicle getVariable
                [
                    "big_gau8_grainPaths",
                    []
                ];

            private _closeBodyPaths =
                _vehicle getVariable
                [
                    "big_gau8_closeBodyPaths",
                    []
                ];

            private _closeMechanicalPaths =
                _vehicle getVariable
                [
                    "big_gau8_closeMechanicalPaths",
                    []
                ];

            private _grainCount =
                (count _farPaths) min (count _closeBodyPaths);

            if (
                (_grainCount > 0) &&
                (
                    (_farBodyGain > 0.000001) ||
                    (_closeBodyGain > 0.000001) ||
                    (_mechanicalGain > 0.000001)
                )
            ) then
            {
                private _nextGrainShot =
                    _vehicle getVariable
                    [
                        "big_gau8_nextGrainShot",
                        9
                    ];

                if (_shotCount >= _nextGrainShot) then
                {
                    private _lastIndex =
                        _vehicle getVariable
                        [
                            "big_gau8_lastGrainIndex",
                            -1
                        ];

                    private _grainIndex =
                        floor
                        (
                            random _grainCount
                        );

                    if (_grainIndex == _lastIndex) then
                    {
                        _grainIndex =
                            (_grainIndex + 1) mod _grainCount;
                    };

                    private _pitch =
                        0.985 + random 0.030;

                    private _baseVolume =
                        4.2 + random 0.6;

                    [
                        _vehicle,
                        _farPaths select _grainIndex,
                        _emissionPositionASL,
                        _arrivalTime,
                        _baseVolume * _farBodyGain,
                        _pitch,
                        50000
                    ]
                    call big_gau8_fnc_queueSoundArrival;

                    [
                        _vehicle,
                        _closeBodyPaths select _grainIndex,
                        _emissionPositionASL,
                        _arrivalTime,
                        _baseVolume * _closeBodyGain,
                        _pitch,
                        50000
                    ]
                    call big_gau8_fnc_queueSoundArrival;

                    if (_grainIndex < (count _closeMechanicalPaths)) then
                    {
                        [
                            _vehicle,
                            _closeMechanicalPaths select _grainIndex,
                            _emissionPositionASL,
                            _arrivalTime,
                            _baseVolume * _mechanicalGain,
                            _pitch,
                            500
                        ]
                        call big_gau8_fnc_queueSoundArrival;
                    };

                    private _nextGap =
                        7 + floor (random 7);

                    _vehicle setVariable
                    [
                        "big_gau8_nextGrainShot",
                        _shotCount + _nextGap
                    ];

                    _vehicle setVariable
                    [
                        "big_gau8_lastGrainIndex",
                        _grainIndex
                    ];
                };
            };

            _vehicle setVariable
            [
                "big_gau8_shotCount",
                _shotCount + 1
            ];

            private _running =
                _vehicle getVariable
                [
                    "big_gau8_monitorRunning",
                    false
                ];

            if (!_running) then
            {
                _vehicle setVariable
                [
                    "big_gau8_monitorRunning",
                    true
                ];

                private _generation =
                    _vehicle getVariable
                    [
                        "big_gau8_handlerGeneration",
                        0
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

                    private _finished = false;

                    while {!_finished} do
                    {
                        sleep 0.02;

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
                                private _lastShot =
                                    _vehicle getVariable
                                    [
                                        "big_gau8_lastShotTime",
                                        -1000
                                    ];

                                if ((time - _lastShot) > 0.08) then
                                {
                                    _finished = true;
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
                            /*
                                Emit the recorded trigger-release phase at
                                the acoustic arrival time of the final shot.
                                Existing sustain grains are allowed to decay;
                                the release layer supplies the real stop
                                character instead of hard-stopping voices.
                            */
                            private _releasePosition =
                                _vehicle getVariable
                                [
                                    "big_gau8_lastEmissionPositionASL",
                                    getPosASL _vehicle
                                ];

                            private _releaseArrival =
                                _vehicle getVariable
                                [
                                    "big_gau8_lastArrivalTime",
                                    time
                                ];

                            private _releaseCloseGain =
                                _vehicle getVariable
                                [
                                    "big_gau8_lastCloseGain",
                                    0
                                ];

                            private _releaseFarGain =
                                _vehicle getVariable
                                [
                                    "big_gau8_lastFarBodyGain",
                                    0
                                ];

                            private _closeEndPath =
                                _vehicle getVariable
                                [
                                    "big_gau8_closeBodyEndPath",
                                    ""
                                ];

                            private _farEndPath =
                                _vehicle getVariable
                                [
                                    "big_gau8_endPath",
                                    ""
                                ];

                            [
                                _vehicle,
                                _farEndPath,
                                _releasePosition,
                                _releaseArrival,
                                4.2 * _releaseFarGain,
                                1.0,
                                50000
                            ]
                            call big_gau8_fnc_queueSoundArrival;

                            [
                                _vehicle,
                                _closeEndPath,
                                _releasePosition,
                                _releaseArrival,
                                4.2 * _releaseCloseGain,
                                1.0,
                                50000
                            ]
                            call big_gau8_fnc_queueSoundArrival;

                            /*
                                Reset only the emission scheduler. Already
                                emitted sounds and queued arrivals continue
                                naturally and are never truncated here.
                            */
                            _vehicle setVariable
                            [
                                "big_gau8_shotCount",
                                0
                            ];

                            _vehicle setVariable
                            [
                                "big_gau8_nextGrainShot",
                                9
                            ];

                            _vehicle setVariable
                            [
                                "big_gau8_lastGrainIndex",
                                -1
                            ];

                            _vehicle setVariable
                            [
                                "big_gau8_monitorRunning",
                                false
                            ];
                        };
                    };
                };
            };
        }
    ];

_aircraft setVariable
[
    "big_gau8_firedHandler",
    _handler
];

_handler
