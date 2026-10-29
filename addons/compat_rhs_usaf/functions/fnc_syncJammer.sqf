#include "..\script_component.hpp"
/*
 * Author: Andx
 * Brings the Crows radio jammer of a vehicle in line with its DUKE: on/off state and antenna damage.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_compat_rhs_usaf_fnc_syncJammer
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

private _state = _vehicle getVariable QEGVAR(common,jammerState);

if (isNull _vehicle || {isNil "_state"}) exitWith {};

_state params ["_enabled", "_radius"];

// A destroyed vehicle ends the script of RHS at last, and its IEDs are freed like those of a DUKE switched off
private _alive = alive _vehicle;

if (!_alive) then {
    _vehicle setVariable [DUKE_STATE_VAR, false, true];
};

private _damage1 = _vehicle getHitPointDamage "HitDuke1";
private _damage2 = _vehicle getHitPointDamage "HitDuke2";

private _wantEnabled = _alive
    && GVAR(enableDuke)
    && {_vehicle getVariable [DUKE_STATE_VAR, false]}
    && {!(_damage1 >= DUKE_BOTH_ANTENNAS_DESTROYED && {_damage2 >= DUKE_BOTH_ANTENNAS_DESTROYED})};
private _wantScale = [1, DUKE_SINGLE_ANTENNA_SCALE] select (_damage1 >= DUKE_ANTENNA_DESTROYED || {_damage2 >= DUKE_ANTENNA_DESTROYED});
private _wantRadius = getNumber (([_vehicle] call EFUNC(common,getJammerConfig)) >> "radius") * _wantScale;

// rhs_duke.sqf frees its IEDs from the machine of the gunner, which only works for local ones. Free them from here
if (_enabled && {!_wantEnabled}) then {
    [FUNC(releaseMines), [_vehicle], DUKE_RELEASE_DELAY] call CBA_fnc_waitAndExecute;
};

// The DUKE itself was switched, or a hit or a setting switched it off. A destroyed vehicle has nobody to tell
if (_alive && {_wantEnabled != _enabled}) then {
    private _reason = ["", ["damage", "disabled"] select !GVAR(enableDuke)] select (_vehicle getVariable [DUKE_STATE_VAR, false]);

    [_vehicle, SYSTEM_NAME, _wantEnabled, _reason] call EFUNC(common,notifyState);
};

if (_alive && {_wantRadius != _radius}) exitWith {
    // Crows has no way to change the radii of a jammer, so replace it
    [CROWS_EVENT_REMOVE_JAMMER, [netId _vehicle, true]] call CBA_fnc_localEvent;
    [_vehicle, _wantEnabled, _wantRadius] call EFUNC(common,addJammer);
};

if (_wantEnabled != _enabled) then {
    _vehicle setVariable [QEGVAR(common,jammerState), [_wantEnabled, _radius]];
    [CROWS_EVENT_TOGGLE_JAMMER, [netId _vehicle, _wantEnabled]] call CBA_fnc_localEvent;
};
