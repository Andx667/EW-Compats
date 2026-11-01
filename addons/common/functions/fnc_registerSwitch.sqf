#include "..\script_component.hpp"
/*
 * Author: Andx
 * Registers a system of a vehicle that the crew switches on and off (a DUKE, a shot finder, a jammer) with the switch
 * actions of ewc_common: the scroll wheel actions (fnc_addSwitchActions) and the ACE self-interaction actions
 * (fnc_addAceSwitchActions), both limited to the crew by fnc_canToggle and the setting ewc_common_actionMode.
 * Call it on every machine with an interface, in preInit, so editor-placed vehicles find it when they initialise.
 *
 * Arguments:
 * 0: Id of the system, unique across the addons <STRING>
 * 1: Server event the actions raise with [vehicle, switch on], handled by the addon of the system <STRING>
 * 2: Public variable on the vehicle that holds the state of the system <STRING>
 * 3: Can the system be switched on, called with [vehicle] <CODE>
 * 4: Stringtable key of the title of the action that switches it on <STRING>
 * 5: Stringtable key of the title of the action that switches it off <STRING>
 * 6: Does the vehicle have the system, called with [vehicle]. Only the ACE actions need it, they are added to all land vehicles <CODE>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["duke", "ewc_compat_cup_duke_toggle", "ewc_compat_cup_duke_on", {_this call ewc_compat_cup_fnc_duke_canActivate}, "STR_ewc_compat_cup_duke_activate", "STR_ewc_compat_cup_duke_deactivate", {_this call ewc_compat_cup_fnc_duke_hasSystem}] call ewc_common_fnc_registerSwitch
 *
 * Public: Yes
 */

params [
    ["_id", "", [""]],
    ["_event", "", [""]],
    ["_onVariable", "", [""]],
    ["_canActivate", {false}, [{}]],
    ["_titleActivate", "", [""]],
    ["_titleDeactivate", "", [""]],
    ["_hasSystem", {false}, [{}]]
];

if (_id isEqualTo "") exitWith {};

GVAR(switches) set [_id, [_event, _onVariable, _canActivate, _titleActivate, _titleDeactivate, _hasSystem]];
