#include "..\script_component.hpp"
/*
 * Author: Andx
 * Checks if the Boomerang of a vehicle can be switched on: Boomerang enabled in the settings, vehicle alive,
 * at least one antenna shown and, if required, engine running.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Can be switched on <BOOL>
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_boomerang_fnc_canActivate
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

([_vehicle] call FUNC(getBlockReason)) isEqualTo ""
