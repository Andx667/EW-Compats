#include "..\script_component.hpp"
/*
 * Author: Andx
 * Server handler of a switch request. Checks that the system can be switched as asked. DUKE and Boomerang
 * exclude each other, so switching one on switches the other off.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Switch on <BOOL>
 * 2: System, "duke" or "boomerang" <STRING> (default: "duke")
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true, "boomerang"] call ewc_compat_cup_fnc_handleToggle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_turnOn", false, [false]], ["_system", SYSTEM_DUKE, [""]]];

if (isNull _vehicle) exitWith {};

private _isDuke = _system == SYSTEM_DUKE;

// The DUKE is not registered yet, or not a DUKE vehicle
if (_isDuke && {isNil {_vehicle getVariable QGVAR(jammerState)}}) exitWith {};

if (_turnOn isEqualTo (_vehicle getVariable [[QGVAR(boomerangOn), QGVAR(dukeOn)] select _isDuke, false])) exitWith {};

if (_turnOn && {!([_vehicle, _system] call FUNC(canActivate))}) exitWith {};

if (_isDuke) then {
    if (_turnOn && {_vehicle getVariable [QGVAR(boomerangOn), false]}) then {
        [_vehicle, false] call FUNC(setBoomerang);
    };

    [_vehicle, _turnOn] call FUNC(setJammer);
} else {
    if (_turnOn && {_vehicle getVariable [QGVAR(dukeOn), false]}) then {
        [_vehicle, false] call FUNC(setJammer);
    };

    [_vehicle, _turnOn] call FUNC(setBoomerang);
};
