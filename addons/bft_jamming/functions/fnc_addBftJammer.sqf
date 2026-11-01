#include "..\script_component.hpp"
/*
 * Author: Andy
 *
 * Module handler for "Set as BFT Jammer". Registers the synced object (or a spawned
 * Crows_dataterminal, if none is synced - mirrors CrowsEW's own "Set as Jammer" module)
 * as a CrowsEW jammer via CrowsEW's own public event, tagged with a BFT-only capability.
 * CrowsEW doesn't recognize the tag, so it just carries it along in its jamMap/broadcasts -
 * this is the entire integration surface, nothing in CrowsEW is modified.
 *
 * The Spectrum beacon (detectability) is not added here - fnc_onUpdateJammersServer.sqf
 * reconciles it from crowsEW_main_updateJammers, which also fires once this event completes.
 * It reads its frequency back off the jammer object (QGVAR(frequency)), set below, since
 * CrowsEW's jamMap entry format has no room for it.
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
    private _posAGL = ASLToAGL getPosASL _logic;
    _unit = createVehicle ["Crows_dataterminal", _posAGL, [], 0, "NONE"];
    ["zen_common_addObjects", [[_unit], objNull]] call CBA_fnc_serverEvent;
} else {
    _unit = _units select 0;
};

private _jamType = _logic getVariable [QGVAR(addBftJammer_jamType), BFT_JAM_TYPE_BLACKOUT];
private _radEffective = _logic getVariable [QGVAR(addBftJammer_effectiveRadius), BFT_JAM_DEFAULT_EFFECTIVE_RADIUS];
private _radFalloff = _logic getVariable [QGVAR(addBftJammer_falloffRadius), BFT_JAM_DEFAULT_FALLOFF_RADIUS];
private _frequency = _logic getVariable [QGVAR(addBftJammer_frequency), BFT_JAM_DEFAULT_FREQUENCY];
private _isActiveAtMissionStart = _logic getVariable [QGVAR(addBftJammer_isActiveAtMissionStart), true];

[_unit, _jamType, _radEffective, _radFalloff, _frequency, _isActiveAtMissionStart] call FUNC(registerBftJammer);

true
