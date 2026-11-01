#include "..\script_component.hpp"
/*
 * Author: Andx
 * Registers a vehicle as radio jammer in Crows Electronic Warfare. The full jamming radius, the falloff and the
 * capabilities default to the entry of the vehicle in CfgEWC >> Jammers.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Jammer enabled <BOOL> (default: false)
 * 2: Radius in m, negative for the one of the entry <NUMBER> (default: -1)
 * 3: Falloff factor, negative for the one of the entry <NUMBER> (default: -1)
 * 4: Crows capabilities, empty for the ones of the entry <ARRAY> (default: [])
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, false, 25] call ewc_common_fnc_addJammer
 *
 * Public: Yes
 */

params [["_vehicle", objNull, [objNull]], ["_enabled", false, [false]], ["_radius", -1, [0]], ["_falloffFactor", -1, [0]], ["_capabilities", [], [[]]]];

if (isNull _vehicle || {!isServer}) exitWith {};

private _config = [_vehicle] call FUNC(getJammerConfig);

if (_radius < 0) then {
    _radius = getNumber (_config >> "radius");
};

if (_falloffFactor < 0) then {
    _falloffFactor = [getNumber (_config >> "falloffFactor"), DEFAULT_FALLOFF_FACTOR] select !isNumber (_config >> "falloffFactor");
};

if (_capabilities isEqualTo []) then {
    _capabilities = [[CROWS_CAPABILITY_RADIO], getArray (_config >> "capabilities")] select isArray (_config >> "capabilities");
};

// What is registered, so fnc_setJammer can tell whether the radius or the capabilities have to change
_vehicle setVariable [QGVAR(jammerState), [_enabled, _radius]];
_vehicle setVariable [QGVAR(jammerCapabilities), _capabilities];

[CROWS_EVENT_ADD_JAMMER, [
    _vehicle,
    _falloffFactor * _radius,
    _radius,
    _enabled,
    _capabilities
]] call CBA_fnc_localEvent;

// On a hosted server Crows adds its actions after it broadcasts the jammer list, so the cleanup on
// that update (fnc_removeCrowsActions) runs too early. The event above is handled synchronously
if (hasInterface) then {
    _vehicle call FUNC(clearCrowsActions);
};
