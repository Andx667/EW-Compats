#include "..\script_component.hpp"
/*
 * Author: Andx
 * Checks if the DUKE of a vehicle can be switched on: vehicle alive, antenna shown and, if required, engine running.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Can be switched on <BOOL>
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_canActivate
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

alive _vehicle
    && {_vehicle call FUNC(isDukeShown)}
    && {!GVAR(requireEngine) || {isEngineOn _vehicle}}
