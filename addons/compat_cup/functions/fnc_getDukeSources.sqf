#include "..\script_component.hpp"
/*
 * Author: Andx
 * Returns the animation sources of a vehicle that belong to a CUP DUKE antenna.
 * CUP's DUKE only exists as a model, so this is what marks a vehicle as DUKE equipped.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Animation sources, empty if the vehicle has no DUKE <ARRAY>
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_getDukeSources
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

// getOrDefaultCall provides _key
#pragma hemtt ignore_variables ["_key"]
GVAR(sourceCache) getOrDefaultCall [typeOf _vehicle, {
    (configProperties [configFile >> "CfgVehicles" >> _key >> "AnimationSources", "isClass _x", true])
        apply {configName _x}
        select {toLower _x in DUKE_SOURCES}
}, true]
