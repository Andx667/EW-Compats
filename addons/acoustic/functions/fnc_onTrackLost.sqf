#include "..\script_component.hpp"
/*
 * Author: Andx
 * Removes the map markers of a track that ended.
 *
 * Arguments:
 * 0: Track ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1] call ewc_acoustic_fnc_onTrackLost
 *
 * Public: No
 */

params [["_id", -1, [0]]];

private _markers = GVAR(trackMarkers) getOrDefault [_id, []];

{
    deleteMarkerLocal _x;
} forEach _markers;

GVAR(trackMarkers) deleteAt _id;
