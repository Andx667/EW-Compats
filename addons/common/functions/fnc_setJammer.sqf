#include "..\script_component.hpp"
/*
 * Author: Andx
 * Brings the Crows jammer of a vehicle in line with the wanted state. Crows has no way to change the radii or the
 * capabilities of a jammer, so a changed radius or changed capabilities replace it (removed and registered again
 * by fnc_addJammer), otherwise it is only switched on or off. A vehicle is registered (fnc_addJammer) when its
 * jammer is switched on for the first time: every registration makes Crows send its whole jammer list to every
 * machine, so a mission with many vehicles would not want that for all of them at the start. Switching an
 * unregistered vehicle off does nothing.
 * SERVER ONLY.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Jammer enabled <BOOL> (default: false)
 * 2: Radius in m, negative to keep the registered one <NUMBER> (default: -1)
 * 3: Falloff factor of a replaced jammer, negative for the one of the entry <NUMBER> (default: -1)
 * 4: Crows capabilities, empty to keep the registered ones <ARRAY> (default: [])
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true, 250] call ewc_common_fnc_setJammer
 *
 * Public: Yes
 */

params [["_vehicle", objNull, [objNull]], ["_enabled", false, [false]], ["_radius", -1, [0]], ["_falloffFactor", -1, [0]], ["_capabilities", [], [[]]]];

if (isNull _vehicle || {!isServer}) exitWith {};

private _state = _vehicle getVariable [QGVAR(jammerState), []];

if (_state isEqualTo []) exitWith {
    if (!_enabled) exitWith {};

    // Editor-placed vehicles are switched before Crows has registered its server event handlers
    if (CBA_missionTime <= 0) exitWith {
        [{CBA_missionTime > 0}, {_this call FUNC(setJammer)}, [_vehicle, _enabled, _radius, _falloffFactor, _capabilities]] call CBA_fnc_waitUntilAndExecute;
    };

    [_vehicle, true, _radius, _falloffFactor, _capabilities] call FUNC(addJammer);
};

_state params ["_wasEnabled", "_registeredRadius"];

private _registeredCapabilities = _vehicle getVariable [QGVAR(jammerCapabilities), []];

if (_radius < 0) then {
    _radius = _registeredRadius;
};

if (_radius != _registeredRadius || {_capabilities isNotEqualTo [] && {_capabilities isNotEqualTo _registeredCapabilities}}) exitWith {
    [CROWS_EVENT_REMOVE_JAMMER, [netId _vehicle, true]] call CBA_fnc_localEvent;
    [_vehicle, _enabled, _radius, _falloffFactor, _capabilities] call FUNC(addJammer);
};

if (_enabled != _wasEnabled) then {
    _vehicle setVariable [QGVAR(jammerState), [_enabled, _registeredRadius]];
    [CROWS_EVENT_TOGGLE_JAMMER, [netId _vehicle, _enabled]] call CBA_fnc_localEvent;
};
