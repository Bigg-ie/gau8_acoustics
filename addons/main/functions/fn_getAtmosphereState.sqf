params
[
    ["_vehicle", objNull]
];

private _weatherEnabled =
    if (!isNull _vehicle) then
    {
        _vehicle getVariable
        [
            "gau_gau8_weatherPropagationEnabled",
            missionNamespace getVariable
            [
                "gau_gau8_weatherPropagationEnabledDefault",
                true
            ]
        ]
    }
    else
    {
        missionNamespace getVariable
        [
            "gau_gau8_weatherPropagationEnabledDefault",
            true
        ]
    };

private _temperatureEnabled =
    if (!isNull _vehicle) then
    {
        _vehicle getVariable
        [
            "gau_gau8_temperaturePropagationEnabled",
            missionNamespace getVariable
            [
                "gau_gau8_temperaturePropagationEnabledDefault",
                true
            ]
        ]
    }
    else
    {
        missionNamespace getVariable
        [
            "gau_gau8_temperaturePropagationEnabledDefault",
            true
        ]
    };

private _humidityEnabled =
    if (!isNull _vehicle) then
    {
        _vehicle getVariable
        [
            "gau_gau8_humidityPropagationEnabled",
            missionNamespace getVariable
            [
                "gau_gau8_humidityPropagationEnabledDefault",
                true
            ]
        ]
    }
    else
    {
        missionNamespace getVariable
        [
            "gau_gau8_humidityPropagationEnabledDefault",
            true
        ]
    };

private _windEnabled =
    if (!isNull _vehicle) then
    {
        _vehicle getVariable
        [
            "gau_gau8_windPropagationEnabled",
            missionNamespace getVariable
            [
                "gau_gau8_windPropagationEnabledDefault",
                true
            ]
        ]
    }
    else
    {
        missionNamespace getVariable
        [
            "gau_gau8_windPropagationEnabledDefault",
            true
        ]
    };

private _temperatureC = 20.0;
private _relativeHumidity = 0.0;
private _windVector = [0, 0, 0];

if (_weatherEnabled) then
{
    if (_temperatureEnabled) then
    {
        private _temperatures = ambientTemperature;

        if ((count _temperatures) > 0) then
        {
            _temperatureC =
                (
                    _temperatures param [0, 20.0]
                )
                max -60
                min 60;
        };
    };

    if (_humidityEnabled) then
    {
        _relativeHumidity =
            humidity
            max 0
            min 1;
    };

    if (_windEnabled) then
    {
        _windVector = +wind;

        if ((count _windVector) != 3) then
        {
            _windVector = [0, 0, 0];
        };
    };
};

private _soundSpeed =
    331.3 +
    (0.606 * _temperatureC) +
    (1.24 * _relativeHumidity);

private _speedOverride = -1.0;

if (!isNull _vehicle) then
{
    _speedOverride =
        _vehicle getVariable
        [
            "gau_gau8_speedOfSound",
            -1.0
        ];
};

if (_speedOverride <= 0) then
{
    _speedOverride =
        missionNamespace getVariable
        [
            "gau_gau8_speedOfSound",
            -1.0
        ];
};

if (_speedOverride > 0) then
{
    _soundSpeed = _speedOverride;
};

_soundSpeed =
    _soundSpeed
    max 280
    min 380;

private _windMagnitude =
    vectorMagnitude _windVector;

if (_windMagnitude > (_soundSpeed * 0.25)) then
{
    _windVector =
        _windVector vectorMultiply
        (
            (_soundSpeed * 0.25) /
            _windMagnitude
        );
};

[
    _soundSpeed,
    _windVector,
    _temperatureC,
    _relativeHumidity
]
