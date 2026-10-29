#include "..\script_component.hpp"
/*
 * Author: Andx
 * Server handler of the weapons of a vehicle with a Boomerang being fired. The sensor is deafened for the
 * lockout time. A Boomerang that is on tells the crew when it goes deaf and when it listens again, once per
 * stretch of fire, not for every burst.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_compat_boomerang_fnc_handleVehicleFired
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

if (isNull _vehicle) exitWith {};

private _wasDeaf = CBA_missionTime < (_vehicle getVariable [QGVAR(deafUntil), 0]);
private _deafUntil = CBA_missionTime + BOOMERANG_LOCKOUT;

_vehicle setVariable [QGVAR(deafUntil), _deafUntil, true];

// Nothing to tell about a Boomerang that is off
if !(_vehicle getVariable [QGVAR(on), false]) exitWith {};

// Further bursts only move the end of the lockout
if (!_wasDeaf) then {
    [QGVAR(deafChanged), [_vehicle, true]] call CBA_fnc_globalEvent;
};

[{
    params ["_vehicle", "_deafUntil"];

    // A later burst moved the end, its own timer tells then. A Boomerang that was switched off meanwhile is silent
    if (isNull _vehicle || {(_vehicle getVariable [QGVAR(deafUntil), 0]) > _deafUntil} || {!(_vehicle getVariable [QGVAR(on), false])}) exitWith {};

    [QGVAR(deafChanged), [_vehicle, false]] call CBA_fnc_globalEvent;
}, [_vehicle, _deafUntil], BOOMERANG_LOCKOUT] call CBA_fnc_waitAndExecute;
