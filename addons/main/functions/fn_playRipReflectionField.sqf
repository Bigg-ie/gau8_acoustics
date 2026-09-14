params
[
    "_vehicle",
    "_soundAnchor",
    "_emissionPositionASL",
    "_listenerPositionASL",
    "_directDistance",
    "_reflectionBaseVolume",
    "_eventPitch",
    "_eventMaxDistance",
    "_terrainOcclusion",
    "_objectOcclusion",
    "_combinedOcclusion",
    "_groundReflectionPresence",
    "_groundReflectionPositionASL",
    "_groundReflectionExtraDelay",
    "_generation",
    ["_mode", "emit"]
];

if (
    isNull _vehicle ||
    {(count _emissionPositionASL) != 3} ||
    {(count _listenerPositionASL) != 3} ||
    {
        !(
            _vehicle getVariable
            [
                "gau_gau8_ripReflectionEnabled",
                true
            ]
        )
    }
) exitWith
{
    false
};

private _reflectionLevel =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripReflectionLevel",
            0.085
        ]
    ) max 0 min 0.35;

private _lateLevel =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripReflectionLateLevel",
            0.46
        ]
    ) max 0 min 0.75;

private _probeRadius =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripReflectionRadius",
            95
        ]
    ) max 30 min 180;

private _maxVoices =
    round
    (
        (
            _vehicle getVariable
            [
                "gau_gau8_ripReflectionMaxVoices",
                3
            ]
        ) max 1 min 6
    );

private _diffuseVoices =
    round
    (
        (
            _vehicle getVariable
            [
                "gau_gau8_ripReflectionDiffuseVoices",
                2
            ]
        ) max 1 min 3
    );

private _cacheLifetime =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripReflectionCacheLifetime",
            6.0
        ]
    ) max 1.0 min 12.0;

private _cacheMoveDistance =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripReflectionCacheMoveDistance",
            20
        ]
    ) max 5 min 60;

private _playbackMaxDistance =
    (
        _vehicle getVariable
        [
            "gau_gau8_ripReflectionPlaybackMaxDistance",
            50000
        ]
    ) max 10000 min 50000;

private _speedOfSound =
    (
        _vehicle getVariable
        [
            "gau_gau8_speedOfSound",
            343.0
        ]
    ) max 300 min 360;

private _sampleDistanceGain =
{
    params ["_distance"];

    if (_distance <= 50) exitWith {1.12};
    if (_distance <= 100) exitWith {linearConversion [50,100,_distance,1.12,1.05,true]};
    if (_distance <= 200) exitWith {linearConversion [100,200,_distance,1.05,0.92,true]};
    if (_distance <= 350) exitWith {linearConversion [200,350,_distance,0.92,0.82,true]};
    if (_distance <= 500) exitWith {linearConversion [350,500,_distance,0.82,0.75,true]};
    if (_distance <= 800) exitWith {linearConversion [500,800,_distance,0.75,0.64,true]};
    if (_distance <= 1200) exitWith {linearConversion [800,1200,_distance,0.64,0.56,true]};
    if (_distance <= 1800) exitWith {linearConversion [1200,1800,_distance,0.56,0.47,true]};
    if (_distance <= 2600) exitWith {linearConversion [1800,2600,_distance,0.47,0.39,true]};
    if (_distance <= 3500) exitWith {linearConversion [2600,3500,_distance,0.39,0.32,true]};
    if (_distance <= 4000) exitWith {linearConversion [3500,4000,_distance,0.32,0.29,true]};

    0.29
};

private _sampleDiscreteDistanceScale =
{
    params ["_distance"];

    if (_distance <= 250) exitWith {1.00};
    if (_distance <= 500) exitWith {linearConversion [250,500,_distance,1.00,0.82,true]};
    if (_distance <= 800) exitWith {linearConversion [500,800,_distance,0.82,0.58,true]};
    if (_distance <= 1200) exitWith {linearConversion [800,1200,_distance,0.58,0.38,true]};
    if (_distance <= 1800) exitWith {linearConversion [1200,1800,_distance,0.38,0.22,true]};
    if (_distance <= 2600) exitWith {linearConversion [1800,2600,_distance,0.22,0.12,true]};
    if (_distance <= 4000) exitWith {linearConversion [2600,4000,_distance,0.12,0.055,true]};

    0.055
};

