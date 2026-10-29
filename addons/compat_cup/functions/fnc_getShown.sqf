#include "..\script_component.hpp"
/*
 * Author: Andx
 * Returns the antennas of a CUP system a vehicle currently shows. CUP lets players hide them.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: System, "duke" <STRING>
 *
 * Return Value:
 * Animation sources of the shown antennas <ARRAY>
 *
 * Example:
 * [_vehicle, "duke"] call ewc_compat_cup_fnc_getShown
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_system", SYSTEM_DUKE, [""]]];

([_vehicle, _system] call FUNC(getSources)) select {_vehicle animationSourcePhase _x < ANTENNA_SHOWN_BELOW}
