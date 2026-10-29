#include "..\script_component.hpp"
/*
 * Author: Andx
 * Checks if the DUKE of a vehicle can be switched on: DUKE enabled in the settings, vehicle alive,
 * at least one antenna shown and, if required, engine running.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Can be switched on <BOOL>
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_duke_fnc_canActivate
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

GVAR(enable)
    && {alive _vehicle}
    && {(_vehicle call FUNC(getRangeScale)) > 0}
    && {!EGVAR(compat_cup,requireEngine) || {isEngineOn _vehicle}}
