#include "..\script_component.hpp"
/*
 * Author: Andx
 * Server handler of a DUKE switch request. Checks that the DUKE can be switched as asked.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Switch on <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true] call ewc_compat_cup_fnc_handleToggle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_turnOn", false, [false]]];

// Not registered yet or not a DUKE vehicle
if (isNull _vehicle || {isNil {_vehicle getVariable QGVAR(jammerState)}}) exitWith {};

if (_turnOn isEqualTo (_vehicle getVariable [QGVAR(dukeOn), false])) exitWith {};

if (_turnOn && {!(_vehicle call FUNC(canActivate))}) exitWith {};

[_vehicle, _turnOn] call FUNC(setJammer);
