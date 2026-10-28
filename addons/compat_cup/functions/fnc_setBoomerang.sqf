#include "..\script_component.hpp"
/*
 * Author: Andx
 * Switches the Boomerang of a vehicle. Active vehicles are in a public list, so the machine of a shooter can check
 * its shot against them.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Boomerang on <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true] call ewc_compat_cup_fnc_setBoomerang
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_enabled", false, [false]]];

_vehicle setVariable [QGVAR(boomerangOn), _enabled, true];

if (_enabled) then {
    GVAR(boomerangVehicles) pushBackUnique _vehicle;

    if (GVAR(boomerangLoopHandle) < 0) then {
        GVAR(boomerangLoopHandle) = [LINKFUNC(boomerangLoop), LOOP_INTERVAL] call CBA_fnc_addPerFrameHandler;
    };
} else {
    GVAR(boomerangVehicles) = GVAR(boomerangVehicles) - [_vehicle];
};

publicVariable QGVAR(boomerangVehicles);
