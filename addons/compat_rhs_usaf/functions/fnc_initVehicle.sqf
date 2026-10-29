#include "..\script_component.hpp"
/*
 * Author: Andx
 * Prepares a vehicle with a DUKE so its damage is followed by the Crows radio jammer. The jammer itself
 * is registered by the registry (CfgEWC >> Jammers >> RHS_DUKE).
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Class name of the registry entry of the vehicle <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "RHS_DUKE"] call ewc_compat_rhs_usaf_fnc_initVehicle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_entry", "", [""]]];

if (_entry isNotEqualTo "RHS_DUKE") exitWith {};

// The Dammaged EH only fires where the vehicle is local, so it has to exist on every machine
_vehicle addEventHandler ["Dammaged", {_this call FUNC(onDammaged)}];
