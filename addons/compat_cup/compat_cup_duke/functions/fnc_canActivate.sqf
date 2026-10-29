#include "..\script_component.hpp"
/*
 * Author: Andx
 * Checks if the DUKE of a vehicle can be switched on: DUKE enabled in the settings, vehicle alive,
 * at least one antenna shown and the engine running.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Can be switched on <BOOL>
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_duke_canActivate
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

([_vehicle] call FUNC(duke_getBlockReason)) isEqualTo ""
