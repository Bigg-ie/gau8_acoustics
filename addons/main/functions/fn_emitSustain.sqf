/*
    Emits one due sustain step for an active GAU-8 burst.

    The burst worker calls this independently of weapon Fired callbacks.
    This keeps external and cockpit grains running through sparse Firewill
    callbacks and across the release-debounce interval.
*/
params ["_vehicle"];

if (isNull _vehicle) exitWith
{
    false
};

private _shotCount =
    _vehicle getVariable
    [
        "gau_gau8_shotCount",
        0
    ];

if (_shotCount <= 0) exitWith
{
    false
};

private _now = diag_tickTime;

private _nextGrainTick =
    _vehicle getVariable
    [
        "gau_gau8_nextGrainTick",
        -1
    ];

private _nextCockpitGrainTick =
    _vehicle getVariable
    [
        "gau_gau8_nextCockpitGrainTick",
        -1
    ];

private _externalDue =
    (_nextGrainTick >= 0) &&
    {_now >= _nextGrainTick};

private _cockpitDue =
    (_nextCockpitGrainTick >= 0) &&
    {_now >= _nextCockpitGrainTick};

if (!_externalDue && {!_cockpitDue}) exitWith
{
    false
};

private _acousticState =
    [
        _vehicle,
        objNull
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

private _arrivalTime =
    time + _propagationDelay;

private _reflectionArrivalTime =
    time + _reflectionPropagationDelay;

/*
    Keep the release stage attached to the most recently emitted sustain
    state rather than the last sparse Firewill projectile callback.
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

/*
    Cockpit sustain.
*/
if (_cockpitDue) then
{
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

    /*
        Advance from the actual emission tick rather than the previous
        deadline. This prevents catch-up stacking after a frame stall.
    */
    _vehicle setVariable
    [
        "gau_gau8_nextCockpitGrainTick",
        _now + _cockpitIntervalSeconds
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

    private _cockpitGrainCount =
        (count _cockpitBodyPaths)
        min
        (count _cockpitAirframePaths);

    if (
        (_cockpitGrainCount > 0) &&
        {
            (_cockpitBodyGain > 0.000001) ||
            (_cockpitAirframeGain > 0.000001)
        }
    ) then
    {
        private _lastCockpitIndex =
            _vehicle getVariable
            [
                "gau_gau8_lastCockpitGrainIndex",
                -1
            ];

        private _cockpitGrainIndex =
            floor
            (
                random _cockpitGrainCount
            );

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

        private _playCockpitSound =
            _vehicle getVariable
            [
                "gau_gau8_playCockpitSound",
                {}
            ];

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

        _vehicle setVariable
        [
            "gau_gau8_lastCockpitGrainIndex",
            _cockpitGrainIndex
        ];
    };
};

/*
    External sustain.
*/
if (_externalDue) then
{
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

    private _nextGapShots =
        _sustainGapMinShots +
        floor
        (
            random _sustainGapSpreadShots
        );

    private _nextGapSeconds =
        _nextGapShots / 65;

    _vehicle setVariable
    [
        "gau_gau8_nextGrainTick",
        _now + _nextGapSeconds
    ];

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

    private _grainCount =
        ((count _farPaths) min (count _closeBodyPaths))
        min
        (count _midBodyPaths);

    if (
        (_grainCount > 0) &&
        {
            (_farBodyGain > 0.000001) ||
            (_midBodyGain > 0.000001) ||
            (_closeBodyGain > 0.000001) ||
            (_mechanicalGain > 0.000001)
        }
    ) then
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
                (_grainIndex + 1)
                mod
                _grainCount;
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
            Preserve the existing synchronized ground-response layer.
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

        _vehicle setVariable
        [
            "gau_gau8_lastGrainIndex",
            _grainIndex
        ];
    };
};

true
