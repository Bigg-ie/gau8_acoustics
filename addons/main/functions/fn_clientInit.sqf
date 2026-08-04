/*
    Client bootstrap for the scripted GAU-8 acoustic scheduler.

    Every listening client attaches the local Fired handler because the
    accepted long-form cannon recordings are emitted through playSound3D.
*/
if (!hasInterface) exitWith {};

private _installOnAircraft =
{
    params ["_aircraft"];

    if (isNull _aircraft) exitWith {};

    if !(
        "Gatling_30mm_Plane_CAS_01_F" in
        (weapons _aircraft)
    ) exitWith {};

    [_aircraft] call big_gau8_fnc_installGrainHandler;
};

private _oldEntityCreatedHandler =
    missionNamespace getVariable
    [
        "big_gau8_entityCreatedHandler",
        -1
    ];

if (_oldEntityCreatedHandler >= 0) then
{
    removeMissionEventHandler
    [
        "EntityCreated",
        _oldEntityCreatedHandler
    ];
};

private _entityCreatedHandler =
    addMissionEventHandler
    [
        "EntityCreated",
        {
            params ["_entity"];

            if (
                !isNull _entity &&
                {
                    "Gatling_30mm_Plane_CAS_01_F" in
                    (weapons _entity)
                }
            ) then
            {
                _entity spawn
                {
                    sleep 0.01;

                    if (!isNull _this) then
                    {
                        [_this] call
                            big_gau8_fnc_installGrainHandler;
                    };
                };
            };
        }
    ];

missionNamespace setVariable
[
    "big_gau8_entityCreatedHandler",
    _entityCreatedHandler
];

{
    [_x] call _installOnAircraft;
}
forEach vehicles;

diag_log format
[
    "GAU8: client bootstrap active; scanned %1 vehicles",
    count vehicles
];
