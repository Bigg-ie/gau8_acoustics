params ["_vehicle"];

if (isNull _vehicle) exitWith { false };

private _shotCount = _vehicle getVariable ["gau_gau8_shotCount", 0];
if (_shotCount <= 0) exitWith { false };

private _now = diag_tickTime;
private _nextGrainTick = _vehicle getVariable ["gau_gau8_nextGrainTick", -1];
private _nextMechanicalGrainTick = _vehicle getVariable ["gau_gau8_nextMechanicalGrainTick", -1];
private _nextCockpitGrainTick = _vehicle getVariable ["gau_gau8_nextCockpitGrainTick", -1];

private _mrDue = (_nextGrainTick >= 0) && {_now >= _nextGrainTick};
private _mechanicalDue = (_nextMechanicalGrainTick >= 0) && {_now >= _nextMechanicalGrainTick};
private _cockpitDue = (_nextCockpitGrainTick >= 0) && {_now >= _nextCockpitGrainTick};

if (!_mrDue && {!_mechanicalDue} && {!_cockpitDue}) exitWith { false };

private _acousticState = [_vehicle, objNull] call gau_gau8_fnc_getAcousticState;
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

_vehicle setVariable ["gau_gau8_lastEmissionPositionASL", +_emissionPositionASL];
_vehicle setVariable ["gau_gau8_lastArrivalTime", _arrivalTime];
_vehicle setVariable ["gau_gau8_lastCloseGain", _closeBodyGain];
_vehicle setVariable ["gau_gau8_lastMidBodyGain", _midBodyGain];
_vehicle setVariable ["gau_gau8_lastFarBodyGain", _farBodyGain];
_vehicle setVariable ["gau_gau8_lastMechanicalGain", _mechanicalGain];
_vehicle setVariable ["gau_gau8_lastCockpitBodyGain", _cockpitBodyGain];
_vehicle setVariable ["gau_gau8_lastCockpitAirframeGain", _cockpitAirframeGain];

if (_mrDue) then
{
    private _gapMin = floor ((_vehicle getVariable ["gau_gau8_sustainGapMinShots", 5]) max 1 min 20);
    private _gapSpread = floor ((_vehicle getVariable ["gau_gau8_sustainGapSpreadShots", 4]) max 1 min 20);
    private _nextGapShots = _gapMin + floor (random _gapSpread);

    _vehicle setVariable ["gau_gau8_nextGrainTick", _now + (_nextGapShots / 65)];

    private _closePaths = _vehicle getVariable ["gau_gau8_mrCloseGrainPaths", []];
    private _midPaths = _vehicle getVariable ["gau_gau8_mrMidGrainPaths", []];
    private _farPaths = _vehicle getVariable ["gau_gau8_mrFarGrainPaths", []];
    private _sourceOffsets = _vehicle getVariable ["gau_gau8_v27_23MRSourceOffsets", []];

    private _grainCount = (count _closePaths) min (count _midPaths) min (count _farPaths);

    if (
        (_grainCount > 0) &&
        {(_closeBodyGain > 0.000001) || (_midBodyGain > 0.000001) || (_farBodyGain > 0.000001)}
    ) then
    {
        private _lastIndex = _vehicle getVariable ["gau_gau8_lastGrainIndex", -1];
        private _grainIndex = floor (random _grainCount);

        if (_grainIndex == _lastIndex) then
        {
            _grainIndex = (_grainIndex + 1) mod _grainCount;
        };

        private _mrMaster =
            (
                _vehicle getVariable
                [
                    "gau_gau8_mrDirectMaster",
                    missionNamespace getVariable ["gau_gau8_mrDirectMasterDefault", 5.0]
                ]
            ) max 0 min 5;

        private _pitchVariation =
            (
                missionNamespace getVariable ["gau_gau8_v27_23MRPitchVariation", 0.0]
            ) max 0 min 0.02;

        private _pitch = 1.0;
        if (_pitchVariation > 0.000001) then
        {
            _pitch = 1.0 - _pitchVariation + random (2 * _pitchVariation);
        };

        private _voices =
        [
            [_closePaths select _grainIndex, _closeBodyGain],
            [_midPaths select _grainIndex, _midBodyGain],
            [_farPaths select _grainIndex, _farBodyGain]
        ];

        {
            _x params ["_path", "_gain"];

            if (_gain > 0.000001) then
            {
                [
                    _vehicle,
                    _path,
                    _emissionPositionASL,
                    _arrivalTime,
                    _mrMaster * _gain,
                    _pitch,
                    50000
                ]
                call gau_gau8_fnc_queueSoundArrival;
            };
        }
        forEach _voices;

        _vehicle setVariable ["gau_gau8_lastGrainIndex", _grainIndex];
        _vehicle setVariable ["gau_gau8_v27_23LastMRGrainTick", _now];
        _vehicle setVariable ["gau_gau8_v27_23LastMRPitch", _pitch];
        _vehicle setVariable
        [
            "gau_gau8_v27_23LastMRSourceOffset",
            _sourceOffsets param [_grainIndex, 0]
        ];
    };
};

