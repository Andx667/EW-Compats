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
 * [_vehicle] call ewc_compat_rhs_fnc_syncJammer
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

private _state = _vehicle getVariable QEGVAR(main,jammerState);

if (isNull _vehicle || {isNil "_state"} || {!alive _vehicle}) exitWith {};

_state params ["_enabled", "_radius"];

private _damage1 = _vehicle getHitPointDamage "HitDuke1";
private _damage2 = _vehicle getHitPointDamage "HitDuke2";

private _wantEnabled = GVAR(enableDuke)
    && {_vehicle getVariable [DUKE_STATE_VAR, false]}
    && {!(_damage1 >= DUKE_BOTH_ANTENNAS_DESTROYED && {_damage2 >= DUKE_BOTH_ANTENNAS_DESTROYED})};
private _wantScale = [1, DUKE_SINGLE_ANTENNA_SCALE] select (_damage1 >= DUKE_ANTENNA_DESTROYED || {_damage2 >= DUKE_ANTENNA_DESTROYED});
private _wantRadius = getNumber (([_vehicle] call EFUNC(main,getJammerConfig)) >> "radius") * _wantScale;

if (_wantRadius != _radius) exitWith {
    // Crows has no way to change the radii of a jammer, so replace it
    [CROWS_EVENT_REMOVE_JAMMER, [netId _vehicle, true]] call CBA_fnc_localEvent;
    [_vehicle, _wantEnabled, _wantRadius] call EFUNC(main,addJammer);
};

if (_wantEnabled != _enabled) then {
    _vehicle setVariable [QEGVAR(main,jammerState), [_wantEnabled, _radius]];
    [CROWS_EVENT_TOGGLE_JAMMER, [netId _vehicle, _wantEnabled]] call CBA_fnc_localEvent;
};
