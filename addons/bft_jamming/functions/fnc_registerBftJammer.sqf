#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Registers an object as a BFT jammer: a Crows Electronic Warfare jammer tagged with the BFT capability of its type.
 * Shared by the module of the editor (fnc_addBftJammer) and the one of Zeus (fnc_addBftJammerZeus), see the first for
 * how Crows carries the tag and where the Spectrum signal comes from.
 *
 * Arguments:
 * 0: Jammer object <OBJECT>
 * 1: Jamming type, BFT_JAM_TYPE_BLACKOUT, _DRIFT or _MIXED <NUMBER> (default: BFT_JAM_TYPE_BLACKOUT)
 * 2: Effective radius in m <NUMBER> (default: BFT_JAM_DEFAULT_EFFECTIVE_RADIUS)
 * 3: Falloff radius in m <NUMBER> (default: BFT_JAM_DEFAULT_FALLOFF_RADIUS)
 * 4: Spectrum frequency in MHz <NUMBER> (default: BFT_JAM_DEFAULT_FREQUENCY)
 * 5: Jammer is on <BOOL> (default: true)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_terminal, BFT_JAM_TYPE_MIXED, 200, 400, 805, true] call ewc_bft_jamming_fnc_registerBftJammer
 *
 * Public: No
 */

params [
    ["_unit", objNull, [objNull]],
    ["_jamType", BFT_JAM_TYPE_BLACKOUT, [0]],
    ["_radEffective", BFT_JAM_DEFAULT_EFFECTIVE_RADIUS, [0]],
    ["_radFalloff", BFT_JAM_DEFAULT_FALLOFF_RADIUS, [0]],
    ["_frequency", BFT_JAM_DEFAULT_FREQUENCY, [0]],
    ["_enabled", true, [true]]
];

if (isNull _unit) exitWith {};

private _capabilities = [[BFT_JAM_CAP_BLACKOUT, BFT_JAM_CAP_DRIFT, BFT_JAM_CAP_MIXED] select _jamType];

// Public, because the server reads it when it adds the Spectrum signal and the jammer can come from a Zeus machine
_unit setVariable [QGVAR(frequency), _frequency, true];

// CrowsEW only registers its addJammer handler in its postInit, and module functions can run
// before that - a server event without a handler is dropped silently. CBA_missionTime only
// advances once every postInit has run (CrowsEW's own module works around this with a sleep).
[{CBA_missionTime > 0}, {
    [CROWSEW_ADD_JAMMER_EVENT, _this] call CBA_fnc_serverEvent;
}, [_unit, _radFalloff, _radEffective, _enabled, _capabilities]] call CBA_fnc_waitUntilAndExecute;