if (_cockpitDue) then
{
    private _cockpitIntervalSeconds =
        (_vehicle getVariable ["gau_gau8_cockpitIntervalSeconds", 22 / 65]) max 0.25 min 0.45;

    _vehicle setVariable ["gau_gau8_nextCockpitGrainTick", _now + _cockpitIntervalSeconds];

    private _cockpitBodyPaths = _vehicle getVariable ["gau_gau8_cockpitBodyPaths", []];
    private _cockpitAirframePaths = _vehicle getVariable ["gau_gau8_cockpitAirframePaths", []];
    private _cockpitGrainCount = (count _cockpitBodyPaths) min (count _cockpitAirframePaths);

    if (
        (_cockpitGrainCount > 0) &&
        {(_cockpitBodyGain > 0.000001) || (_cockpitAirframeGain > 0.000001)}
    ) then
    {
        private _lastCockpitIndex = _vehicle getVariable ["gau_gau8_lastCockpitGrainIndex", -1];
        private _cockpitGrainIndex = floor (random _cockpitGrainCount);

        if (_cockpitGrainIndex == _lastCockpitIndex) then
        {
            _cockpitGrainIndex = (_cockpitGrainIndex + 1) mod _cockpitGrainCount;
        };

        private _cockpitPitch = 0.990 + random 0.020;
        private _cockpitBodyVolume = 1.55 + random 0.20;
        private _cockpitAirframeVolume = 1.75 + random 0.25;
        private _playCockpitSound = _vehicle getVariable ["gau_gau8_playCockpitSound", {}];

        [
            _vehicle,
            _cockpitBodyPaths select _cockpitGrainIndex,
            _cockpitBodyVolume * _cockpitBodyGain,
            _cockpitPitch
        ] call _playCockpitSound;

        [
            _vehicle,
            _cockpitAirframePaths select _cockpitGrainIndex,
            _cockpitAirframeVolume * _cockpitAirframeGain,
            _cockpitPitch
        ] call _playCockpitSound;

        _vehicle setVariable ["gau_gau8_lastCockpitGrainIndex", _cockpitGrainIndex];
    };
};

if (_mechanicalDue) then
{
    private _gapMin = floor ((_vehicle getVariable ["gau_gau8_sustainGapMinShots", 5]) max 1 min 20);
    private _gapSpread = floor ((_vehicle getVariable ["gau_gau8_sustainGapSpreadShots", 4]) max 1 min 20);
    private _nextGapShots = _gapMin + floor (random _gapSpread);

    _vehicle setVariable ["gau_gau8_nextMechanicalGrainTick", _now + (_nextGapShots / 65)];

    private _mechanicalPaths = _vehicle getVariable ["gau_gau8_closeMechanicalPaths", []];
    private _mechanicalCount = count _mechanicalPaths;

    if ((_mechanicalCount > 0) && {_mechanicalGain > 0.000001}) then
    {
        private _mechanicalIndex = floor (random _mechanicalCount);
        private _mechanicalPitch = 0.985 + random 0.030;
        private _mechanicalVolume = 3.55 + random 0.18;

        [
            _vehicle,
            _mechanicalPaths select _mechanicalIndex,
            _emissionPositionASL,
            _arrivalTime,
            _mechanicalVolume * _mechanicalGain,
            _mechanicalPitch,
            500
        ]
        call gau_gau8_fnc_queueSoundArrival;
    };
};

true
