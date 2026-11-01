#include "..\script_component.hpp"
/*
 * Author: Andx
 * Condition of the switch actions of a registered system (fnc_registerSwitch): the unit may operate the vehicle and the
 * system can be switched as the action asks. The state is the public variable of the system, the check for the
 * activation is the code the system registered.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Action switches the system on <BOOL> (default: true)
 * 3: Called by the scroll wheel action, not by ACE <BOOL> (default: true)
 * 4: Id of the system <STRING>
 *
 * Return Value:
 * Show the action <BOOL>
 *
 * Example:
 * [_vehicle, player, true, true, "duke"] call ewc_common_fnc_canToggle
 *
 * Public: Yes
 */

params [["_vehicle", objNull, [objNull]], ["_unit", objNull, [objNull]], ["_turnOn", true, [true]], ["_scroll", true, [true]], ["_id", "", [""]]];

private _switch = GVAR(switches) getOrDefault [_id, []];

if (_switch isEqualTo [] || {!([_vehicle, _unit, _scroll] call FUNC(canOperate))}) exitWith {false};

_switch params ["", "_onVariable", "_canActivate"];

private _isOn = _vehicle getVariable [_onVariable, false];

if (_turnOn) then {
    !_isOn && {[_vehicle] call _canActivate}
} else {
    _isOn
}
