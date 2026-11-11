#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * SERVER ONLY. Listens to the "crowsEW_main_updateJammers" broadcast of Crows (fired after every add, toggle and removal of
 * ANY jammer) and, for every Wi-Fi jammer:
 * - keeps its "sweep_wifi" Spectrum signal in line with its on/off state. The toggle of Crows only re-adds the signals of
 *   its own radio and drone jammers, so ours would be dropped for good after one switch off and on. A removal already
 *   strips every signal of the jammer on the side of Crows
 *
 * The state of the signal is read from crowsEW_spectrum_beacons instead of tracked here, so a signal is only added or
 * removed when it has to change (addBeacon does not check for doubles), and one that something else removed comes back.
 *
 * Arguments:
 * 0: Jammer map of Crows, net ID -> [object, falloff radius, effective radius, enabled, capabilities] <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_jamMap", createHashMap, [createHashMap]]];

if (!isServer) exitWith {};

{
    _y params ["_unit", "_radFalloff", "_radEffective", "_enabled", "_capabilities"];

    // Another jammer module on the same object replaces the jammer under the same net ID, and Crows leaves our signal
    if (!(WIFI_JAM_CAP in _capabilities) && {!isNull _unit} && {CROWSEW_BEACONS findIf {(_x select 0) isEqualTo _unit && {(_x select 3) == WIFI_JAM_SPECTRUM_TYPE}} != -1}) then {
        [CROWSEW_REMOVE_BEACON_EVENT, [_unit, WIFI_JAM_SPECTRUM_TYPE]] call CBA_fnc_localEvent;
    };

    if (WIFI_JAM_CAP in _capabilities && {!isNull _unit}) then {
        private _frequency = _unit getVariable [QGVAR(frequency), WIFI_JAM_DEFAULT_FREQUENCY];
        private _range = _radFalloff + _radEffective;

        // Beacon layout of Crows: [object, frequency, range, type]
        private _beaconIndex = CROWSEW_BEACONS findIf {(_x select 0) isEqualTo _unit && {(_x select 3) == WIFI_JAM_SPECTRUM_TYPE}};
        private _hasBeacon = _beaconIndex != -1;

        // Adding the module again to the same object replaces the jammer, so the signal can be there with old values
        if (_hasBeacon && _enabled && {(CROWSEW_BEACONS select _beaconIndex) params ["", "_oldFrequency", "_oldRange"]; _oldFrequency != _frequency || _oldRange != _range}) then {
            [CROWSEW_REMOVE_BEACON_EVENT, [_unit, WIFI_JAM_SPECTRUM_TYPE]] call CBA_fnc_localEvent;
            _hasBeacon = false;
        };

        if (_enabled && !_hasBeacon) then {
            [CROWSEW_ADD_BEACON_EVENT, [_unit, _frequency, _range, WIFI_JAM_SPECTRUM_TYPE]] call CBA_fnc_localEvent;
        };

        if (!_enabled && _hasBeacon) then {
            [CROWSEW_REMOVE_BEACON_EVENT, [_unit, WIFI_JAM_SPECTRUM_TYPE]] call CBA_fnc_localEvent;
        };
    };
} forEach _jamMap;
