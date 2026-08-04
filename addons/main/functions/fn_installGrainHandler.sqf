params ["_aircraft"];

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
    "big_gau8_grainIDs",
    []
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
                diag_tickTime
            ];

            private _shotCount =
                _vehicle getVariable
                [
                    "big_gau8_shotCount",
                    0
                ];

            private _listener = cameraOn;

            if (isNull _listener) then
            {
                _listener = player;
            };

            private _listenerPosition =
                positionCameraToWorld [0, 0, 0];

            private _sourcePosition =
                ASLToAGL
                (
                    getPosASL _vehicle
                );

            private _listenerDistance =
                _listenerPosition vectorDistance _sourcePosition;

            private _farBodyGain =
                if (_listenerDistance <= 150) then
                {
                    0
                }
                else
                {
                    if (_listenerDistance < 200) then
                    {
                        linearConversion
                        [
                            150,
                            200,
                            _listenerDistance,
                            0,
                            1,
                            true
                        ]
                    }
                    else
                    {
                        if (_listenerDistance <= 500) then
                        {
                            1
                        }
                        else
                        {
                            if (_listenerDistance < 1000) then
                            {
                                linearConversion
                                [
                                    500,
                                    1000,
                                    _listenerDistance,
                                    1.0000,
                                    0.5012,
                                    true
                                ]
                            }
                            else
                            {
                                if (_listenerDistance < 2000) then
                                {
                                    linearConversion
                                    [
                                        1000,
                                        2000,
                                        _listenerDistance,
                                        0.5012,
                                        0.2512,
                                        true
                                    ]
                                }
                                else
                                {
                                    if (_listenerDistance < 5000) then
                                    {
                                        linearConversion
                                        [
                                            2000,
                                            5000,
                                            _listenerDistance,
                                            0.2512,
                                            0.0891,
                                            true
                                        ]
                                    }
                                    else
                                    {
                                        if (_listenerDistance < 10000) then
                                        {
                                            linearConversion
                                            [
                                                5000,
                                                10000,
                                                _listenerDistance,
                                                0.0891,
                                                0.0447,
                                                true
                                            ]
                                        }
                                        else
                                        {
                                            if (_listenerDistance < 20000) then
                                            {
                                                linearConversion
                                                [
                                                    10000,
                                                    20000,
                                                    _listenerDistance,
                                                    0.0447,
                                                    0.0224,
                                                    true
                                                ]
                                            }
                                            else
                                            {
                                                if (_listenerDistance < 30000) then
                                                {
                                                    linearConversion
                                                    [
                                                        20000,
                                                        30000,
                                                        _listenerDistance,
                                                        0.0224,
                                                        0.0141,
                                                        true
                                                    ]
                                                }
                                                else
                                                {
                                                    if (_listenerDistance < 50000) then
                                                    {
                                                        linearConversion
                                                        [
                                                            30000,
                                                            50000,
                                                            _listenerDistance,
                                                            0.0141,
                                                            0.0079,
                                                            true
                                                        ]
                                                    }
                                                    else
                                                    {
                                                        0
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                };
            _vehicle setVariable
            [
                "big_gau8_lastListenerDistance",
                _listenerDistance
            ];

            _vehicle setVariable
            [
                "big_gau8_lastFarBodyGain",
                _farBodyGain
            ];

            /*
                Capture one geometry solution at the beginning
                of each continuous firing run.
            */
            if (
                _shotCount == 0 &&
                {!isNull _projectile}
            ) then
            {
                if (!isNull _listener) then
                {
                    private _shockGeometry =
                        [
                            getPosASL _projectile,
                            velocity _projectile,
                            getPosASL _listener,
                            343.0
                        ]
                        call
                        big_gau8_fnc_calculateShockGeometry;

                    _vehicle setVariable
                    [
                        "big_gau8_lastShockGeometry",
                        _shockGeometry
                    ];

                    if (
                        (count _shockGeometry) == 10
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
            };

            if (
                _shotCount == 0 &&
                {_farBodyGain > 0.001}
            ) then
            {
                private _startPath =
                    _vehicle getVariable
                    [
                        "big_gau8_startPath",
                        ""
                    ];

                private _startID =
                    playSound3D
                    [
                        _startPath,
                        _vehicle,
                        false,
                        getPosASL _vehicle,
                        4.8 * _farBodyGain,
                        1.0,
                        50000,
                        0,
                        true
                    ];

                if (_startID >= 0) then
                {
                    private _ids =
                        _vehicle getVariable
                        [
                            "big_gau8_grainIDs",
                            []
                        ];

                    _ids pushBack _startID;

                    _vehicle setVariable
                    [
                        "big_gau8_grainIDs",
                        _ids
                    ];
                };
            };

            private _paths =
                _vehicle getVariable
                [
                    "big_gau8_grainPaths",
                    []
                ];

            if (
                _farBodyGain > 0.001 &&
                {(count _paths) > 0}
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
                            random
                            (
                                count _paths
                            )
                        );

                    if (_grainIndex == _lastIndex) then
                    {
                        _grainIndex =
                            (
                                _grainIndex + 1
                            )
                            mod
                            (
                                count _paths
                            );
                    };

                    private _pitch =
                        0.985 +
                        random 0.030;

                    private _volume =
                        (
                            4.2 +
                            random 0.6
                        )
                        *
                        _farBodyGain;

                    private _soundID =
                        playSound3D
                        [
                            _paths select _grainIndex,
                            _vehicle,
                            false,
                            getPosASL _vehicle,
                            _volume,
                            _pitch,
                            50000,
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

                        if ((count _ids) > 12) then
                        {
                            _ids deleteAt 0;
                        };

                        _vehicle setVariable
                        [
                            "big_gau8_grainIDs",
                            _ids
                        ];
                    };

                    private _nextGap =
                        7 +
                        floor
                        (
                            random 7
                        );

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
                        uiSleep 0.02;

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

                            if (
                                _currentGeneration !=
                                _generation
                            ) then
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

                                private _elapsed =
                                    diag_tickTime -
                                    _lastShot;

                                if (_elapsed > 0.08) then
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

                        if (
                            _currentGeneration ==
                            _generation
                        ) then
                        {
                            private _ids =
                                _vehicle getVariable
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
                            forEach _ids;

                            _vehicle setVariable
                            [
                                "big_gau8_grainIDs",
                                []
                            ];

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
