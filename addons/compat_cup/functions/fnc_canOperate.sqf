#include "..\script_component.hpp"
/*
 * Author: Andx
 * Checks if a unit may operate the systems of a vehicle: driver, commander or gunner of the vehicle, with the
 * interaction style chosen in the settings.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Called by the scroll wheel action, not by ACE <BOOL>
 *
 * Return Value:
 * Unit may operate <BOOL>
 *
 * Example:
 * [_vehicle, player, true] call ewc_compat_cup_fnc_canOperate
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_unit", objNull, [objNull]], ["_scroll", true, [true]]];

private _allowed = if (_scroll) then {
    // Without ACE the scroll wheel is the only way, whatever the setting says
    GVAR(actionMode) in [ACTION_MODE_SCROLL, ACTION_MODE_BOTH] || {!GVAR(aceLoaded)}
} else {
    GVAR(actionMode) in [ACTION_MODE_ACE, ACTION_MODE_BOTH]
};

if (!_allowed || {!alive _vehicle} || {vehicle _unit != _vehicle}) exitWith {false};

// Driver, commander and gunners operate the systems, passengers do not
!(toLower ((assignedVehicleRole _unit) select 0) in ["cargo", ""])