private _sampleDiffuseDistanceScale =
{
    params ["_distance"];

    if (_distance <= 250) exitWith {0.92};
    if (_distance <= 500) exitWith {linearConversion [250,500,_distance,0.92,0.84,true]};
    if (_distance <= 800) exitWith {linearConversion [500,800,_distance,0.84,0.70,true]};
    if (_distance <= 1200) exitWith {linearConversion [800,1200,_distance,0.70,0.58,true]};
    if (_distance <= 1800) exitWith {linearConversion [1200,1800,_distance,0.58,0.43,true]};
    if (_distance <= 2600) exitWith {linearConversion [1800,2600,_distance,0.43,0.31,true]};
    if (_distance <= 4000) exitWith {linearConversion [2600,4000,_distance,0.31,0.20,true]};

    0.20
};

private _listenerObject = cameraOn;
private _listenerIgnore = [objNull, vehicle _listenerObject] select (!isNull _listenerObject);

private _containsAny =
{
    params ["_text", "_terms"];
    (_terms findIf {(_text find _x) >= 0}) >= 0
};

private _classifyMaterial =
{
    params ["_surfaceText", "_hitObject"];

    private _text = toLower _surfaceText;

    if ((_text isEqualTo "") && {!isNull _hitObject}) then
    {
        _text = toLower (typeOf _hitObject);
    };

    private _family = "medium";
    private _hardness = 0.72;

    if ([_text,["metal","steel","concrete","rock","stone","tarmac","asphalt","brick","tile","cliff","road","vr"]] call _containsAny) then
    {
        _family = "hard";
        _hardness = 1.00;
    };

    if ([_text,["wood","timber","plank"]] call _containsAny) then
    {
        _family = "medium";
        _hardness = 0.78;
    };

    if ([_text,["grass","dirt","mud","sand","forest","carpet","straw","soil","field","beach"]] call _containsAny) then
    {
        _family = "soft";
        _hardness = 0.46;
    };

    [_family,_hardness,_text]
};

