#include "..\script_component.hpp"
/*
 * Author: Andy
 *
 * SERVER ONLY. Handler of CrowsEW's local events "crowsEW_main_jammerAdded" and
 * "crowsEW_main_jammerToggled" (raised for ANY jammer, not just ours). Keeps the "sweep_bft"
 * Spectrum beacon of that one jammer in sync with its enabled state, so an add or toggle no
 * longer walks the whole jamMap.
 *
 * This exists because CrowsEW's own toggle handler (fnc_toggleJammerServer.sqf) only knows
 * how to re-add beacons for its own "VoiceCommsJammer"/"DroneJammer" capabilities on toggle-on -
 * it would silently drop an unknown capability's beacon forever after one toggle-off/on cycle.
 * Full jammer removal already strips ALL beacon types unconditionally on CrowsEW's side
 * (fnc_removeJammerServer.sqf), so nothing extra is needed for that case.
 *
 * The current state is read straight from crowsEW_spectrum_beacons rather than tracked here, so
 * we only call add/remove when it actually has to change (addBeacon has no built-in
 * deduplication).
 *
 * Arguments:
 * 0: Net ID of the jammer <STRING>
 * 1: Its jamMap entry, [unit, radFalloff, radEffective, enabled, capabilities] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_netId", "", [""]], ["_entry", [], [[]]]];

if (!isServer || {_entry isEqualTo []}) exitWith {};

_entry params ["_unit", "_radFalloff", "_radEffective", "_enabled", "_capabilities"];

if (isNull _unit) exitWith {};

private _isBftJammer = (BFT_JAM_CAP_BLACKOUT in _capabilities) || (BFT_JAM_CAP_DRIFT in _capabilities) || (BFT_JAM_CAP_MIXED in _capabilities) || (BFT_JAM_CAP_SPOOF in _capabilities);
private _hasBeacon = (CROWSEW_BEACONS findIf {(_x select 0) isEqualTo _unit && {(_x select 3) == BFT_JAM_SPECTRUM_TYPE}}) != -1;

// Another jammer module on the same object (Wi-Fi jammer) replaces the jammer under the same net ID, and CrowsEW
// leaves our beacon
if (!_isBftJammer) exitWith {
    if (_hasBeacon) then {
        [CROWSEW_REMOVE_BEACON_EVENT, [_unit, BFT_JAM_SPECTRUM_TYPE]] call CBA_fnc_localEvent;
    };
};

if (_enabled && !_hasBeacon) then {
    private _frequency = _unit getVariable [QGVAR(frequency), BFT_JAM_DEFAULT_FREQUENCY];
    [CROWSEW_ADD_BEACON_EVENT, [_unit, _frequency, _radFalloff + _radEffective, BFT_JAM_SPECTRUM_TYPE]] call CBA_fnc_localEvent;
};
if (!_enabled && _hasBeacon) then {
    [CROWSEW_REMOVE_BEACON_EVENT, [_unit, BFT_JAM_SPECTRUM_TYPE]] call CBA_fnc_localEvent;
};
