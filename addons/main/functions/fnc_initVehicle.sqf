#include "..\script_component.hpp"
/*
 * Author: Andx
 * Prepares a vehicle that is in CfgEWC >> Jammers: tells the compat addons about it and, on the server,
 * registers it as a disabled radio jammer in Crows Electronic Warfare.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_main_fnc_initVehicle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

private _config = [_vehicle] call FUNC(getJammerConfig);

if (isNull _config) exitWith {};

private _enableVariable = getText (_config >> "enableVariable");

if (_enableVariable isNotEqualTo "" && {!(missionNamespace getVariable [_enableVariable, true])}) exitWith {};

// For the parts that have to exist on every machine, like event handlers of the vehicle
[QGVAR(vehicleInit), [_vehicle, configName _config]] call CBA_fnc_localEvent;

if (!isServer) exitWith {};

// Editor-placed vehicles initialise before Crows has registered its server event handlers
[{CBA_missionTime > 0}, LINKFUNC(addJammer), [_vehicle]] call CBA_fnc_waitUntilAndExecute;
