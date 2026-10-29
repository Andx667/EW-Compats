#include "..\script_component.hpp"
/*
 * Author: Andx
 * Disables the IEDs in range of an active DUKE and frees those that left the range.
 * Only IEDs are jammed (PipeBombBase like the Dingo CG13 does, and the IEDs of CUP), not mines.
 *
 * Arguments:
 * 0: Net ID of the vehicle <STRING>
 * 1: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [netId _vehicle, _vehicle] call ewc_compat_cup_fnc_duke_updateMines
 *
 * Public: No
 */

params [["_key", "", [""]], ["_vehicle", objNull, [objNull]]];

private _old = GVAR(duke_active) getOrDefault [_key, []];
private _radius = _vehicle call FUNC(duke_getRadius);

// Let the engine search around the vehicle, instead of going through all mines of the mission every second.
// The search is flat, like the area check it replaces, and unsorted, as the order is of no use here
private _inRange = nearestMines [_vehicle, JAMMED_MINE_CLASSES, _radius, false, true];

private _kept = _old arrayIntersect _inRange;
// Mines that are already disabled belong to another jammer, which frees them itself
private _added = (_inRange - _old) select {simulationEnabled _x};

// Another jammer may have freed a mine this one still holds
{
    if (simulationEnabled _x) then {
        _x enableSimulationGlobal false;
    };
} forEach (_kept + _added);

[_key, _old - _inRange] call FUNC(duke_releaseMines);

GVAR(duke_active) set [_key, _kept + _added];
