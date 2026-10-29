#include "..\script_component.hpp"
/*
 * Author: Andx
 * The mast of an R-142N is deployed or folded. A folding mast stops the jammer at once, a deploying one starts it
 * when the mast is up.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Mast is deployed <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true] call ewc_compat_rhs_afrf_fnc_handleDeploy
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_deployed", false, [false]]];

if (isNull _vehicle || {isNil {_vehicle getVariable QEGVAR(common,jammerState)}}) exitWith {};

_vehicle setVariable [QGVAR(mastWanted), _deployed];

// The jammer works with the mast up, not while it is still being raised. Folding, or a mast folded again meanwhile, ends the wait
[{
    params ["_vehicle"];

    !alive _vehicle || {!(_vehicle getVariable [QGVAR(mastWanted), false])} || {_vehicle doorPhase MAST_SOURCE >= MAST_DEPLOYED_PHASE}
}, {
    [QGVAR(syncJammer), _this] call CBA_fnc_serverEvent;
}, [_vehicle], MAST_DEPLOY_TIMEOUT, {
    [QGVAR(syncJammer), _this] call CBA_fnc_serverEvent;
}] call CBA_fnc_waitUntilAndExecute;
