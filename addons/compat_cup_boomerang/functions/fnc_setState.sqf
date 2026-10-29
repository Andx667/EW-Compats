#include "..\script_component.hpp"
/*
 * Author: Andx
 * Switches the Boomerang of a vehicle. Active vehicles are in a list every machine gets, so the machine of a
 * shooter can check its shot against them.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Boomerang on <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true] call ewc_compat_cup_boomerang_fnc_setState
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_enabled", false, [false]]];

_vehicle setVariable [QGVAR(on), _enabled, true];

if (_enabled) then {
    GVAR(vehicles) pushBackUnique _vehicle;

    if (GVAR(loopHandle) < 0) then {
        GVAR(loopHandle) = [LINKFUNC(loop), LOOP_INTERVAL] call CBA_fnc_addPerFrameHandler;
    };
} else {
    GVAR(vehicles) = GVAR(vehicles) - [_vehicle];
};

[QGVAR(listChanged), [GVAR(vehicles)]] call CBA_fnc_globalEvent;
