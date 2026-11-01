#include "..\script_component.hpp"
/*
 * Author: Andx
 * Prepares a vehicle with a CUP DUKE antenna: scroll wheel actions on every machine with an interface. The Crows radio
 * jammer is registered when the DUKE is first switched on (ewc_common_fnc_setJammer).
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_duke_initVehicle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

if (([_vehicle, SYSTEM_DUKE] call FUNC(getSources)) isEqualTo []) exitWith {};

if (hasInterface) then {
    [_vehicle, SYSTEM_DUKE] call EFUNC(common,addSwitchActions);
};
