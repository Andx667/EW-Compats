#include "..\script_component.hpp"
/*
 * Author: Andx
 * Adds the switches of a registered system (fnc_registerSwitch) to the ACE self-interaction menu of all land vehicles.
 * The condition limits them to vehicles that have the system. The event and the titles are the ones of
 * fnc_addSwitchActions. Call it once on every machine with an interface, it does nothing without ACE.
 *
 * Arguments:
 * 0: Id of the system <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["duke"] call ewc_common_fnc_addAceSwitchActions
 *
 * Public: Yes
 */

params [["_id", "", [""]]];

private _switch = GVAR(switches) getOrDefault [_id, []];

if (!GVAR(aceLoaded) || {_switch isEqualTo []}) exitWith {};

_switch params ["", "", "", "_titleActivate", "_titleDeactivate"];

private _icon = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa";

{
    _x params ["_turnOn", "_key", "_title"];

    private _action = [
        format ["%1_%2_%3", QUOTE(ADDON), _id, _key],
        localize _title,
        _icon,
        {
            params ["_target", "", "_params"];
            _params params ["_turnOn", "_id"];

            [(GVAR(switches) get _id) select 0, [_target, _turnOn]] call CBA_fnc_serverEvent;
        },
        {
            params ["_target", "_player", "_params"];
            _params params ["_turnOn", "_id"];

            private _hasSystem = [_target] call ((GVAR(switches) get _id) select 5);

            _hasSystem && {[_target, _player, _turnOn, false, _id] call FUNC(canToggle)}
        },
        {},
        [_turnOn, _id]
    ] call ace_interact_menu_fnc_createAction;

    ["LandVehicle", 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
} forEach [[true, "activate", _titleActivate], [false, "deactivate", _titleDeactivate]];
