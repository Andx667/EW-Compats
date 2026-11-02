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
 * [netId _vehicle] call ewc_compat_cup_fnc_duke_releaseMines
 *
 * Public: No
 */

params [["_key", "", [""]], ["_mines", nil, [[]]]];

private _held = GVAR(duke_active) getOrDefault [_key, []];

if (isNil "_mines") then {
    _mines = _held;
    GVAR(duke_active) set [_key, []];
};

private _vehicle = objectFromNetId _key;

{
    if (!isNull _x && {!simulationEnabled _x}) then {
        _x enableSimulationGlobal true;

        // For missions that follow the IEDs: [IED, vehicle of the DUKE, null if it is gone], on the server
        [QEGVAR(common,iedReleased), [_x, _vehicle]] call CBA_fnc_localEvent;
    };
} forEach _mines;
