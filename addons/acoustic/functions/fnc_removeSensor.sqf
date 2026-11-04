#include "..\script_component.hpp"
/*
 * Author: Andx
 * Stops an object from being an acoustic drone sensor. The tracks it alone kept alive end after the track timeout.
 * Can be called on any machine.
 *
 * Arguments:
 * 0: Sensor object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_mast] call ewc_acoustic_fnc_removeSensor
 *
 * Public: Yes
 */

params [["_sensor", objNull, [objNull]]];

if (isNull _sensor) exitWith {};

if (!isServer) exitWith {
    [QGVAR(removeSensor), [_sensor]] call CBA_fnc_serverEvent;
};

_sensor setVariable [QGVAR(side), nil, true];

GVAR(sensors) deleteAt (GVAR(sensors) find _sensor);