private _buildField =
{
    private _toSource = _listenerPositionASL vectorFromTo _emissionPositionASL;
    private _forward = [_toSource select 0,_toSource select 1,0];

    if ((vectorMagnitude _forward) < 0.01) then
    {
        _forward = [0,1,0];
    }
    else
    {
        _forward = vectorNormalized _forward;
    };

    private _side = [_forward select 1,-(_forward select 0),0];
    private _rear = _forward vectorMultiply -1;
    private _leftForward = vectorNormalized (_forward vectorAdd _side);
    private _rightForward = vectorNormalized (_forward vectorAdd (_side vectorMultiply -1));
    private _leftRear = vectorNormalized (_rear vectorAdd _side);
    private _rightRear = vectorNormalized (_rear vectorAdd (_side vectorMultiply -1));
    private _rayStart = _listenerPositionASL vectorAdd [0,0,0.10];

    private _rayDefinitions =
    [
        [_side,0.90,0.95,"left"],
        [_side vectorMultiply -1,0.90,0.95,"right"],
        [_leftForward,1.00,0.82,"front-left"],
        [_rightForward,1.00,0.82,"front-right"],
        [_leftRear,0.82,0.90,"rear-left"],
        [_rightRear,0.82,0.90,"rear-right"],
        [_rear,0.72,0.78,"rear"],
        [[0,0,1],0.38,0.72,"up"]
    ];

    private _candidates = [];
    private _geometryHitCount = 0;

    {
        _x params ["_direction","_radiusScale","_rayWeight","_rayLabel"];

        private _rayLength = _probeRadius * _radiusScale;
        private _rayEnd = _rayStart vectorAdd (_direction vectorMultiply _rayLength);
        private _hits = lineIntersectsSurfaces [_rayStart,_rayEnd,_listenerIgnore,_vehicle,true,1,"VIEW","FIRE",true];

        if (_hits isNotEqualTo []) then
        {
            _geometryHitCount = _geometryHitCount + 1;

            private _hit = _hits select 0;
            private _hitPositionASL = _hit param [0,+_rayEnd];
            private _surfaceNormal = _hit param [1,[0,0,1]];
            private _hitObject = _hit param [2,objNull];
            private _parentObject = _hit param [3,objNull];
            private _materialObject = [_parentObject,_hitObject] select (!isNull _hitObject);
            private _surfaceText = _hit param [5,""];
            private _material = [_surfaceText,_materialObject] call _classifyMaterial;
            _material params ["_family","_hardness","_materialLabel"];

            private _listenerLeg = _hitPositionASL vectorDistance _listenerPositionASL;
            private _surfaceToSource = _hitPositionASL vectorFromTo _emissionPositionASL;
            private _surfaceToListener = _hitPositionASL vectorFromTo _listenerPositionASL;
            private _sourceFacing = abs (_surfaceNormal vectorDotProduct _surfaceToSource);
            private _listenerFacing = abs (_surfaceNormal vectorDotProduct _surfaceToListener);
            private _angleScale = sqrt ((_sourceFacing * _listenerFacing) max 0 min 1);
            private _distanceScale = linearConversion [4,_rayLength,_listenerLeg,1.00,0.18,true];
            private _score = (_rayWeight * _hardness * (0.38 + (0.62 * _angleScale)) * _distanceScale) max 0 min 1.20;

            if (_score >= 0.065) then
            {
                _candidates pushBack [_score,+_hitPositionASL,_family,_materialLabel,_rayLabel];
            };
        };
    }
    forEach _rayDefinitions;

    private _terrainDefinitions =
    [
        [_side,0.48,0.31,"terrain-left"],
        [_side vectorMultiply -1,0.56,0.29,"terrain-right"],
        [_leftRear,0.72,0.24,"terrain-rear-left"],
        [_rightRear,0.80,0.22,"terrain-rear-right"]
    ];

    {
        _x params ["_direction","_radiusScale","_terrainWeight","_label"];
        private _radius = _probeRadius * _radiusScale;
        private _xyPosition = _listenerPositionASL vectorAdd (_direction vectorMultiply _radius);
        private _terrainPositionASL =
        [
            _xyPosition select 0,
            _xyPosition select 1,
            (getTerrainHeightASL [_xyPosition select 0,_xyPosition select 1]) + 0.18
        ];
        private _surfaceClass = surfaceType [_terrainPositionASL select 0,_terrainPositionASL select 1,true];
        private _material = [_surfaceClass,objNull] call _classifyMaterial;
        _material params ["_family","_hardness","_materialLabel"];
        private _listenerLeg = _terrainPositionASL vectorDistance _listenerPositionASL;
        private _distanceScale = linearConversion [20,_probeRadius,_listenerLeg,0.90,0.42,true];
        private _score = (_terrainWeight * _hardness * _distanceScale * (1 - (0.40 * _terrainOcclusion))) max 0 min 0.55;

        if (_score >= 0.060) then
        {
            _candidates pushBack [_score,+_terrainPositionASL,_family,_materialLabel,_label];
        };
    }
    forEach _terrainDefinitions;

    if (_groundReflectionPresence > 0.002) then
    {
        private _surfaceClass = surfaceType [_groundReflectionPositionASL select 0,_groundReflectionPositionASL select 1,true];
        private _material = [_surfaceClass,objNull] call _classifyMaterial;
        _material params ["_family","_hardness","_materialLabel"];
        private _groundScore = ((0.22 + (0.58 * (_groundReflectionPresence / 0.18))) * _hardness) max 0.08 min 0.78;
        _candidates pushBack [_groundScore,+_groundReflectionPositionASL,_family,_materialLabel,"ground-specular"];
    };

    if (_candidates isEqualTo []) exitWith
    {
        [_generation,diag_tickTime,+_listenerPositionASL,0.0,0,[]]
    };

    private _hitRatio = _geometryHitCount / ((count _rayDefinitions) max 1);
    private _enclosure = ((0.55 * _hitRatio) + (0.30 * _objectOcclusion) + (0.15 * _combinedOcclusion)) max 0 min 1;
    private _cacheCount = (_maxVoices + 3) min 8;
    private _selected = [];

    for "_pickIndex" from 1 to _cacheCount do
    {
        private _bestIndex = -1;
        private _bestScore = -1;

        {
            private _candidateScore = _x select 0;
            if (_candidateScore > _bestScore) then
            {
                _bestScore = _candidateScore;
                _bestIndex = _forEachIndex;
            };
        }
        forEach _candidates;

        if (_bestIndex < 0) exitWith {};
        _selected pushBack (_candidates deleteAt _bestIndex);
    };

    [_generation,diag_tickTime,+_listenerPositionASL,_enclosure,_geometryHitCount,_selected]
};

