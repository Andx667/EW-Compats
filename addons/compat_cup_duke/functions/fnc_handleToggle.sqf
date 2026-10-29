#include "..\script_component.hpp"
/*
 * Author: Andx
 * Server handler of a DUKE switch request. Checks that the DUKE can be switched as asked. DUKE and Boomerang
 * exclude each other, so switching the DUKE on tells the Boomerang to switch off.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Switch on <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true] call ewc_compat_cup_duke_fnc_handleToggle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_turnOn", false, [false]]];

if (isNull _vehicle) exitWith {};

// The DUKE is not registered yet, or not a DUKE vehicle
if (isNil {_vehicle getVariable QEGVAR(main,jammerState)}) exitWith {};

if (_turnOn isEqualTo (_vehicle getVariable [QGVAR(on), false])) exitWith {};

if (_turnOn && {!([_vehicle] call FUNC(canActivate))}) exitWith {};

if (_turnOn) then {
    [EVENT_SYSTEM_ON, [_vehicle, SYSTEM_DUKE]] call CBA_fnc_localEvent;
};

[_vehicle, _turnOn] call FUNC(setJammer);
