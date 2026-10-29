#include "..\script_component.hpp"
/*
 * Author: Andx
 * Checks if a vehicle currently shows an antenna of a system. CUP lets players hide them.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: System, "duke" <STRING>
 *
 * Return Value:
 * At least one antenna shown <BOOL>
 *
 * Example:
 * [_vehicle, "duke"] call ewc_compat_cup_fnc_isShown
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_system", SYSTEM_DUKE, [""]]];

([_vehicle, _system] call FUNC(getShown)) isNotEqualTo []
