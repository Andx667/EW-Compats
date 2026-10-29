#include "..\script_component.hpp"
/*
 * Author: Andx
 * Adds the ACE self-interaction actions that switch the Boomerang on and off to all land vehicles. The condition
 * checks that the vehicle has a Boomerang antenna, so the actions only show up where they belong.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_compat_boomerang_fnc_addAceActions
 *
 * Public: No
 */

private _icon = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa";

{
    _x params ["_turnOn", "_key"];

    private _action = [
        format ["%1_%2", QUOTE(ADDON), _key],
        localize format ["STR_ewc_compat_boomerang_%1", _key],
        _icon,
        {
            params ["_target", "", "_turnOn"];

            [QGVAR(toggle), [_target, _turnOn]] call CBA_fnc_serverEvent;
        },
        {
            params ["_target", "_player", "_turnOn"];

            ([_target] call FUNC(getSources)) isNotEqualTo []
            && {[_target, _player, _turnOn, false] call FUNC(canToggle)}
        },
        {},
        _turnOn
    ] call ace_interact_menu_fnc_createAction;

    ["LandVehicle", 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
} forEach [[true, "activate"], [false, "deactivate"]];
