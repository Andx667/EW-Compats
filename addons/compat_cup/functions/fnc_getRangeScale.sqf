#include "..\script_component.hpp"
/*
 * Author: Andx
 * Returns how much of its range the DUKE of a vehicle has, from the antennas currently shown. CUP lets
 * players hide them. Vehicles with a DUKE and a CREW DUKE antenna (M1240 family) lose range with only one shown.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * 1 with all antennas shown, 0.6 with some, 0 with none <NUMBER>
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_getRangeScale
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

private _sources = _vehicle call FUNC(getDukeSources);
private _shown = {_vehicle animationSourcePhase _x < DUKE_SHOWN_BELOW} count _sources;

if (_shown == 0) exitWith {0};

[DUKE_SINGLE_ANTENNA_SCALE, 1] select (_shown == count _sources)
