#include "..\script_component.hpp"
/*
 * Author: Andx
 * Checks if the Hummel of a vehicle can be switched on: enabled in the settings, vehicle alive and engine running.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Can be switched on <BOOL>
 *
 * Example:
 * [_vehicle] call ewc_compat_rnt_fnc_canActivate
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

([_vehicle] call FUNC(getBlockReason)) isEqualTo ""
