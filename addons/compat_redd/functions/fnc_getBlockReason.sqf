#include "..\script_component.hpp"
/*
 * Author: Andx
 * Returns why the Hummel of a vehicle cannot be on: disabled in the settings, vehicle destroyed or engine stopped.
 * fnc_canActivate is true exactly when there is no reason.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Reason, the end of the string ewc_common_reason_<reason>, "dead" without a text of its own, or "" if the Hummel can be on <STRING>
 *
 * Example:
 * [_vehicle] call ewc_compat_redd_fnc_getBlockReason
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

if (!GVAR(enable)) exitWith {"disabled"};
if (!alive _vehicle) exitWith {"dead"};
if (!isEngineOn _vehicle) exitWith {"engine"};

""
