#include "..\script_component.hpp"
/*
 * Author: Andx
 * Removes the cTab marker of a detected shot once its time is up. A later report that was merged into the marker has
 * moved its expiry time, then the removal is only scheduled again for the time that is left.
 *
 * Arguments:
 * 0: Encryption key of the marker <STRING>
 * 1: ID of the marker, the transaction ID of cTab <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["b", 12] call ewc_boomerang_fnc_ctab_expireMarker
 *
 * Public: No
 */

params [["_key", "", [""]], ["_markerId", -1, [0]]];

private _markers = GVAR(ctab_shotMarkers) getOrDefault [_key, []];
private _index = _markers findIf {(_x select 0) == _markerId};

// Gone already, a player deleted it on the tablet
if (_index == -1) exitWith {};

private _left = ((_markers select _index) select 2) - CBA_missionTime;

if (_left > MARKER_EXPIRY_TOLERANCE) exitWith {
    [LINKFUNC(ctab_expireMarker), [_key, _markerId], _left] call CBA_fnc_waitAndExecute;
};

[_key, _markerId] call cTab_fnc_deleteUserMarker;
_markers deleteAt _index;
