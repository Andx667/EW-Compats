#include "..\script_component.hpp"
/*
 * Author: Andx
 * Adds the scroll wheel actions to switch a system of a vehicle on and off.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: System, "duke" or "boomerang" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "boomerang"] call ewc_compat_cup_fnc_addActions
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_system", SYSTEM_DUKE, [""]]];

private _isDuke = _system == SYSTEM_DUKE;

{
    _x params ["_turnOn", "_title"];

    _vehicle addAction [
        _title,
        {
            params ["_vehicle", "", "", "_arguments"];
            _arguments params ["_turnOn", "_system"];

            [QGVAR(toggle), [_vehicle, _turnOn, _system]] call CBA_fnc_serverEvent;
        },
        [_turnOn, _system],
        6,
        false,
        true,
        "",
        format ["[_target, _this, %1, true, '%2'] call %3", _turnOn, _system, QFUNC(canToggle)],
        5
    ];
} forEach [
    [true, [LLSTRING(boomerang_activate), LLSTRING(activate)] select _isDuke],
    [false, [LLSTRING(boomerang_deactivate), LLSTRING(deactivate)] select _isDuke]
];