private _cache = _vehicle getVariable ["gau_gau8_ripReflectionField",[]];

private _captureField =
{
    _cache = call _buildField;
    _vehicle setVariable ["gau_gau8_ripReflectionField",_cache];
    _vehicle setVariable ["gau_gau8_ripReflectionEmitIndex",0];

    if (_vehicle getVariable ["gau_gau8_debugReverb",false]) then
    {
        private _capturedCandidates = _cache param [5,[]];
        private _message = format ["GAU-8 reflection capture: hits=%1 enclosure=%2 candidates=%3",_cache param [4,0],(_cache param [3,0]) toFixed 2,count _capturedCandidates];
        systemChat _message;
        diag_log _message;
    };
};

if (_mode isEqualTo "capture") exitWith
{
    call _captureField;
    true
};

if (_reflectionBaseVolume <= 0.000001) exitWith {false};

private _cacheValid = false;

if ((count _cache) >= 6) then
{
    if ((_cache param [0,-1]) == _generation) then
    {
        private _cacheAge = diag_tickTime - (_cache param [1,-100]);
        private _cacheListener = _cache param [2,[]];

        if ((count _cacheListener) == 3) then
        {
            if (_cacheAge <= _cacheLifetime) then
            {
                if ((_cacheListener vectorDistance _listenerPositionASL) <= _cacheMoveDistance) then
                {
                    _cacheValid = true;
                };
            };
        };
    };
};

if (!_cacheValid) then
{
    call _captureField;
    _cache = _vehicle getVariable ["gau_gau8_ripReflectionField",[]];
};

if ((count _cache) < 6) exitWith {false};
private _candidates = _cache param [5,[]];
if (_candidates isEqualTo []) exitWith {false};

private _enclosure = (_cache param [3,0.0]) max 0 min 1;
private _emitIndex = (_vehicle getVariable ["gau_gau8_ripReflectionEmitIndex",0]) + 1;
_vehicle setVariable ["gau_gau8_ripReflectionEmitIndex",_emitIndex];

private _occlusionReflectionScale = linearConversion [0,1,_combinedOcclusion,1.00,1.20,true];
private _fieldVolume = _reflectionBaseVolume * _occlusionReflectionScale;
private _isInside = _enclosure > 0.48;
private _directCurveGain = [_directDistance] call _sampleDistanceGain;
private _discreteDistanceScale = [_directDistance] call _sampleDiscreteDistanceScale;
private _diffuseDistanceScale = [_directDistance] call _sampleDiffuseDistanceScale;

private _playDelayedPacket =
{
    params ["_path","_positionASL","_volume","_predelay"];

    if (_volume <= 0.000001) exitWith {};

    [_vehicle,_soundAnchor,_path,+_positionASL,_volume,_eventPitch,_playbackMaxDistance,_predelay,_isInside,_generation]
    spawn
    {
        params ["_vehicle","_soundAnchor","_path","_positionASL","_volume","_pitch","_maxDistance","_predelay","_isInside","_generation"];
        uiSleep _predelay;

        if (isNull _vehicle) exitWith {};
        if ((_vehicle getVariable ["gau_gau8_handlerGeneration",-1]) != _generation) exitWith {};

        private _soundID = playSound3D [_path,_soundAnchor,_isInside,_positionASL,_volume,_pitch,_maxDistance,0,true];

        if (_soundID >= 0) then
        {
            private _ids = _vehicle getVariable ["gau_gau8_reverbIDs",[]];
            _ids pushBack _soundID;
            while {(count _ids) > 48} do {_ids deleteAt 0;};
            _vehicle setVariable ["gau_gau8_reverbIDs",_ids];
        };
    };
};

private _pathData =
{
    params ["_positionASL"];

    private _listenerLeg = _positionASL vectorDistance _listenerPositionASL;
    private _sourceLeg = _positionASL vectorDistance _emissionPositionASL;
    private _reflectedPath = _sourceLeg + _listenerLeg;
    private _extraPath = (_reflectedPath - _directDistance) max 0;
    private _predelay = (_extraPath / _speedOfSound) max 0.010 min 0.600;
    private _reflectedCurveGain = [_reflectedPath] call _sampleDistanceGain;
    private _fullPathScale = (_reflectedCurveGain / (_directCurveGain max 0.01)) max 0.10 min 1.00;

    [_reflectedPath,_predelay,_fullPathScale]
};

