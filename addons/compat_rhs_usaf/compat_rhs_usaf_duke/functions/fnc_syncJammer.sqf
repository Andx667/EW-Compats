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
 * [_vehicle] call ewc_compat_rhs_usaf_fnc_duke_syncJammer
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

// RHS only looks at a hidden antenna when the DUKE starts, fnc_vg switches a running DUKE off when it is hidden
private _hidden = DUKE_HIDE_SOURCES findIf {
    isClass (configOf _vehicle >> "AnimationSources" >> _x) && {_vehicle animationSourcePhase _x > 0.5}
} > -1;

private _wantEnabled = _alive
    && GVAR(enableDuke)
    && {!_hidden}
    && {_vehicle getVariable [DUKE_STATE_VAR, false]}
    && {!(_damage1 >= DUKE_BOTH_ANTENNAS_DESTROYED && {_damage2 >= DUKE_BOTH_ANTENNAS_DESTROYED})};
private _wantScale = [1, DUKE_SINGLE_ANTENNA_SCALE] select (_damage1 >= DUKE_ANTENNA_DESTROYED || {_damage2 >= DUKE_ANTENNA_DESTROYED});
private _wantRadius = getNumber (([_vehicle] call EFUNC(common,getJammerConfig)) >> "radius") * _wantScale;

// rhs_duke.sqf frees its IEDs from the machine of the gunner, which only works for local ones. Free them from here
if (_enabled && {!_wantEnabled}) then {
    [FUNC(duke_releaseMines), [_vehicle], DUKE_RELEASE_DELAY] call CBA_fnc_waitAndExecute;
};

// The DUKE itself was switched, or a hit or a setting switched it off. A destroyed vehicle has nobody to tell
if (_alive && {_wantEnabled != _enabled}) then {
    private _reason = if (_hidden) then {
        "antenna"
    } else {
        ["", ["damage", "disabled"] select !GVAR(enableDuke)] select (_vehicle getVariable [DUKE_STATE_VAR, false])
    };

    [_vehicle, SYSTEM_NAME, _wantEnabled, _reason] call EFUNC(common,notifyState);
};

// Switches the jammer, or replaces it if the antennas changed the radius. A destroyed vehicle keeps its radius
[_vehicle, _wantEnabled, [-1, _wantRadius] select _alive] call EFUNC(common,setJammer);
