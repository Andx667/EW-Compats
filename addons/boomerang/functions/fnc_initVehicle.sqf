#include "..\script_component.hpp"
/*
 * Author: Andx
 * Prepares a vehicle with a Boomerang antenna: scroll wheel actions on every machine with an interface and a Fired
 * handler that deafens the sensor while the weapons of the vehicle are fired.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_boomerang_fnc_initVehicle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

if (([_vehicle] call FUNC(getSources)) isEqualTo []) exitWith {};

if (hasInterface) then {
    [_vehicle, "boomerang"] call EFUNC(common,addSwitchActions);
};

// The Fired EH only fires where the weapon is local, so it has to exist on every machine
_vehicle addEventHandler ["Fired", {
    params ["_vehicle", "", "", "", "_ammo"];

    // Smoke launchers and flares are no weapons the sensor hears
    private _ammoConfig = configFile >> "CfgAmmo";

    if (_ammo isKindOf ["SmokeLauncherAmmo", _ammoConfig] || {_ammo isKindOf ["CMflareAmmo", _ammoConfig]}) exitWith {};

    // A burst is one event for the server
    if (CBA_missionTime - (_vehicle getVariable [QGVAR(lastFired), -1]) < 1) exitWith {};

    _vehicle setVariable [QGVAR(lastFired), CBA_missionTime];
    [QGVAR(vehicleFired), [_vehicle]] call CBA_fnc_serverEvent;
}];
