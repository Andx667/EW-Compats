#include "..\script_component.hpp"
/*
 * Author: Andx
 * Makes an object an acoustic drone sensor of a side: a microphone array that listens for the rotors and propellers of
 * drones. The drones it hears are tracked and shown to that side. Any object works, a vehicle hears little while its
 * own engine runs. Can be called on any machine, the server keeps the sensors.
 *
 * Arguments:
 * 0: Sensor object <OBJECT>
 * 1: Side the sensor reports to <SIDE> (default: west)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_mast, west] call ewc_acoustic_fnc_addSensor
 *
 * Public: Yes
 */

params [["_sensor", objNull, [objNull]], ["_side", west, [sideUnknown]]];

if (isNull _sensor) exitWith {};

if (!isServer) exitWith {
    [QGVAR(addSensor), [_sensor, _side]] call CBA_fnc_serverEvent;
};

// Public, so other machines (Zeus, scripts) can tell a sensor and its side
_sensor setVariable [QGVAR(side), _side, true];

GVAR(sensors) pushBackUnique _sensor;

// The scan only runs while there is a sensor
if (GVAR(scanHandle) == -1) then {
    GVAR(scanHandle) = [LINKFUNC(scan), SCAN_INTERVAL] call CBA_fnc_addPerFrameHandler;
};