private _debugPaths = [];

if (_emitIndex == 1) then
{
    private _voiceCount = _maxVoices min (count _candidates);

    for "_voiceIndex" from 0 to (_voiceCount - 1) do
    {
        private _candidate = _candidates select _voiceIndex;
        _candidate params ["_score","_positionASL","_family","_materialLabel","_label"];
        private _pd = [_positionASL] call _pathData;
        _pd params ["_reflectedPath","_predelay","_fullPathScale"];
        private _variant = 1 + (_voiceIndex mod 2);
        private _path = format ["z\gau\addons\main\sounds\rip\environment\rip_reflection_%1_%2.wav",_family,_variant];
        private _voiceVolume = (_fieldVolume * _reflectionLevel * _score * _fullPathScale * _discreteDistanceScale) min 4.0;
        [_path,_positionASL,_voiceVolume,_predelay] call _playDelayedPacket;
        _debugPaths pushBack format ["early:%1/%2m/%3ms/x%4",_label,round _reflectedPath,round(_predelay*1000),_fullPathScale toFixed 2];
    };
};

if (_lateLevel > 0.000001) then
{
    private _diffuseSelected = [];
    _diffuseSelected pushBack (_candidates select 0);

    if ((_diffuseVoices > 1) && {(count _candidates) > 1}) then
    {
        private _firstPosition = (_candidates select 0) select 1;
        private _bestIndex = 1;
        private _bestSpread = -1;

        for "_candidateIndex" from 1 to ((count _candidates) - 1) do
        {
            private _candidate = _candidates select _candidateIndex;
            private _spread = ((_candidate select 1) vectorDistance _firstPosition) * (0.50 + (_candidate select 0));
            if (_spread > _bestSpread) then
            {
                _bestSpread = _spread;
                _bestIndex = _candidateIndex;
            };
        };

        _diffuseSelected pushBack (_candidates select _bestIndex);
    };

    if ((_diffuseVoices > 2) && {(count _candidates) > 2}) then
    {
        private _index = 1 + ((_emitIndex + 1) mod ((count _candidates) - 1));
        private _third = _candidates select _index;
        if (!(_third in _diffuseSelected)) then {_diffuseSelected pushBack _third;};
    };

    private _actualDiffuseVoices = count _diffuseSelected;
    private _voicePowerScale = 1 / sqrt (_actualDiffuseVoices max 1);
    private _lateEnvironmentScale = (0.48 + (0.72 * _enclosure)) max 0.45 min 1.18;

    {
        _x params ["_score","_positionASL","_family","_materialLabel","_label"];
        private _pd = [_positionASL] call _pathData;
        _pd params ["_reflectedPath","_predelay","_fullPathScale"];
        private _latePredelay = (_predelay + 0.018 + (0.025 * _enclosure)) min 0.620;
        private _variant = 1 + ((_emitIndex + _forEachIndex) mod 3);
        private _latePath = format ["z\gau\addons\main\sounds\rip\environment\rip_reflection_diffuse_%1.wav",_variant];
        private _scoreScale = (0.68 + (0.32 * _score)) max 0.68 min 1.00;
        private _lateVolume = (_fieldVolume * _reflectionLevel * _lateLevel * _lateEnvironmentScale * _diffuseDistanceScale * _fullPathScale * _scoreScale * _voicePowerScale) min 2.5;
        [_latePath,_positionASL,_lateVolume,_latePredelay] call _playDelayedPacket;
        _debugPaths pushBack format ["diff:%1/%2m/%3ms/x%4",_label,round _reflectedPath,round(_latePredelay*1000),_fullPathScale toFixed 2];
    }
    forEach _diffuseSelected;
};

if (_vehicle getVariable ["gau_gau8_debugReverb",false]) then
{
    private _message = format ["GAU-8 reflection emit=%1 direct=%2m earlyScale=%3 diffuseScale=%4 [%5]",_emitIndex,round _directDistance,_discreteDistanceScale toFixed 3,_diffuseDistanceScale toFixed 3,_debugPaths joinString ", "];
    systemChat _message;
    diag_log _message;
};

true
