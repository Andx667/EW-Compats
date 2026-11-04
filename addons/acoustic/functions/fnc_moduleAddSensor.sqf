#include "..\script_component.hpp"
/*
 * Author: Andx
 * Module function of "Acoustic Drone Sensor": makes every synced object an acoustic sensor of the side of the module.
 * Without a synced object a data terminal is placed at the module and becomes the sensor.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synced objects <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * True <BOOL>
 *
 * Example:
 * [_logic, [_mast], true] call ewc_acoustic_fnc_moduleAddSensor
 *
 * Public: No
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated || {!isServer}) exitWith {true};

private _side = SENSOR_SIDES select (_logic getVariable [QGVAR(side), SENSOR_SIDE_WEST]);

if (_units isEqualTo []) then {
    _units = [createVehicle [SENSOR_PROP, ASLToAGL getPosASL _logic, [], 0, "CAN_COLLIDE"]];
};

{
    [_x, _side] call FUNC(addSensor);
} forEach _units;

true
