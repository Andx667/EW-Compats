#include "..\script_component.hpp"
/*
 * Author: Andx
 * Prepares a vehicle that is in CfgEWC >> Jammers: tells the compat addons about it. The Crows jammer is registered
 * when it is first switched on (fnc_setJammer).
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_common_fnc_initVehicle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

private _config = [_vehicle] call FUNC(getJammerConfig);

if (isNull _config) exitWith {};

// For the parts that have to exist on every machine, like event handlers of the vehicle
[QGVAR(vehicleInit), [_vehicle, configName _config]] call CBA_fnc_localEvent;
