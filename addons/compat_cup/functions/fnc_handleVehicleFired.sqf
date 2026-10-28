#include "..\script_component.hpp"
/*
 * Author: Andx
 * Server handler of the weapons of a vehicle with a Boomerang being fired. The sensor is deafened for the
 * lockout time set in the settings.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_handleVehicleFired
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

if (isNull _vehicle) exitWith {};

_vehicle setVariable [QGVAR(deafUntil), CBA_missionTime + GVAR(lockout), true];
