#include "..\script_component.hpp"
/*
 * Author: Andx
 * Shows the track of a drone on the cTab of the side of the sensors: a red air marker (rotary or fixed wing) at the
 * estimated position, with an arrow for its heading, like the markers a player places on the tablet. cTab cannot move
 * a marker and notifies everybody of that side for each new one, so the marker is only replaced once the drone moved
 * CTAB_MOVE_DISTANCE and the old one is CTAB_UPDATE_INTERVAL old. A marker a player deleted comes back with the next
 * update, the drone is still heard. Only the server changes the markers, cTab sends them on to the clients.
 *
 * Arguments:
 * 0: Track ID <NUMBER>
 * 1: Side of the sensors <SIDE>
 * 2: Estimated position, ASL <ARRAY>
 * 3: Heading in degrees <NUMBER>
 * 4: Speed in km/h <NUMBER>
 * 5: Height above the ground in m <NUMBER>
 * 6: Path, [[x, y], ...] <ARRAY>
 * 7: Triangulated <BOOL>
 * 8: Kind, DRONE_KIND_ROTARY or DRONE_KIND_FIXED <NUMBER>
 * 9: Sensor that heard the drone best <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1, west, [100, 200, 150], 90, 60, 120, [], true, 0, _sensor] call ewc_acoustic_fnc_ctab_updateMarker
 *
 * Public: No
 */

params [
    ["_id", -1, [0]],
    ["_side", sideUnknown, [sideUnknown]],
    ["_position", [0, 0, 0], [[]], 3],
    ["_heading", 0, [0]],
    ["_speed", 0, [0]],
    "",
    "",
    "",
    ["_kind", DRONE_KIND_ROTARY, [0]],
    ["_sensor", objNull, [objNull]]
];

if (!isServer || {GVAR(markerTarget) != MARKER_TARGET_CTAB}) exitWith {};

private _key = [_side] call EFUNC(common,getCtabEncryptionKey);
private _point = _position select [0, 2];
private _old = GVAR(ctab_markers) get _id;

if (!isNil "_old") then {
    _old params ["", "_markerId", "_oldPoint", "_added"];

    // A player can delete the marker on the tablet, then it is replaced right away
    private _onTablet = (([cTab_userMarkerLists, _key, []] call cTab_fnc_getFromPairs) findIf {(_x select 0) == _markerId}) != -1;

    if (_onTablet && {(_oldPoint distance2D _point) < CTAB_MOVE_DISTANCE || {CBA_missionTime - _added < CTAB_UPDATE_INTERVAL}}) exitWith {
        _point = [];
    };

    if (_onTablet) then {
        [_key, _markerId] call cTab_fnc_deleteUserMarker;
    };
};

// exitWith in the block above only leaves the block, an empty point says the old marker stays
if (_point isEqualTo []) exitWith {};

private _octant = if (_speed < TRACK_HOVER_SPEED * 3.6) then {
    CTAB_MARKER_DIRECTION_NONE
} else {
    1 + (round (_heading / 45)) % 8
};

// Marker data of cTab: 2D position (cTab makes it ASL), icon, size, octant of movement, time and creator
private _markerData = [
    _point,
    [CTAB_MARKER_ICON_ROTARY, CTAB_MARKER_ICON_FIXED] select (_kind == DRONE_KIND_FIXED),
    CTAB_MARKER_SIZE_NONE,
    _octant,
    call cTab_fnc_currentTime,
    _sensor
];

[_key, _markerData] call cTab_fnc_addUserMarker;

// cTab numbers its markers, the one just added has the last transaction ID. That is what it needs to delete it
GVAR(ctab_markers) set [_id, [_key, cTab_userMarkerTransactionId, _point, CBA_missionTime]];
