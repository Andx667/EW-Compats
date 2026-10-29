#include "..\script_component.hpp"
/*
 * Author: Andx
 * Prepares a Dingo with CG13 so the CG13 also stops the Crows radio jammer on engine stop. The jammer itself
 * is registered by the registry (CfgEWC >> Jammers >> BWA3_CG13).
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Class name of the registry entry of the vehicle <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "BWA3_CG13"] call ewc_compat_bwa3_fnc_initVehicle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_entry", "", [""]]];

if (_entry isNotEqualTo "BWA3_CG13") exitWith {};

// The Engine EH only fires where the vehicle is local, so it has to exist on every machine.
// BWA3 switches the CG13 off on engine stop without any event we could listen to.
_vehicle addEventHandler ["Engine", {
    params ["_vehicle", "_engineState"];

    if (!_engineState) then {
        [QGVAR(ecmToggled), [_vehicle, false]] call CBA_fnc_serverEvent;
    };
}];
