#include "..\script_component.hpp"
/*
 * Author: Andx
 * Condition of the system actions: the unit may operate the vehicle and the system can be switched as the action asks.
 * The state and the activation check belong to the addon of the system, which names them by convention:
 * the public variable ewc_compat_cup_<system>_on and the function ewc_compat_cup_<system>_fnc_canActivate.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Action switches the system on <BOOL>
 * 3: Called by the scroll wheel action, not by ACE <BOOL>
 * 4: System, "duke" or "boomerang" <STRING>
 *
 * Return Value:
 * Show the action <BOOL>
 *
 * Example:
 * [_vehicle, player, true, true, "boomerang"] call ewc_compat_cup_fnc_canToggle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_unit", objNull, [objNull]], ["_turnOn", true, [true]], ["_scroll", true, [true]], ["_system", "", [""]]];

if (!([_vehicle, _unit, _scroll] call FUNC(canOperate))) exitWith {false};

private _isOn = _vehicle getVariable [format ["ewc_compat_cup_%1_on", _system], false];

if (_turnOn) then {
    private _canActivate = missionNamespace getVariable format ["ewc_compat_cup_%1_fnc_canActivate", _system];

    !_isOn && {!isNil "_canActivate"} && {[_vehicle] call _canActivate}
} else {
    _isOn
}
