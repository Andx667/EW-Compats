#include "..\script_component.hpp"
/*
 * Author: Andx
 * Brings the Crows jammer of an R-142N in line with its mast and the settings: on with the mast deployed, the radius
 * and the jammed signals from the settings.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_compat_rhs_afrf_fnc_syncJammer
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

private _state = _vehicle getVariable QEGVAR(common,jammerState);

if (isNull _vehicle || {isNil "_state"} || {!alive _vehicle}) exitWith {};

_state params ["_enabled", "_radius"];

private _capabilities = [];

if (GVAR(jamRadio)) then {
    _capabilities pushBack CROWS_CAPABILITY_RADIO;
};

if (GVAR(jamDrones)) then {
    _capabilities pushBack CROWS_CAPABILITY_DRONE;
};

private _mastUp = (_vehicle getVariable [QGVAR(mastWanted), false]) && {_vehicle doorPhase MAST_SOURCE >= MAST_DEPLOYED_PHASE};
private _wantEnabled = GVAR(enable) && {_capabilities isNotEqualTo []} && {_mastUp};

// A mast folded by the crew needs no reason, a setting that keeps a deployed mast silent does
if (_wantEnabled != _enabled) then {
    [_vehicle, SYSTEM_NAME, _wantEnabled, ["", "disabled"] select _mastUp] call EFUNC(common,notifyState);
};

// Switches the jammer, or replaces it for another radius or other jammed signals. That is only needed once it is on
[_vehicle, _wantEnabled, [-1, GVAR(radius)] select _wantEnabled, -1, [[], _capabilities] select _wantEnabled] call EFUNC(common,setJammer);
