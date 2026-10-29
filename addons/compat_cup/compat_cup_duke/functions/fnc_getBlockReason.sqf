#include "..\script_component.hpp"
/*
 * Author: Andx
 * Returns why the DUKE of a vehicle cannot be on: disabled in the settings, vehicle destroyed, no antenna shown or
 * engine stopped. fnc_canActivate is true exactly when there is no reason.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Reason, the end of the string ewc_common_reason_<reason>, "dead" without a text of its own, or "" if the DUKE can be on <STRING>
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_duke_getBlockReason
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

if (!GVAR(duke_enable)) exitWith {"disabled"};
if (!alive _vehicle) exitWith {"dead"};
if ((_vehicle call FUNC(duke_getRangeScale)) == 0) exitWith {"antenna"};
if (!isEngineOn _vehicle) exitWith {"engine"};

""
