#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Module handler for "Set as Wi-Fi Jammer". Registers the synced object, or a Crows_dataterminal spawned at the module if
 * none is synced (like the jammer module of Crows), as a Wi-Fi jammer, see fnc_registerWifiJammer.
 *
 * Arguments:
 * Arma 3 Module Function Parameters
 * https://community.bistudio.com/wiki/Modules#Configuring_the_Module_Function
 *
 * Return Value:
 * True <BOOL>
 *
 * Public: No
 */

params [
    ["_logic", objNull, [objNull]],
    ["_units", [], [[]]],
    ["_activated", true, [true]]
];

if (!_activated) exitWith {true};

private _unit = objNull;

if (count _units < 1) then {
    _unit = createVehicle ["Crows_dataterminal", ASLToAGL getPosASL _logic, [], 0, "NONE"];

    ["zen_common_addObjects", [[_unit], objNull]] call CBA_fnc_serverEvent;
} else {
    _unit = _units select 0;
};

private _radEffective = _logic getVariable [QGVAR(addWifiJammer_effectiveRadius), WIFI_JAM_DEFAULT_EFFECTIVE_RADIUS];
private _radFalloff = _logic getVariable [QGVAR(addWifiJammer_falloffRadius), WIFI_JAM_DEFAULT_FALLOFF_RADIUS];
private _frequency = _logic getVariable [QGVAR(addWifiJammer_frequency), WIFI_JAM_DEFAULT_FREQUENCY];
private _isActiveAtMissionStart = _logic getVariable [QGVAR(addWifiJammer_isActiveAtMissionStart), true];

[_unit, _radEffective, _radFalloff, _frequency, _isActiveAtMissionStart] call FUNC(registerWifiJammer);

true
