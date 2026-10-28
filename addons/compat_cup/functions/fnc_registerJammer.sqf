#include "..\script_component.hpp"
/*
 * Author: Andx
 * Registers a vehicle with a DUKE as radio jammer in Crows Electronic Warfare.
 * The full jamming radius is the radius from the settings scaled by the shown antennas, the falloff radius is 1.5 times that.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Jammer enabled <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_registerJammer
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_enabled", false, [false]]];

if (isNull _vehicle || {!isServer}) exitWith {};

private _radius = _vehicle call FUNC(getRadius);

_vehicle setVariable [QGVAR(jammerState), [_enabled, _radius]];

[CROWS_EVENT_ADD_JAMMER, [
    _vehicle,
    DUKE_FALLOFF_FACTOR * _radius,
    _radius,
    _enabled,
    [CROWS_CAPABILITY_RADIO]
]] call CBA_fnc_localEvent;

// On a hosted server Crows adds its actions after it broadcasts the jammer list, so the cleanup on
// that update (fnc_removeCrowsActions) runs too early. The event above is handled synchronously
if (hasInterface) then {
    _vehicle call FUNC(clearCrowsActions);
};
