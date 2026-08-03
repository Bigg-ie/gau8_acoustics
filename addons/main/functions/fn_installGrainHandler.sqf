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
                "_mode"
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

            if (_shotCount == 0) then
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
                        2.4,
                        1.0,
                        3000,
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

            private _nextGrainShot =
                _vehicle getVariable
                [
                    "big_gau8_nextGrainShot",
                    9
                ];

            if (_shotCount >= _nextGrainShot) then
            {
                private _paths =
                    _vehicle getVariable
                    [
                        "big_gau8_grainPaths",
                        []
                    ];

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
                    2.1 +
                    random 0.6;

                private _soundID =
                    playSound3D
                    [
                        _paths select _grainIndex,
                        _vehicle,
                        false,
                        getPosASL _vehicle,
                        _volume,
                        _pitch,
                        3000,
                        0,
                        true
                    ];

                private _ids =
                    _vehicle getVariable
                    [
                        "big_gau8_grainIDs",
                        []
                    ];

                if (_soundID >= 0) then
                {
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
