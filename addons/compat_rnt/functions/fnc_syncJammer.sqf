#include "..\script_component.hpp"
/*
 * Author: Andx
 * Brings the Crows radio jammer of a Hummel in line with its switch and the vehicle: on while the switch is on and
 * nothing blocks it (settings, destroyed, engine stopped). A switch that is blocked goes off with it, and the people
 * in the vehicle get the hint with the reason. The radius from the settings is applied here, a changed radius replaces
 * the jammer.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_compat_rnt_fnc_syncJammer
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

if (isNull _vehicle) exitWith {};

// The jammer is registered when it is first switched on, see ewc_common_fnc_setJammer
private _state = _vehicle getVariable [QEGVAR(common,jammerState), [false, -1]];

private _enabled = _state select 0;
private _alive = alive _vehicle;

private _reason = [_vehicle] call FUNC(getBlockReason);
private _switchOn = _vehicle getVariable [QGVAR(on), false];
private _wantEnabled = _switchOn && {_reason isEqualTo ""};

// A switch that is on but blocked goes off, so it does not come back by itself when the engine starts again
if (_switchOn && {!_wantEnabled}) then {
    _vehicle setVariable [QGVAR(on), false, true];
};

// A destroyed vehicle has nobody to tell
if (_alive && {_wantEnabled != _enabled}) then {
    // A crew that switches the Hummel off needs no reason, a blocked switch does
    [_vehicle, SYSTEM_NAME, _wantEnabled, ["", _reason] select _switchOn] call EFUNC(common,notifyState);
};

// Switches the jammer, or replaces it for another radius. A destroyed vehicle keeps its radius
[_vehicle, _wantEnabled, [-1, GVAR(radius)] select _alive] call EFUNC(common,setJammer);
