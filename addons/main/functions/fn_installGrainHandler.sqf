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

            private _farPaths =
                _vehicle getVariable
                [
                    "gau_gau8_grainPaths",
                    []
                ];

            private _closeBodyPaths =
                _vehicle getVariable
                [
                    "gau_gau8_closeBodyPaths",
                    []
                ];

            private _midBodyPaths =
                _vehicle getVariable
                [
                    "gau_gau8_midBodyPaths",
                    []
                ];

            private _closeMechanicalPaths =
                _vehicle getVariable
                [
                    "gau_gau8_closeMechanicalPaths",
                    []
                ];

            private _cockpitBodyPaths =
                _vehicle getVariable
                [
                    "gau_gau8_cockpitBodyPaths",
                    []
                ];

            private _cockpitAirframePaths =
                _vehicle getVariable
                [
                    "gau_gau8_cockpitAirframePaths",
                    []
                ];
private _playCockpitSound =
                _vehicle getVariable
                [
                    "gau_gau8_playCockpitSound",
                    {}
                ];

            /*
                Cockpit sustain uses a real-time cadence rather than reported
                projectile-event count. Firewill emits grouped Fired events
                roughly every 75-101 ms, so counting those callbacks produces
                multi-second gaps.

                The first pair is targeted at 0.24 seconds. Later pairs retain
                the nominal 22-round interval at 3,900 RPM, approximately
                0.338 seconds. The time gate is serviced by accepted Fired
                events, but callback density no longer determines the cadence.
            */
            private _cockpitGrainCount =
                (count _cockpitBodyPaths)
                min
                (count _cockpitAirframePaths);

            if (
                (_cockpitGrainCount > 0) &&
                (
                    (_cockpitBodyGain > 0.000001) ||
                    (_cockpitAirframeGain > 0.000001)
                )
            ) then
            {
                private _nextCockpitGrainTick =
                    _vehicle getVariable
                    [
                        "gau_gau8_nextCockpitGrainTick",
                        _shotTick + 0.24
                    ];

                if (_shotTick >= _nextCockpitGrainTick) then
                {
                    private _lastCockpitIndex =
                        _vehicle getVariable
                        [
                            "gau_gau8_lastCockpitGrainIndex",
                            -1
                        ];

                    private _cockpitGrainIndex =
                        floor (random _cockpitGrainCount);

                    if (_cockpitGrainIndex == _lastCockpitIndex) then
                    {
                        _cockpitGrainIndex =
                            (_cockpitGrainIndex + 1)
                            mod
                            _cockpitGrainCount;
                    };

                    private _cockpitPitch =
                        0.990 + random 0.020;

                    private _cockpitBodyVolume =
                        1.55 + random 0.20;

                    private _cockpitAirframeVolume =
                        1.75 + random 0.25;

                    [
                        _vehicle,
                        _cockpitBodyPaths select _cockpitGrainIndex,
                        _cockpitBodyVolume * _cockpitBodyGain,
                        _cockpitPitch
                    ]
                    call _playCockpitSound;

                    [
                        _vehicle,
                        _cockpitAirframePaths select _cockpitGrainIndex,
                        _cockpitAirframeVolume * _cockpitAirframeGain,
                        _cockpitPitch
                    ]
                    call _playCockpitSound;

                    private _cockpitIntervalSeconds =
                        (
                            _vehicle getVariable
                            [
                                "gau_gau8_cockpitIntervalSeconds",
                                22 / 65
                            ]
                        )
                        max 0.25
                        min 0.45;

                    _vehicle setVariable
                    [
                        "gau_gau8_nextCockpitGrainTick",
                        _nextCockpitGrainTick +
                        _cockpitIntervalSeconds
                    ];

                    _vehicle setVariable
                    [
                        "gau_gau8_lastCockpitGrainIndex",
                        _cockpitGrainIndex
                    ];
                };
            };

            private _grainCount =
                ((count _farPaths) min (count _closeBodyPaths))
                min
                (count _midBodyPaths);

            if (
                (_grainCount > 0) &&
                (
                    (_farBodyGain > 0.000001) ||
                    (_midBodyGain > 0.000001) ||
                    (_closeBodyGain > 0.000001) ||
                    (_mechanicalGain > 0.000001)
                )
            ) then
            {
                private _nextGrainTick =
                    _vehicle getVariable
                    [
                        "gau_gau8_nextGrainTick",
                        _shotTick + (9 / 65)
                    ];

                if (_shotTick >= _nextGrainTick) then
                {
                    private _lastIndex =
                        _vehicle getVariable
                        [
                            "gau_gau8_lastGrainIndex",
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

                    private _sustainBaseVolume =
                        (
                            _vehicle getVariable
                            [
                                "gau_gau8_sustainBaseVolume",
                                3.55
                            ]
                        )
                        max 0
                        min 12;

                    private _sustainVolumeVariation =
                        (
                            _vehicle getVariable
                            [
                                "gau_gau8_sustainVolumeVariation",
                                0.18
                            ]
                        )
                        max 0
                        min 2;

                    /*
                        V10.1 sustain-density smoothing.

                        The scheduler runs more frequently and compensates
                        per-grain gain to preserve approximately the same
                        aggregate sustain level.
                    */
                    private _baseVolume =
                        _sustainBaseVolume +
                        (random _sustainVolumeVariation);

                    [
                        _vehicle,
                        _farPaths select _grainIndex,
                        _emissionPositionASL,
                        _arrivalTime,
                        _baseVolume * _farBodyGain,
                        _pitch,
                        50000
                    ]
                    call gau_gau8_fnc_queueSoundArrival;

                    [
                        _vehicle,
                        _closeBodyPaths select _grainIndex,
                        _emissionPositionASL,
                        _arrivalTime,
                        _baseVolume * _closeBodyGain,
                        _pitch,
                        50000
                    ]
                    call gau_gau8_fnc_queueSoundArrival;

                    [
                        _vehicle,
                        _midBodyPaths select _grainIndex,
                        _emissionPositionASL,
                        _arrivalTime,
                        _baseVolume * _midBodyGain,
                        _pitch,
                        50000
                    ]
                    call gau_gau8_fnc_queueSoundArrival;

                    /*
                        Ground response is synchronized to the direct body
                        grain. It uses the same index and pitch, with only the
                        geometric reflected-path delay added by the arrival
                        queue. This prevents the reflection from becoming an
                        independent second cannon report.

                        Reflection spectrum follows the active distance mix:
                        close energy is shifted into the mid recording, mid
                        energy is split between mid and far, and far energy
                        remains in the far recording. No close-derived
                        reflection asset is used at mid or far distance.
                    */
                    if (_reflectionGain > 0.000001) then
                    {
                        private _reflectionMidNumerator =
                            (0.85 * _closeBodyGain) +
                            (0.75 * _midBodyGain);

                        private _reflectionFarNumerator =
                            (0.25 * _midBodyGain) +
                            _farBodyGain;

                        private _reflectionSpectralTotal =
                            _reflectionMidNumerator +
                            _reflectionFarNumerator;

                        if (_reflectionSpectralTotal > 0.000001) then
                        {
                            private _reflectionMidGain =
                                _reflectionGain *
                                (
                                    _reflectionMidNumerator /
                                    _reflectionSpectralTotal
                                );

                            private _reflectionFarGain =
                                _reflectionGain *
                                (
                                    _reflectionFarNumerator /
                                    _reflectionSpectralTotal
                                );

                            [
                                _vehicle,
                                _midBodyPaths select _grainIndex,
                                _reflectionPositionASL,
                                _reflectionArrivalTime,
                                _baseVolume * _reflectionMidGain,
                                _pitch,
                                50000
                            ]
                            call gau_gau8_fnc_queueSoundArrival;

                            [
                                _vehicle,
                                _farPaths select _grainIndex,
                                _reflectionPositionASL,
                                _reflectionArrivalTime,
                                _baseVolume * _reflectionFarGain,
                                _pitch,
                                50000
                            ]
                            call gau_gau8_fnc_queueSoundArrival;
                        };
                    };

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
                        call gau_gau8_fnc_queueSoundArrival;
                    };

                    private _sustainGapMinShots =
                        floor
                        (
                            (
                                _vehicle getVariable
                                [
                                    "gau_gau8_sustainGapMinShots",
                                    5
                                ]
                            )
                            max 1
                            min 20
                        );

                    private _sustainGapSpreadShots =
                        floor
                        (
                            (
                                _vehicle getVariable
                                [
                                    "gau_gau8_sustainGapSpreadShots",
                                    4
                                ]
                            )
                            max 1
                            min 20
                        );

                    private _nextGap =
                        _sustainGapMinShots +
                        floor
                        (
                            random _sustainGapSpreadShots
                        );

                    private _nextGapSeconds =
                        _nextGap / 65;

                    _vehicle setVariable
                    [
                        "gau_gau8_nextGrainTick",
                        _nextGrainTick + _nextGapSeconds
                    ];

                    _vehicle setVariable
                    [
                        "gau_gau8_lastGrainIndex",
                        _grainIndex
                    ];
                };
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
                                    "gau_gau8_handlerGeneration",
                                    -1
                                ];

                            if (_currentGeneration != _generation) then
                            {
                                _finished = true;
                            }
                            else
                            {
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
                                Emit the recorded trigger-release phase at
                                the acoustic arrival time of the final shot.
                                Existing sustain grains are allowed to decay;
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
