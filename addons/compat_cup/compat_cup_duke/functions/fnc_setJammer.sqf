#include "..\script_component.hpp"
/*
 * Author: Andx
 * Switches the DUKE of a vehicle: the public state, the Crows radio jammer and the mine jamming.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: DUKE on <BOOL>
 * 2: Why it is switched off by itself, see fnc_getBlockReason <STRING> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true] call ewc_compat_cup_fnc_duke_setJammer
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_enabled", false, [false]], ["_reason", "", [""]]];

private _key = netId _vehicle;

private _wasOn = _vehicle getVariable [QGVAR(duke_on), false];

_vehicle setVariable [QGVAR(duke_on), _enabled, true];

// Not for a jammer that only gets another radius
if (_enabled != _wasOn) then {
    [_vehicle, SYSTEM_NAME, _enabled, _reason] call EFUNC(common,notifyState);
};

if (_enabled) then {
    if !(_key in GVAR(duke_active)) then {
        GVAR(duke_active) set [_key, []];
    };

    if (GVAR(duke_loopHandle) < 0) then {
        GVAR(duke_loopHandle) = [LINKFUNC(duke_jamLoop), LOOP_INTERVAL] call CBA_fnc_addPerFrameHandler;
    };
} else {
    [_key] call FUNC(duke_releaseMines);
    GVAR(duke_active) deleteAt _key;
};

// A dead vehicle's jammer is removed by Crows
if (!alive _vehicle) exitWith {};

private _state = _vehicle getVariable [QEGVAR(common,jammerState), []];

if (_state isEqualTo []) exitWith {};

_state params ["_wasEnabled", "_radius"];

if (_radius != (_vehicle call FUNC(duke_getRadius))) exitWith {
    // Crows has no way to change the radii of a jammer, so replace it
    [CROWS_EVENT_REMOVE_JAMMER, [netId _vehicle, true]] call CBA_fnc_localEvent;
    [_vehicle, _enabled] call FUNC(duke_registerJammer);
};

if (_enabled != _wasEnabled) then {
    _vehicle setVariable [QEGVAR(common,jammerState), [_enabled, _radius]];
    [CROWS_EVENT_TOGGLE_JAMMER, [netId _vehicle, _enabled]] call CBA_fnc_localEvent;
};
