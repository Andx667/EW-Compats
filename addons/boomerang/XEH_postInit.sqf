#include "script_component.hpp"

if (isServer) then {
    [QGVAR(toggle), LINKFUNC(handleToggle)] call CBA_fnc_addEventHandler;
    [QGVAR(vehicleFired), LINKFUNC(handleVehicleFired)] call CBA_fnc_addEventHandler;

    // A player who joins late has missed the list of Boomerangs that are on
    [QGVAR(requestList), {
        params ["_owner"];

        [QGVAR(listChanged), [GVAR(vehicles)], _owner] call CBA_fnc_ownerEvent;
    }] call CBA_fnc_addEventHandler;
};

// The server sends the list of Boomerangs that are on. A machine only watches projectiles while it is not empty
[QGVAR(listChanged), {
    params ["_vehicles"];

    GVAR(vehicles) = _vehicles;
    call FUNC(updateListening);
}] call CBA_fnc_addEventHandler;

call FUNC(updateListening);

// The handler above has to exist before the answer comes
if (didJIP && {!isServer}) then {
    [QGVAR(requestList), [clientOwner]] call CBA_fnc_serverEvent;
};

if (hasInterface) then {
    [QGVAR(shotDetected), LINKFUNC(onShotDetected)] call CBA_fnc_addEventHandler;
    [QGVAR(deafChanged), LINKFUNC(onDeafChanged)] call CBA_fnc_addEventHandler;

    ["boomerang"] call EFUNC(common,addAceSwitchActions);
};
