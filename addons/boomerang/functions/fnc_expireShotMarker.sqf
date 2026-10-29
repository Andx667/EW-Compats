#include "..\script_component.hpp"
/*
 * Author: Andx
 * Removes the map marker of a detected shot once its time is up. A later report that was merged into the marker has
 * moved its expiry time, then the removal is only scheduled again for the time that is left.
 *
 * Arguments:
 * 0: Name of the marker <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ewc_boomerang_shot_1"] call ewc_boomerang_fnc_expireShotMarker
 *
 * Public: No
 */

params [["_marker", "", [""]]];

private _index = GVAR(shotMarkers) findIf {(_x select 0) isEqualTo _marker};

if (_index == -1) exitWith {};

private _left = ((GVAR(shotMarkers) select _index) select 2) - CBA_missionTime;

if (_left > MARKER_EXPIRY_TOLERANCE) exitWith {
    [LINKFUNC(expireShotMarker), _marker, _left] call CBA_fnc_waitAndExecute;
};

deleteMarkerLocal _marker;
GVAR(shotMarkers) deleteAt _index;
