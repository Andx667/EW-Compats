#include "..\script_component.hpp"
/*
 * Author: Andx
 * Removes the cTab marker of a track that ended. Only on the server, which added it.
 *
 * Arguments:
 * 0: Track ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1] call ewc_acoustic_fnc_ctab_removeMarker
 *
 * Public: No
 */

params [["_id", -1, [0]]];

if (!isServer) exitWith {};

private _marker = GVAR(ctab_markers) getOrDefault [_id, []];

if (_marker isEqualTo []) exitWith {};

_marker params ["_key", "_markerId"];

// cTab ignores the ID of a marker a player already deleted
[_key, _markerId] call cTab_fnc_deleteUserMarker;

GVAR(ctab_markers) deleteAt _id;
