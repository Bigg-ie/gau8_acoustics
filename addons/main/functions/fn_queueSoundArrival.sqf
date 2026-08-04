/*
    Queue one sound for local playback at its acoustic arrival time.
    The emission position is captured as PositionASL, so the report remains
    at the point where it was emitted rather than following the aircraft.
*/
params
[
    "_vehicle",
    "_path",
    "_emissionPositionASL",
    "_arrivalTime",
    "_volume",
    ["_pitch", 1.0],
    ["_maxDistance", 50000]
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
        "big_gau8_handlerGeneration",
        -1
    ];

private _queue =
    _vehicle getVariable
    [
        "big_gau8_arrivalQueue",
        []
    ];

_queue pushBack
[
    _arrivalTime,
    _path,
    +_emissionPositionASL,
    _volume min 24,
    _pitch,
    _maxDistance,
    _generation
];

_queue sort true;

private _aircraftQueueLimit = 4096;

while {(count _queue) > _aircraftQueueLimit} do
{
    _queue deleteAt ((count _queue) - 1);
};

_vehicle setVariable
[
    "big_gau8_arrivalQueue",
    _queue
];

private _workerRunning =
    _vehicle getVariable
    [
        "big_gau8_arrivalWorkerRunning",
        false
    ];

if (!_workerRunning) then
{
    _vehicle setVariable
    [
        "big_gau8_arrivalWorkerRunning",
        true
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
                    private _queue =
                        _vehicle getVariable
                        [
                            "big_gau8_arrivalQueue",
                            []
                        ];

                    if ((count _queue) == 0) then
                    {
                        _finished = true;
                    }
                    else
                    {
                        private _event = _queue select 0;
                        private _wait = (_event select 0) - time;

                        if (_wait > 0) then
                        {
                            sleep ((_wait min 0.02) max 0.001);
                        }
                        else
                        {
                            _queue deleteAt 0;

                            _vehicle setVariable
                            [
                                "big_gau8_arrivalQueue",
                                _queue
                            ];

                            _event params
                            [
                                "_eventArrival",
                                "_eventPath",
                                "_eventPositionASL",
                                "_eventVolume",
                                "_eventPitch",
                                "_eventMaxDistance",
                                "_eventGeneration"
                            ];

                            if (_eventGeneration == _generation) then
                            {
                                private _soundAnchor =
                                    if (!isNull player) then
                                    {
                                        vehicle player
                                    }
                                    else
                                    {
                                        _vehicle
                                    };

                                private _soundID =
                                    playSound3D
                                    [
                                        _eventPath,
                                        _soundAnchor,
                                        false,
                                        _eventPositionASL,
                                        _eventVolume,
                                        _eventPitch,
                                        _eventMaxDistance,
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

                                    while {(count _ids) > 128} do
                                    {
                                        _ids deleteAt 0;
                                    };

                                    _vehicle setVariable
                                    [
                                        "big_gau8_grainIDs",
                                        _ids
                                    ];
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
                    "big_gau8_handlerGeneration",
                    -1
                ];

            if (_currentGeneration == _generation) then
            {
                _vehicle setVariable
                [
                    "big_gau8_arrivalWorkerRunning",
                    false
                ];
            };
        };
    };
};

true
