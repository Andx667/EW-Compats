#include "..\script_component.hpp"
/*
 * Author: Andx
 * Prepares a GAZ-66 (R-142N) so deploying and folding its mast switches the Crows jammer. The jammer itself
 * is registered by the registry (CfgEWC >> Jammers >> RHS_R142N).
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Class name of the registry entry of the vehicle <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "RHS_R142N"] call ewc_compat_rhs_afrf_fnc_initVehicle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_entry", "", [""]]];

if (_entry isNotEqualTo "RHS_R142N") exitWith {};

// RHS calls the functions of this list at the end of its mast script, wherever the mast is deployed from (action,
// animation, editor attribute). The script runs on one machine only and the list is not public, so it is set everywhere
private _hooks = _vehicle getVariable [RHS_DEPLOY_HOOK_VAR, []];
_hooks pushBackUnique QFUNC(onDeploy);
_vehicle setVariable [RHS_DEPLOY_HOOK_VAR, _hooks];

if (!isServer) exitWith {};

// A mast deployed in the editor is up before the jammer exists. Wait for the registration of ewc_common. A vehicle that
// is deleted meanwhile, or never gets registered, ends the wait instead of being checked every frame
[{isNull _this || {!isNil {_this getVariable QEGVAR(common,jammerState)}}}, {
    if (isNull _this) exitWith {};

    [QGVAR(mastToggled), [_this, _this doorPhase MAST_SOURCE > 0.5]] call CBA_fnc_serverEvent;
}, _vehicle, WAIT_REGISTRATION_TIMEOUT] call CBA_fnc_waitUntilAndExecute;
