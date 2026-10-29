#include "..\script_component.hpp"
/*
 * Author: Andx
 * Switches the DUKE of a vehicle: the public state, the Crows radio jammer and the mine jamming.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: DUKE on <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true] call ewc_compat_cup_fnc_setJammer
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_enabled", false, [false]]];

private _key = netId _vehicle;

_vehicle setVariable [QGVAR(dukeOn), _enabled, true];

if (_enabled) then {
    if !(_key in GVAR(active)) then {
        GVAR(active) set [_key, []];
    };

    if (GVAR(loopHandle) < 0) then {
        GVAR(loopHandle) = [LINKFUNC(jamLoop), LOOP_INTERVAL] call CBA_fnc_addPerFrameHandler;
    };
} else {
    [_key] call FUNC(releaseMines);
    GVAR(active) deleteAt _key;
};

// A dead vehicle's jammer is removed by Crows
if (!alive _vehicle) exitWith {};

private _state = _vehicle getVariable [QEGVAR(main,jammerState), []];

if (_state isEqualTo []) exitWith {};

_state params ["_wasEnabled", "_radius"];

if (_radius != (_vehicle call FUNC(getRadius))) exitWith {
    // Crows has no way to change the radii of a jammer, so replace it
    [CROWS_EVENT_REMOVE_JAMMER, [netId _vehicle, true]] call CBA_fnc_localEvent;
    [_vehicle, _enabled] call FUNC(registerJammer);
};

if (_enabled != _wasEnabled) then {
    _vehicle setVariable [QEGVAR(main,jammerState), [_enabled, _radius]];
    [CROWS_EVENT_TOGGLE_JAMMER, [netId _vehicle, _enabled]] call CBA_fnc_localEvent;
};
