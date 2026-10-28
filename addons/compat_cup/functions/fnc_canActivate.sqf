#include "..\script_component.hpp"
/*
 * Author: Andx
 * Checks if a system of a vehicle can be switched on: system enabled in the settings, vehicle alive,
 * at least one antenna shown and, if required, engine running.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: System, "duke" or "boomerang" <STRING> (default: "duke")
 *
 * Return Value:
 * Can be switched on <BOOL>
 *
 * Example:
 * [_vehicle, "boomerang"] call ewc_compat_cup_fnc_canActivate
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_system", SYSTEM_DUKE, [""]]];

private _isDuke = _system == SYSTEM_DUKE;

([GVAR(enableBoomerang), GVAR(enableDuke)] select _isDuke)
    && {alive _vehicle}
    && {
        if (_isDuke) then {
            (_vehicle call FUNC(getRangeScale)) > 0
        } else {
            [_vehicle, _system] call FUNC(isShown)
        }
    }
    && {!GVAR(requireEngine) || {isEngineOn _vehicle}}
