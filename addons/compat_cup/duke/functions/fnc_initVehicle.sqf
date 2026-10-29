#include "..\script_component.hpp"
/*
 * Author: Andx
 * Prepares a vehicle with a CUP DUKE antenna: scroll wheel actions on every machine with an interface and, on the server,
 * a disabled Crows radio jammer.
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
    [_vehicle, SYSTEM_DUKE] call FUNC(addActions);
};

if (!isServer) exitWith {};

// Editor-placed vehicles initialise before Crows has registered its server event handlers
[{CBA_missionTime > 0}, LINKFUNC(duke_registerJammer), [_vehicle]] call CBA_fnc_waitUntilAndExecute;
