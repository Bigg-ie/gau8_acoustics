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

/*
    Cockpit audio is listener-relative rather than world-positioned. Raw
    playSound3D events remain fixed at their creation position, which is
    correct for external reports but incorrect for a moving cockpit. The UI
    command is routed through the effects channel and returns a stopSound ID.
*/
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
    "gau_gau8_lastGrainIndex",
    -1
];

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
            /* V11.0 compatibility weapon registry */
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
                /*
                    Schedule sustain by elapsed real time. Firewill reports
                    grouped firing events roughly every 75-101 ms, so event
                    counts cannot be treated as individual 3,900 RPM rounds.
                */
                _vehicle setVariable
                [
                    "gau_gau8_nextGrainTick",
                    _shotTick + (9 / 65)
                ];

                /*
                    The first cockpit sustain event is scheduled early enough
                    to absorb Firewill callback quantization while retaining
                    overlap with the 0.36-second cockpit start recordings.
                */
                _vehicle setVariable
                [
                    "gau_gau8_nextCockpitGrainTick",
                    _shotTick + 0.24
                ];
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

            /*
                Preserve the final emission state so the release recording
                can arrive from the last-shot position at the correct time.
            */
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
            /*
                Environment diagnostics are emitted by the arrival worker,
                after listener position and obstruction are resampled.
            */
