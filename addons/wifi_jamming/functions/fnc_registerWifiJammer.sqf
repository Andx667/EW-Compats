#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Registers an object as a Wi-Fi jammer: a Crows Electronic Warfare jammer tagged with the Wi-Fi capability. Shared by the
 * module of the editor (fnc_addWifiJammer) and the one of Zeus (fnc_addWifiJammerZeus). Crows does not know the tag and
 * carries it along, so it gives Zeus markers, switching on and off by action and JIP sync for free.
 *
 * Arguments:
 * 0: Jammer object <OBJECT>
 * 1: Effective radius in m <NUMBER> (default: WIFI_JAM_DEFAULT_EFFECTIVE_RADIUS)
 * 2: Falloff radius in m <NUMBER> (default: WIFI_JAM_DEFAULT_FALLOFF_RADIUS)
 * 3: Spectrum frequency in MHz <NUMBER> (default: WIFI_JAM_DEFAULT_FREQUENCY)
 * 4: Jammer is on <BOOL> (default: true)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_terminal, 100, 100, 915, true] call ewc_wifi_jamming_fnc_registerWifiJammer
 *
 * Public: No
 */

params [
    ["_unit", objNull, [objNull]],
    ["_radEffective", WIFI_JAM_DEFAULT_EFFECTIVE_RADIUS, [0]],
    ["_radFalloff", WIFI_JAM_DEFAULT_FALLOFF_RADIUS, [0]],
    ["_frequency", WIFI_JAM_DEFAULT_FREQUENCY, [0]],
    ["_enabled", true, [true]]
];

if (isNull _unit) exitWith {};

// The Zeus dialog clamps these with sliders, the Edit fields of the editor module do not. A falloff of 0 is a hard edge
_radEffective = 0 max _radEffective min WIFI_JAM_MAX_RADIUS;
_radFalloff = 0 max _radFalloff min WIFI_JAM_MAX_RADIUS;
_frequency = WIFI_JAM_MIN_FREQUENCY max _frequency min WIFI_JAM_MAX_FREQUENCY;

// Public, because the server reads it when it adds the Spectrum signal and the jammer can come from a Zeus machine
_unit setVariable [QGVAR(frequency), _frequency, true];

// Crows registers its addJammer handler in its postInit, and module functions can run before that. A server event without
// a handler is dropped silently, and CBA_missionTime only advances once every postInit has run
[{CBA_missionTime > 0}, {
    [CROWSEW_ADD_JAMMER_EVENT, _this] call CBA_fnc_serverEvent;
}, [_unit, _radFalloff, _radEffective, _enabled, [WIFI_JAM_CAP]]] call CBA_fnc_waitUntilAndExecute;
