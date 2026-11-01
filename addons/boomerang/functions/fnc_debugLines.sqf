#include "..\script_component.hpp"
/*
 * Author: Andx
 * Lines about the Boomerang of a vehicle for the debug overlay of ewc_common: what blocks it, the lockout after the
 * weapons of the vehicle were fired and the speed limit.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Lines <ARRAY of STRING>
 *
 * Example:
 * [_vehicle] call ewc_boomerang_fnc_debugLines
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

private _reason = [_vehicle] call FUNC(getBlockReason);
private _deaf = (_vehicle getVariable [QGVAR(deafUntil), 0]) - CBA_missionTime;

[
    format ["ready %1 | blocked by: %2", ["no", "YES"] select ([_vehicle] call FUNC(isReady)), ["none", _reason] select (_reason isNotEqualTo "")],
    format ["deaf %1 s | speed %2/%3 km/h", (0 max _deaf) toFixed 1, round speed _vehicle, BOOMERANG_MAX_SPEED]
]
