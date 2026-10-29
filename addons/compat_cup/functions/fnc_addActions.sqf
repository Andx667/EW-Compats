#include "..\script_component.hpp"
/*
 * Author: Andx
 * Adds the scroll wheel actions to switch a system of a vehicle on and off. They send the event
 * ewc_compat_cup_<system>_toggle to the server, and their titles are the strings
 * STR_ewc_compat_cup_<system>_activate and STR_ewc_compat_cup_<system>_deactivate of the addon of the system.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: System, "duke" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "duke"] call ewc_compat_cup_fnc_addActions
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_system", "", [""]]];

{
    _x params ["_turnOn", "_key"];

    _vehicle addAction [
        localize format ["STR_ewc_compat_cup_%1_%2", _system, _key],
        {
            params ["_vehicle", "", "", "_arguments"];
            _arguments params ["_turnOn", "_system"];

            [format ["ewc_compat_cup_%1_toggle", _system], [_vehicle, _turnOn]] call CBA_fnc_serverEvent;
        },
        [_turnOn, _system],
        6,
        false,
        true,
        "",
        format ["[_target, _this, %1, true, '%2'] call %3", _turnOn, _system, QFUNC(canToggle)],
        5
    ];
} forEach [[true, "activate"], [false, "deactivate"]];
