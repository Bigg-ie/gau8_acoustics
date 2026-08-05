/*
    Estimate external acoustic obstruction and a first-order ground
    reflection for one emitted GAU-8 event.

    Expensive geometry checks are cached and smoothed per aircraft. The
    reflection geometry is inexpensive and is recalculated for each emitted
    event so its arrival position follows the historical source position.

    Return value:
    [
        terrainOcclusion,
        objectOcclusion,
        combinedOcclusion,
        reflectionPresence,
        reflectionPositionASL,
        reflectionPropagationDelaySeconds,
        reflectionExtraDelaySeconds,
        sourceHeightAGL,
        listenerHeightAGL,
        objectHitCount
    ]
*/
params
[
    "_vehicle",
    "_emissionPositionASL",
    "_listenerPositionASL",
    "_distance",
    ["_externalMix", 1.0]
];

if (
    isNull _vehicle ||
    {(count _emissionPositionASL) != 3} ||
    {(count _listenerPositionASL) != 3} ||
    {_externalMix <= 0.000001}
) exitWith
{
    [
        0,
        0,
        0,
        0,
        +_emissionPositionASL,
        _distance / 343.0,
        0,
        0,
        0,
        0
    ]
};

private _sampleCurve =
{
    params
    [
        "_x",
        "_points"
    ];

    private _count = count _points;

    if (_count == 0) exitWith
    {
        0
    };

    private _first = _points select 0;

    if (_x <= (_first select 0)) exitWith
    {
        _first select 1
    };

    private _last = _points select (_count - 1);
    private _value = _last select 1;

    for "_index" from 1 to (_count - 1) do
    {
        private _lower = _points select (_index - 1);
        private _upper = _points select _index;

        if (_x <= (_upper select 0)) exitWith
        {
            _value = linearConversion
            [
                _lower select 0,
                _upper select 0,
                _x,
                _lower select 1,
                _upper select 1,
                true
            ];
        };
    };

    _value
};

private _cache =
    _vehicle getVariable
    [
        "gau_gau8_environmentCache",
        []
    ];

private _nextCheck = _cache param [0, -1000.0];
private _cachedListener =
    _cache param
    [
        1,
        +_listenerPositionASL
    ];
private _cachedSource =
    _cache param
    [
        2,
        +_emissionPositionASL
    ];
private _previousTerrain = _cache param [3, 0.0];
private _previousObject = _cache param [4, 0.0];
private _previousHitCount = _cache param [5, 0];

private _checkInterval =
    (
        _vehicle getVariable
        [
            "gau_gau8_environmentCheckInterval",
            0.12
        ]
    )
    max 0.08
    min 0.50;

/* V9.5 relocation-sensitive environment cache. */
private _listenerMoved =
    (_listenerPositionASL vectorDistance _cachedListener) > 12;

private _sourceMoved =
    (_emissionPositionASL vectorDistance _cachedSource) > 20;

private _needsCheck =
    (time >= _nextCheck) ||
    {_listenerMoved} ||
    {_sourceMoved};

private _terrainOcclusion = _previousTerrain;
private _objectOcclusion = _previousObject;
private _objectHitCount = _previousHitCount;

