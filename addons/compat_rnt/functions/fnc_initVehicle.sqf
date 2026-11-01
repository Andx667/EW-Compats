#include "..\script_component.hpp"
/*
 * Author: Andx
 * Prepares a Hummel: the switch actions of ewc_common on every machine with an interface and the event handlers that
 * switch the jammer off when the engine stops or the vehicle is destroyed. The jammer itself is registered by the
 * registry (CfgEWC >> Jammers >> RNT_HUMMEL).
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Class name of the registry entry of the vehicle <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "RNT_HUMMEL"] call ewc_compat_rnt_fnc_initVehicle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_entry", "", [""]]];

if (_entry isNotEqualTo "RNT_HUMMEL") exitWith {};

if (hasInterface) then {
    [_vehicle, SYSTEM_ID] call EFUNC(common,addSwitchActions);
};

// Both events only fire where the vehicle is local, so the handlers have to exist on every machine
_vehicle addEventHandler ["Engine", {
    params ["_vehicle", "_engineOn"];

    if (!_engineOn) then {
        [QGVAR(syncJammer), [_vehicle]] call CBA_fnc_serverEvent;
    };
}];

_vehicle addEventHandler ["Killed", {
    params ["_vehicle"];

    [QGVAR(syncJammer), [_vehicle]] call CBA_fnc_serverEvent;
}];
