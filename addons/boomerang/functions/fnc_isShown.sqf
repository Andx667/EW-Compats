#include "..\script_component.hpp"
/*
 * Author: Andx
 * Is the shot finder antenna of a vehicle shown. Mods hide it by default (phase 1), it is shown in the vehicle appearance options.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * At least one antenna is shown <BOOL>
 *
 * Example:
 * [_vehicle] call ewc_boomerang_fnc_isShown
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

([_vehicle] call FUNC(getSources)) findIf {_vehicle animationSourcePhase _x < ANTENNA_SHOWN_BELOW} != -1
