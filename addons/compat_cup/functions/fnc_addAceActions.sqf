#include "..\script_component.hpp"
/*
 * Author: Andx
 * Adds the DUKE switch to the ACE self interaction menu of land vehicles. The condition limits it to vehicles with a shown DUKE.
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

private _activate = [
    QGVAR(activate),
    LLSTRING(activate),
    _icon,
    {[QGVAR(toggle), [_target, true]] call CBA_fnc_serverEvent},
    {
        (_target call FUNC(getDukeSources)) isNotEqualTo []
        && {[_target, _player, true, false] call FUNC(canToggle)}
    }
] call ace_interact_menu_fnc_createAction;

private _deactivate = [
    QGVAR(deactivate),
    LLSTRING(deactivate),
    _icon,
    {[QGVAR(toggle), [_target, false]] call CBA_fnc_serverEvent},
    {
        (_target call FUNC(getDukeSources)) isNotEqualTo []
        && {[_target, _player, false, false] call FUNC(canToggle)}
    }
] call ace_interact_menu_fnc_createAction;

{
    ["LandVehicle", 1, ["ACE_SelfActions"], _x, true] call ace_interact_menu_fnc_addActionToClass;
} forEach [_activate, _deactivate];
