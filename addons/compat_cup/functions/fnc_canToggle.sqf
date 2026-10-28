#include "..\script_component.hpp"
/*
 * Author: Andx
 * Condition of the DUKE actions: shown to crew of the vehicle, in the interaction style chosen in the settings.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Action switches the DUKE on <BOOL>
 * 3: Called by the scroll wheel action, not by ACE <BOOL>
 *
 * Return Value:
 * Show the action <BOOL>
 *
 * Example:
 * [_vehicle, player, true, true] call ewc_compat_cup_fnc_canToggle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_unit", objNull, [objNull]], ["_turnOn", true, [true]], ["_scroll", true, [true]]];

private _allowed = if (_scroll) then {
    // Without ACE the scroll wheel is the only way, whatever the setting says
    GVAR(actionMode) in [ACTION_MODE_SCROLL, ACTION_MODE_BOTH] || {!GVAR(aceLoaded)}
} else {
    GVAR(actionMode) in [ACTION_MODE_ACE, ACTION_MODE_BOTH]
};

if (!_allowed || {!alive _vehicle} || {vehicle _unit != _vehicle}) exitWith {false};

private _isOn = _vehicle getVariable [QGVAR(dukeOn), false];

if (_turnOn) then {
    !_isOn && {_vehicle call FUNC(canActivate)}
} else {
    _isOn
}
