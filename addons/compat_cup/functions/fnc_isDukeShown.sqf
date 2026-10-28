#include "..\script_component.hpp"
/*
 * Author: Andx
 * Checks if a vehicle currently shows a DUKE antenna. CUP lets players hide it, and the DUKE
 * is not available then.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Antenna shown <BOOL>
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_isDukeShown
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

(_vehicle call FUNC(getDukeSources)) findIf {_vehicle animationPhase _x < DUKE_SHOWN_BELOW} != -1
