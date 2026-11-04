#include "..\script_component.hpp"
/*
 * Author: Andx
 * SERVER ONLY. Machines the tracks of a side are sent to: those of the players friendly to the side, and only while
 * the setting shows the tracks on the map. The server itself is never in the list, it raises the events locally (the
 * cTab sub-addon and scripts on the server always get them).
 *
 * Arguments:
 * 0: Side of the sensors <SIDE>
 *
 * Return Value:
 * Owner IDs <ARRAY>
 *
 * Example:
 * [west] call ewc_acoustic_fnc_getTrackRecipients
 *
 * Public: No
 */

params [["_side", sideUnknown, [sideUnknown]]];

if (GVAR(markerTarget) != MARKER_TARGET_MAP) exitWith {[]};

private _owners = [];

{
    // side group, not side: a captive is civilian but still sees the map of its side. The client checks the same
    if (!local _x && {((side group _x) getFriend _side) >= 0.6}) then {
        _owners pushBackUnique owner _x;
    };
} forEach (allPlayers - entities "HeadlessClient_F");

_owners