if (_needsCheck && {_distance > 4}) then
{
    /*
        V9.4 weighted direct-path and enclosure occlusion.

        The centre ray represents the acoustic line of sight and therefore
        carries most of the weight. Two narrow rays prevent a single tiny
        gap from producing a hard binary result without allowing a large
        rock or wall to be bypassed by metre-scale offsets.

        A short listener-local enclosure probe detects rooms and other
        substantially enclosed spaces even when the direct source ray happens
        to pass through a window or doorway.
    */
    private _sourceToListener =
        _emissionPositionASL vectorFromTo _listenerPositionASL;

    private _side =
        _sourceToListener vectorCrossProduct [0, 0, 1];

    if ((vectorMagnitude _side) < 0.01) then
    {
        _side = [1, 0, 0];
    }
    else
    {
        _side = vectorNormalized _side;
    };

    private _up = [0, 0, 1];

    private _rayOrigin =
        _emissionPositionASL vectorAdd
        (_sourceToListener vectorMultiply 4.0);

    private _rayDefinitions =
    [
        [[0, 0, 0], 0.72],
        [
            (_side vectorMultiply 0.45)
            vectorAdd (_up vectorMultiply 0.25),
            0.14
        ],
        [
            (_side vectorMultiply -0.45)
            vectorAdd (_up vectorMultiply 0.25),
            0.14
        ]
    ];

    private _listenerObject = cameraOn;
    private _listenerIgnore =
        if (isNull _listenerObject) then
        {
            objNull
        }
        else
        {
            vehicle _listenerObject
        };

    private _terrainScore = 0.0;
    private _objectScore = 0.0;
    _objectHitCount = 0;

    {
        _x params
        [
            "_offset",
            "_weight"
        ];

        private _rayStart =
            _rayOrigin vectorAdd _offset;

        private _rayEnd =
            _listenerPositionASL vectorAdd _offset;

        private _terrainBlocked =
            terrainIntersectASL
            [
                _rayStart,
                _rayEnd
            ];

        if (_terrainBlocked) then
        {
            _terrainScore = _terrainScore + _weight;
        };

        if (_distance <= 5000) then
        {
            private _viewVisibility =
                [_vehicle, "VIEW", _listenerIgnore]
                checkVisibility
                [
                    _rayStart,
                    _rayEnd
                ];

            private _fireVisibility =
                [_vehicle, "FIRE", _listenerIgnore]
                checkVisibility
                [
                    _rayStart,
                    _rayEnd
                ];

            private _visibility =
                (_viewVisibility min _fireVisibility)
                max 0
                min 1;

            /*
                Emphasise partial coverage. A rock covering half the ray's
                visibility should sound substantially obstructed rather than
                only half of a weak linear effect.
            */
            private _rayOcclusion =
                sqrt ((1 - _visibility) max 0);

            if (!_terrainBlocked) then
            {
                _objectScore =
                    _objectScore +
                    (_weight * _rayOcclusion);
            };

            private _hits =
                lineIntersectsSurfaces
                [
                    _rayStart,
                    _rayEnd,
                    _vehicle,
                    _listenerIgnore,
                    true,
                    12,
                    "VIEW",
                    "FIRE",
                    false
                ];

            {
                private _hitObject = _x param [2, objNull];
                private _parentObject = _x param [3, objNull];

                if (
                    !isNull _hitObject ||
                    {!isNull _parentObject}
                ) then
                {
                    _objectHitCount = _objectHitCount + 1;
                };
            }
            forEach _hits;
        };
    }
    forEach _rayDefinitions;

    /*
        Listener enclosure probe: four horizontal rays and one upward ray.
        There is deliberately no downward ray, so ordinary ground proximity
        does not classify an outdoor listener as enclosed.
    */
    private _localStart =
        _listenerPositionASL vectorAdd [0, 0, 0.05];

    private _localDirections =
    [
        [8, 0, 0],
        [-8, 0, 0],
        [0, 8, 0],
        [0, -8, 0],
        [0, 0, 5]
    ];

    private _enclosureSum = 0.0;

    {
        private _localEnd = _localStart vectorAdd _x;

        private _localView =
            [_listenerIgnore, "VIEW", _vehicle]
            checkVisibility
            [
                _localStart,
                _localEnd
            ];

        private _localFire =
            [_listenerIgnore, "FIRE", _vehicle]
            checkVisibility
            [
                _localStart,
                _localEnd
            ];

        private _localVisibility =
            (_localView min _localFire)
            max 0
            min 1;

        _enclosureSum =
            _enclosureSum +
            sqrt ((1 - _localVisibility) max 0);

        private _localHits =
            lineIntersectsSurfaces
            [
                _localStart,
                _localEnd,
                _listenerIgnore,
                _vehicle,
                true,
                8,
                "VIEW",
                "FIRE",
                false
            ];

        {
            private _hitObject = _x param [2, objNull];
            private _parentObject = _x param [3, objNull];

            if (
                !isNull _hitObject ||
                {!isNull _parentObject}
            ) then
            {
                _objectHitCount = _objectHitCount + 1;
            };
        }
        forEach _localHits;
    }
    forEach _localDirections;

    private _enclosureOcclusion =
        (_enclosureSum / (count _localDirections))
        max 0
        min 1;

    private _targetTerrain =
        _terrainScore max 0 min 1;

    private _targetObject =
        (
            _objectScore max
            (0.90 * _enclosureOcclusion)
        )
        max 0
        min 1;

    private _smoothOcclusion =
    {
        params
        [
            "_previous",
            "_target"
        ];

        /* Fast obstruction attack, slower release. */
        private _response =
            [0.35, 0.88] select (_target > _previous);

        if (_listenerMoved || _sourceMoved) then
        {
            _response = 1.0;
        };

        _previous + ((_target - _previous) * _response)
    };

    _terrainOcclusion =
        [_previousTerrain, _targetTerrain]
        call _smoothOcclusion;

    _objectOcclusion =
        [_previousObject, _targetObject]
        call _smoothOcclusion;

    _vehicle setVariable
    [
        "gau_gau8_environmentCache",
        [
            time + _checkInterval,
            +_listenerPositionASL,
            +_emissionPositionASL,
            _terrainOcclusion,
            _objectOcclusion,
            _objectHitCount
        ]
    ];
};
_terrainOcclusion = (_terrainOcclusion max 0) min 1;
_objectOcclusion = (_objectOcclusion max 0) min 1;

