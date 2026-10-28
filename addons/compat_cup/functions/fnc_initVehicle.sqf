#include "..\script_component.hpp"
/*
 * Author: Andx
 * Prepares a vehicle with a CUP DUKE or Boomerang antenna: scroll wheel actions on every machine and, on the server,
 * a disabled Crows radio jammer for the DUKE. For the Boomerang, the weapons of the vehicle are watched.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_initVehicle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

private _hasDuke = ([_vehicle, SYSTEM_DUKE] call FUNC(getSources)) isNotEqualTo [];
private _hasBoomerang = ([_vehicle, SYSTEM_BOOMERANG] call FUNC(getSources)) isNotEqualTo [];

if (!_hasDuke && {!_hasBoomerang}) exitWith {};

if (hasInterface) then {
    if (_hasDuke) then {
        [_vehicle, SYSTEM_DUKE] call FUNC(addActions);
    };

    if (_hasBoomerang) then {
        [_vehicle, SYSTEM_BOOMERANG] call FUNC(addActions);
    };
};

if (_hasBoomerang) then {
    // The Fired EH only fires where the weapon is local, so it has to exist on every machine
    _vehicle addEventHandler ["Fired", {
        params ["_vehicle", "", "", "", "_ammo"];

        // Smoke launchers and flares are no weapons the sensor hears
        if (_ammo isKindOf "SmokeLauncherAmmo" || {_ammo isKindOf "CMflareAmmo"}) exitWith {};

        // A burst is one event for the server
        if (CBA_missionTime - (_vehicle getVariable [QGVAR(lastFired), -1]) < 1) exitWith {};

        _vehicle setVariable [QGVAR(lastFired), CBA_missionTime];
        [QGVAR(vehicleFired), [_vehicle]] call CBA_fnc_serverEvent;
    }];
};

if (!_hasDuke || {!isServer}) exitWith {};

// Editor-placed vehicles initialise before Crows has registered its server event handlers
[{CBA_missionTime > 0}, LINKFUNC(registerJammer), [_vehicle]] call CBA_fnc_waitUntilAndExecute;
