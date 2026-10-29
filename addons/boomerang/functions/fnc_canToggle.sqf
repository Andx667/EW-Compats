#include "..\script_component.hpp"
/*
 * Author: Andx
 * Condition of the switch actions: the unit may operate the Boomerang and the state allows the change.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Switch on (true) or off (false) <BOOL> (default: true)
 * 3: Scroll wheel action (true) or ACE self-interaction (false) <BOOL> (default: true)
 *
 * Return Value:
 * Action is offered <BOOL>
 *
 * Example:
 * [_vehicle, player, true, true] call ewc_boomerang_fnc_canToggle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_unit", objNull, [objNull]], ["_turnOn", true, [true]], ["_scroll", true, [true]]];

if (!([_vehicle, _unit, _scroll] call FUNC(canOperate))) exitWith {false};

private _isOn = _vehicle getVariable [QGVAR(on), false];

if (_turnOn) then {
    !_isOn && {[_vehicle] call FUNC(canActivate)}
} else {
    _isOn
}
