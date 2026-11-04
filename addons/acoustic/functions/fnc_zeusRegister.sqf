#include "..\script_component.hpp"
/*
 * Author: Andx
 * Registers the Zeus modules to add and remove an acoustic sensor with Zeus Enhanced. Does nothing without it.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_acoustic_fnc_zeusRegister
 *
 * Public: No
 */

if (!hasInterface || {!isClass (configFile >> "CfgPatches" >> "zen_custom_modules")}) exitWith {};

{
    [ZEUS_CATEGORY, _x select 0, _x select 1, SENSOR_ICON] call zen_custom_modules_fnc_register;
} forEach [
    [LLSTRING(moduleAddSensor_displayName), {_this call FUNC(zeusAddSensor)}],
    [LLSTRING(zeus_remove_displayName), {_this call FUNC(zeusRemoveSensor)}]
];
