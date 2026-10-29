#include "..\script_component.hpp"
/*
 * Author: Andx
 * Enables or disables the Crows radio jammer of a Dingo when its CG13 is switched.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: CG13 switched on <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true] call ewc_compat_bwa3_fnc_handleToggle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_enabled", false, [false]]];

if (isNull _vehicle || {isNil {_vehicle getVariable QEGVAR(main,jammerState)}}) exitWith {};

// With the CG13 disabled in the settings, the jammer stays off whatever the switch says
_enabled = _enabled && GVAR(enableCG13);

// Engine stop reports "off" even when the CG13 already is, avoid re-broadcasting the jammer list
if (_enabled isEqualTo (_vehicle getVariable [QGVAR(ecmEnabled), false])) exitWith {};

_vehicle setVariable [QGVAR(ecmEnabled), _enabled];

[CROWS_EVENT_TOGGLE_JAMMER, [netId _vehicle, _enabled]] call CBA_fnc_localEvent;
