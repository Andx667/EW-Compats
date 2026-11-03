#include "..\script_component.hpp"
/*
 * Author: Andx
 * Zeus module "Remove Acoustic Sensor": the object it is placed on is no acoustic sensor any more.
 *
 * Arguments:
 * 0: Position the module was placed at, ASL <ARRAY>
 * 1: Object the module was placed on <OBJECT> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [getPosASL player, _mast] call ewc_acoustic_fnc_zeusRemoveSensor
 *
 * Public: No
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_sensor", objNull, [objNull]]];

if (isNull _sensor || {isNil {_sensor getVariable QGVAR(side)}}) exitWith {
    [LLSTRING(zeus_noSensor)] call zen_common_fnc_showMessage;
};

[_sensor] call FUNC(removeSensor);
