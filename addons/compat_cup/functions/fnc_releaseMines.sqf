#include "..\script_component.hpp"
/*
 * Author: Andx
 * Enables the simulation of mines a DUKE held disabled again.
 *
 * Arguments:
 * 0: Net ID of the vehicle <STRING>
 * 1: Mines to free, all it holds if not given <ARRAY> (default: nil)
 *
 * Return Value:
 * None
 *
 * Example:
 * [netId _vehicle] call ewc_compat_cup_fnc_releaseMines
 *
 * Public: No
 */

params [["_key", "", [""]], ["_mines", nil, [[]]]];

private _held = GVAR(active) getOrDefault [_key, []];

if (isNil "_mines") then {
    _mines = _held;
    GVAR(active) set [_key, []];
};

{
    if (!isNull _x && {!simulationEnabled _x}) then {
        _x enableSimulationGlobal true;
    };
} forEach _mines;
