#include "..\script_component.hpp"
/*
 * Author: Andx
 * Server handler of a Hummel switch request. Checks that the Hummel can be switched as asked, then stores the state
 * and brings the jammer in line with it.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Switch on <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true] call ewc_compat_redd_fnc_handleToggle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_turnOn", false, [false]]];

if (isNull _vehicle) exitWith {};

// The jammer is not registered yet, or the vehicle is no Hummel
if (isNil {_vehicle getVariable QEGVAR(common,jammerState)}) exitWith {};

if (_turnOn isEqualTo (_vehicle getVariable [QGVAR(on), false])) exitWith {};

if (_turnOn && {!([_vehicle] call FUNC(canActivate))}) exitWith {};

_vehicle setVariable [QGVAR(on), _turnOn, true];

[_vehicle] call FUNC(syncJammer);
