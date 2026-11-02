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

    if (WIFI_JAM_CAP in _capabilities && {!isNull _unit}) then {
        private _hasBeacon = (CROWSEW_BEACONS findIf {(_x select 0) isEqualTo _unit && {(_x select 3) == WIFI_JAM_SPECTRUM_TYPE}}) != -1;

        if (_enabled && !_hasBeacon) then {
            private _frequency = _unit getVariable [QGVAR(frequency), WIFI_JAM_DEFAULT_FREQUENCY];

            [CROWSEW_ADD_BEACON_EVENT, [_unit, _frequency, _radFalloff + _radEffective, WIFI_JAM_SPECTRUM_TYPE]] call CBA_fnc_localEvent;
        };

        if (!_enabled && _hasBeacon) then {
            [CROWSEW_REMOVE_BEACON_EVENT, [_unit, WIFI_JAM_SPECTRUM_TYPE]] call CBA_fnc_localEvent;
        };
    };
} forEach _jamMap;
