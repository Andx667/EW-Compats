#include "..\script_component.hpp"
/*
 * Author: Andx
 * Condition of the system actions: shown to driver, commander and gunners of the vehicle, in the interaction style chosen in the settings.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Action switches the system on <BOOL>
 * 3: Called by the scroll wheel action, not by ACE <BOOL>
 * 4: System, "duke" or "boomerang" <STRING> (default: "duke")
 *
 * Return Value:
 * Show the action <BOOL>
 *
 * Example:
 * [_vehicle, player, true, true, "boomerang"] call ewc_compat_cup_fnc_canToggle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_unit", objNull, [objNull]], ["_turnOn", true, [true]], ["_scroll", true, [true]], ["_system", SYSTEM_DUKE, [""]]];

private _allowed = if (_scroll) then {
    // Without ACE the scroll wheel is the only way, whatever the setting says
    GVAR(actionMode) in [ACTION_MODE_SCROLL, ACTION_MODE_BOTH] || {!GVAR(aceLoaded)}
} else {
    GVAR(actionMode) in [ACTION_MODE_ACE, ACTION_MODE_BOTH]
};

if (!_allowed || {!alive _vehicle} || {vehicle _unit != _vehicle}) exitWith {false};

// Driver, commander and gunners operate the systems, passengers do not
if (toLower ((assignedVehicleRole _unit) select 0) in ["cargo", ""]) exitWith {false};

private _isOn = _vehicle getVariable [[QGVAR(boomerangOn), QGVAR(dukeOn)] select (_system == SYSTEM_DUKE), false];

if (_turnOn) then {
    !_isOn && {[_vehicle, _system] call FUNC(canActivate)}
} else {
    _isOn
}
