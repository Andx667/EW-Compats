#include "..\script_component.hpp"
/*
 * Author: Andx
 * Server handler of a Boomerang switch request. Checks that the Boomerang can be switched as asked. DUKE and Boomerang
 * exclude each other, so switching the Boomerang on tells the DUKE to switch off.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Switch on <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true] call ewc_compat_cup_boomerang_fnc_handleToggle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_turnOn", false, [false]]];

if (isNull _vehicle) exitWith {};

if (_turnOn isEqualTo (_vehicle getVariable [QGVAR(on), false])) exitWith {};

if (_turnOn && {!([_vehicle] call FUNC(canActivate))}) exitWith {};

if (_turnOn) then {
    [EVENT_SYSTEM_ON, [_vehicle, SYSTEM_BOOMERANG]] call CBA_fnc_localEvent;
};

[_vehicle, _turnOn] call FUNC(setState);
