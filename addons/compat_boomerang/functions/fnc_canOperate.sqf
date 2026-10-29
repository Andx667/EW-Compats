#include "..\script_component.hpp"
/*
 * Author: Andx
 * May a unit operate the Boomerang of a vehicle. Driver, commander and gunners may, passengers may not, and the
 * interaction style has to be the one from the settings.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Scroll wheel action (true) or ACE self-interaction (false) <BOOL> (default: true)
 *
 * Return Value:
 * Unit may operate the Boomerang <BOOL>
 *
 * Example:
 * [_vehicle, player, true] call ewc_compat_boomerang_fnc_canOperate
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

// Driver, commander and gunners operate the system, passengers do not
!(toLower ((assignedVehicleRole _unit) select 0) in ["cargo", ""])