private _combinedOcclusion =
    1 -
    (
        (1 - _terrainOcclusion) *
        (1 - _objectOcclusion)
    );

private _sourceGroundASL =
    getTerrainHeightASL
    [
        _emissionPositionASL select 0,
        _emissionPositionASL select 1
    ];

private _listenerGroundASL =
    getTerrainHeightASL
    [
        _listenerPositionASL select 0,
        _listenerPositionASL select 1
    ];

private _sourceHeightAGL =
    ((_emissionPositionASL select 2) - _sourceGroundASL) max 0;

private _listenerHeightAGL =
    ((_listenerPositionASL select 2) - _listenerGroundASL) max 0;

private _averageGroundASL =
    (_sourceGroundASL + _listenerGroundASL) * 0.5;

private _mirrorSource =
[
    _emissionPositionASL select 0,
    _emissionPositionASL select 1,
    (2 * _averageGroundASL) -
    (_emissionPositionASL select 2)
];

private _reflectedDistance =
    _mirrorSource vectorDistance _listenerPositionASL;

_reflectedDistance = _reflectedDistance max _distance;

private _reflectionPropagationDelay =
    _reflectedDistance / 343.0;

private _reflectionExtraDelay =
    (_reflectedDistance - _distance) / 343.0;

private _reflectionPositionASL = +_emissionPositionASL;
private _mirrorToListener =
    _listenerPositionASL vectorDiff _mirrorSource;
private _verticalSpan = _mirrorToListener select 2;

if ((abs _verticalSpan) > 0.001) then
{
    private _fraction =
        (
            (_averageGroundASL - (_mirrorSource select 2)) /
            _verticalSpan
        )
        max 0
        min 1;

    _reflectionPositionASL =
        _mirrorSource vectorAdd
        (_mirrorToListener vectorMultiply _fraction);

    _reflectionPositionASL set
    [
        2,
        (
            getTerrainHeightASL
            [
                _reflectionPositionASL select 0,
                _reflectionPositionASL select 1
            ]
        ) + 0.15
    ];
};

private _distancePresence =
    [
        _distance,
        [
            [0,    0.00],
            [60,   0.00],
            [100,  0.40],
            [250,  1.00],
            [1200, 1.00],
            [2000, 0.62],
            [3000, 0.18],
            [3500, 0.00]
        ]
    ]
    call _sampleCurve;

private _sourceHeightPresence =
    [
        _sourceHeightAGL,
        [
            [0,   1.00],
            [60,  1.00],
            [150, 0.85],
            [300, 0.55],
            [600, 0.20],
            [900, 0.00]
        ]
    ]
    call _sampleCurve;

private _listenerHeightPresence =
    [
        _listenerHeightAGL,
        [
            [0,   1.00],
            [8,   1.00],
            [25,  0.78],
            [60,  0.35],
            [120, 0.00]
        ]
    ]
    call _sampleCurve;

private _delayPresence =
    [
        _reflectionExtraDelay,
        [
            [0.000, 0.35],
            [0.001, 0.75],
            [0.003, 1.00],
            [0.040, 1.00],
            [0.120, 0.75],
            [0.250, 0.00]
        ]
    ]
    call _sampleCurve;

private _occlusionClear =
    (1 - _terrainOcclusion) *
    (1 - (0.75 * _objectOcclusion));

private _reflectionPresence =
    0.18 *
    _distancePresence *
    _sourceHeightPresence *
    _listenerHeightPresence *
    _delayPresence *
    _occlusionClear *
    _externalMix;

_reflectionPresence = (_reflectionPresence max 0) min 0.18;

[
    _terrainOcclusion,
    _objectOcclusion,
    _combinedOcclusion,
    _reflectionPresence,
    _reflectionPositionASL,
    _reflectionPropagationDelay,
    _reflectionExtraDelay,
    _sourceHeightAGL,
    _listenerHeightAGL,
    _objectHitCount
]
