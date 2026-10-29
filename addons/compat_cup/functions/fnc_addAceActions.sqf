#include "..\script_component.hpp"
/*
 * Author: Andx
 * Adds the switches of a system to the ACE self interaction menu of land vehicles. The condition limits
 * them to vehicles with the system. The events and titles are the ones of fnc_addActions.
 *
 * Arguments:
 * 0: System, "duke" or "boomerang" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["boomerang"] call ewc_compat_cup_fnc_addAceActions
 *
 * Public: No
 */

params [["_system", "", [""]]];

private _icon = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa";

{
    _x params ["_turnOn", "_key"];

    private _action = [
        format ["ewc_compat_cup_%1_%2", _key, _system],
        localize format ["STR_ewc_compat_cup_%1_%2", _system, _key],
        _icon,
        {
            params ["_target", "", "_params"];
            _params params ["_turnOn", "_system"];

            [format ["ewc_compat_cup_%1_toggle", _system], [_target, _turnOn]] call CBA_fnc_serverEvent;
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
} forEach [[true, "activate"], [false, "deactivate"]];