/*
                Retain one Mach-cone geometry solution at the beginning of
                each firing run for diagnostics only. Arma's ammunition
                system owns the accepted supersonic-crack playback.
            */
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
                private _farStartPath =
                    _vehicle getVariable
                    [
                        "gau_gau8_startPath",
                        ""
                    ];

                private _closeStartPath =
                    _vehicle getVariable
                    [
                        "gau_gau8_closeBodyStartPath",
                        ""
                    ];

                private _midStartPath =
                    _vehicle getVariable
                    [
                        "gau_gau8_midBodyStartPath",
                        ""
                    ];

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

                [
                    _vehicle,
                    _farStartPath,
                    _emissionPositionASL,
                    _arrivalTime,
                    4.8 * _farBodyGain,
                    1.0,
                    50000
                ]
                call gau_gau8_fnc_queueSoundArrival;

                [
                    _vehicle,
                    _closeStartPath,
                    _emissionPositionASL,
                    _arrivalTime,
                    4.8 * _closeBodyGain,
                    1.0,
                    50000
                ]
                call gau_gau8_fnc_queueSoundArrival;

                [
                    _vehicle,
                    _midStartPath,
                    _emissionPositionASL,
                    _arrivalTime,
                    4.8 * _midBodyGain,
                    1.0,
                    50000
                ]
                call gau_gau8_fnc_queueSoundArrival;

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
                _vehicle getVariable
                [
                    "gau_gau8_monitorRunning",
                    false
                ];

            if (!_running) then
            {
                _vehicle setVariable
                [
                    "gau_gau8_monitorRunning",
                    true
                ];

                private _generation =
                    _vehicle getVariable
                    [
                        "gau_gau8_handlerGeneration",
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
                        uiSleep 0.01;

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
                                private _emitSustain =
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_emitSustain",
                                        {}
                                    ];

                                /*
                                    Service sustain before evaluating release.
                                    This allows the final due grain to overlap
                                    the end stage during the debounce interval.
                                */
                                [_vehicle] call _emitSustain;

                                private _lastShotTick =
                                    _vehicle getVariable
                                    [
                                        "gau_gau8_lastShotTick",
                                        -1000
                                    ];

                                private _burstTimeout =
                                    (
                                        _vehicle getVariable
                                        [
                                            "gau_gau8_burstTimeout",
                                            0.18
                                        ]
                                    )
                                    max 0.14
                                    min 0.35;

                                if (
                                    (diag_tickTime - _lastShotTick) >
                                    _burstTimeout
                                ) then
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
                                "gau_gau8_handlerGeneration",
                                -1
                            ];

                        if (_currentGeneration == _generation) then
                        {
                            /*
                                Emit the recorded trigger-release phase from
                                the final sustain state. Existing sustain
                                grains are allowed to decay;
                                the release layer supplies the real stop
                                character instead of hard-stopping voices.
                            */
                            private _releasePosition =
                                _vehicle getVariable
                                [
                                    "gau_gau8_lastEmissionPositionASL",
                                    getPosASL _vehicle
                                ];

                            private _releaseArrival =
                                _vehicle getVariable
                                [
                                    "gau_gau8_lastArrivalTime",
                                    time
                                ];

                            private _releaseCloseGain =
                                _vehicle getVariable
                                [
                                    "gau_gau8_lastCloseGain",
                                    0
                                ];

                            private _releaseMidGain =
                                _vehicle getVariable
                                [
                                    "gau_gau8_lastMidBodyGain",
                                    0
                                ];

                            private _releaseFarGain =
                                _vehicle getVariable
                                [
                                    "gau_gau8_lastFarBodyGain",
                                    0
                                ];

                            private _releaseCockpitBodyGain =
                                _vehicle getVariable
                                [
                                    "gau_gau8_lastCockpitBodyGain",
                                    0
                                ];

                            private _releaseCockpitAirframeGain =
                                _vehicle getVariable
                                [
                                    "gau_gau8_lastCockpitAirframeGain",
                                    0
                                ];

                            private _releaseReflectionGain =
                                _vehicle getVariable
                                [
                                    "gau_gau8_lastReflectionGain",
                                    0
                                ];

                            private _releaseReflectionPosition =
                                _vehicle getVariable
                                [
                                    "gau_gau8_lastReflectionPositionASL",
                                    +_releasePosition
                                ];

                            private _releaseReflectionArrival =
                                _vehicle getVariable
                                [
                                    "gau_gau8_lastReflectionArrivalTime",
                                    _releaseArrival
                                ];

                            private _closeEndPath =
                                _vehicle getVariable
                                [
                                    "gau_gau8_closeBodyEndPath",
                                    ""
                                ];

                            private _midEndPath =
                                _vehicle getVariable
                                [
                                    "gau_gau8_midBodyEndPath",
                                    ""
                                ];

                            private _farEndPath =
                                _vehicle getVariable
                                [
                                    "gau_gau8_endPath",
                                    ""
                                ];

                            private _cockpitBodyEndPath =
                                _vehicle getVariable
                                [
                                    "gau_gau8_cockpitBodyEndPath",
                                    ""
                                ];

                            private _cockpitAirframeEndPath =
                                _vehicle getVariable
                                [
                                    "gau_gau8_cockpitAirframeEndPath",
                                    ""
                                ];
private _playCockpitSound =
                                _vehicle getVariable
                                [
                                    "gau_gau8_playCockpitSound",
                                    {}
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
                            call gau_gau8_fnc_queueSoundArrival;

                            [
                                _vehicle,
                                _closeEndPath,
                                _releasePosition,
                                _releaseArrival,
                                4.2 * _releaseCloseGain,
                                1.0,
                                50000
                            ]
                            call gau_gau8_fnc_queueSoundArrival;

                            [
                                _vehicle,
                                _midEndPath,
                                _releasePosition,
                                _releaseArrival,
                                4.2 * _releaseMidGain,
                                1.0,
                                50000
                            ]
                            call gau_gau8_fnc_queueSoundArrival;
[
                                _vehicle,
                                _cockpitBodyEndPath,
                                1.55 * _releaseCockpitBodyGain,
                                1.0
                            ]
                            call _playCockpitSound;

                            [
                                _vehicle,
                                _cockpitAirframeEndPath,
                                1.70 * _releaseCockpitAirframeGain,
                                1.0
                            ]
                            call _playCockpitSound;

                            /*
                                Reset only the emission scheduler. Already
                                emitted sounds and queued arrivals continue
                                naturally and are never truncated here.
                            */
                            _vehicle setVariable
                            [
                                "gau_gau8_shotCount",
                                0
                            ];

                            _vehicle setVariable
                            [
                                "gau_gau8_nextGrainTick",
                                -1
                            ];

                            _vehicle setVariable
                            [
                                "gau_gau8_nextCockpitGrainTick",
                                -1
                            ];

                            _vehicle setVariable
                            [
                                "gau_gau8_lastCockpitGrainIndex",
                                -1
                            ];
_vehicle setVariable
                            [
                                "gau_gau8_lastGrainIndex",
                                -1
                            ];

                            _vehicle setVariable
                            [
                                "gau_gau8_monitorRunning",
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
    "gau_gau8_firedHandler",
    _handler
];

_handler
