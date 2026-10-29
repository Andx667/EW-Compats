#include "..\script_component.hpp"
/*
 * Author: Andx
 * Finds a marker of a detected shot that a new report is close enough to, so it can be merged into it instead of
 * adding another marker. Close enough is a fixed distance, or twice the range error of the Boomerang at the range of
 * the report, whichever is larger: the further away the shooter, the less exact the position, so repeated shots of one
 * shooter are spread over a wider area.
 *
 * Arguments:
 * 0: Markers, each [id, position, expiry time] <ARRAY>
 * 1: Estimated position of the shooter <ARRAY>
 * 2: Estimated range in meters <NUMBER>
 *
 * Return Value:
 * Index of the marker in the list, -1 if there is none <NUMBER>
 *
 * Example:
 * [_markers, [100, 200, 0], 300] call ewc_compat_cup_fnc_findNearMarker
 *
 * Public: No
 */

params [["_markers", [], [[]]], ["_position", [0, 0, 0], [[]]], ["_range", 0, [0]]];

private _distance = BOOMERANG_MARKER_MERGE_DISTANCE max (2 * BOOMERANG_RANGE_ERROR * _range);

_markers findIf {(_x select 1) distance2D _position <= _distance}
