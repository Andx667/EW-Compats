#include "..\script_component.hpp"
/*
 * Author: Andx
 * Adds the DUKE and Boomerang switches to the ACE self interaction menu of land vehicles. The condition limits
 * them to vehicles with the system.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_compat_cup_fnc_addAceActions
 *
 * Public: No
 */

private _icon = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa";

{
    private _system = _x;
    private _isDuke = _system == SYSTEM_DUKE;

    {
        _x params ["_turnOn", "_id", "_title"];

        private _action = [
            _id + _system,
            _title,
            _icon,
            {
                params ["_target", "", "_params"];
                _params params ["_turnOn", "_system"];

                [QGVAR(toggle), [_target, _turnOn, _system]] call CBA_fnc_serverEvent;
            },
            {
                params ["_target", "_player", "_params"];
                _params params ["_turnOn", "_system"];

                ([_target, _system] call FUNC(getSources)) isNotEqualTo []
                && {[_target, _player, _turnOn, false, _system] call FUNC(canToggle)}
            },
            {},
            [_turnOn, _system]
        ] call ace_interact_menu_fnc_createAction;

        ["LandVehicle", 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
    } forEach [
        [true, QGVAR(activate), [LLSTRING(boomerang_activate), LLSTRING(activate)] select _isDuke],
        [false, QGVAR(deactivate), [LLSTRING(boomerang_deactivate), LLSTRING(deactivate)] select _isDuke]
    ];
} forEach [SYSTEM_DUKE, SYSTEM_BOOMERANG];
