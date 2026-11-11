#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Zeus module "Remove Wi-Fi Jammer": removes the jammer from the selected object. Only Wi-Fi jammers, the radio and drone
 * jammers of Crows are removed with its own module. The Spectrum signal goes with the jammer, the object itself stays.
 *
 * Arguments:
 * 0: Position the module was placed at, ASL <ARRAY>
 * 1: Object the module was placed on <OBJECT> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [getPosASL player, _terminal] call ewc_wifi_jamming_fnc_removeWifiJammerZeus
 *
 * Public: No
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_unit", objNull, [objNull]]];

private _capabilities = [];

// Crows only fills its jamMap on a machine once the first jammer update arrives
if (!isNull _unit) then {
    _capabilities = ((missionNamespace getVariable [CROWSEW_JAM_MAP_NAME, createHashMap]) getOrDefault [netId _unit, []]) param [4, []];
};

if !(WIFI_JAM_CAP in _capabilities) exitWith {
    hint LLSTRING(zeus_remove_error);
};

[CROWSEW_REMOVE_JAMMER_EVENT, [netId _unit]] call CBA_fnc_serverEvent;
