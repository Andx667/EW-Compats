#include "..\script_component.hpp"
/*
 * Author: Andx
 * Hook of the mast script of the R-142N (rhs_fnc_gaz66_radioDeploy). Tells the server that the mast is deployed or folded.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Phase, 1 deploys and 0 folds the mast <NUMBER>
 * 2: Instant, ignored <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, 1, false] call ewc_compat_rhs_afrf_fnc_onDeploy
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_phase", 0, [0]]];

[QGVAR(mastToggled), [_vehicle, _phase isEqualTo 1]] call CBA_fnc_serverEvent;
