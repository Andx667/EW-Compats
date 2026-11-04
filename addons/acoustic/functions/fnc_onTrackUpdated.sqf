#include "..\script_component.hpp"
/*
 * Author: Andx
 * Shows the track of a drone on the map of everybody friendly to the side of the sensors: a drone marker at the
 * estimated position with height, heading and speed, and a line along the path it took. A track from a single
 * sensor is fainter, its position is much less exact. Only when the setting shows the tracks on the map (the cTab
 * sub-addon adds the one on cTab).
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
 * [1, west, [100, 200, 150], 90, 60, 120, [[0, 0], [50, 50]], true, 0, _sensor] call ewc_acoustic_fnc_onTrackUpdated
 *
 * Public: No
 */

params [
    ["_id", -1, [0]],
    ["_side", sideUnknown, [sideUnknown]],
    ["_position", [0, 0, 0], [[]], 3],
    ["_heading", 0, [0]],
    ["_speed", 0, [0]],
    ["_altitude", 0, [0]],
    ["_path", [], [[]]],
    ["_triangulated", false, [false]]
];

// Markers are local, so only the side of the sensors sees the drones. When this machine should not show the track
// (any more: the setting changed, or the player changed side), remove the markers it already made for it
// Same check as the server in fnc_getTrackRecipients, which matters for a player on the server itself
if (isNull player || {GVAR(markerTarget) != MARKER_TARGET_MAP} || {((side group player) getFriend _side) < 0.6}) exitWith {
    if (_id in GVAR(trackMarkers)) then {
        [_id] call FUNC(onTrackLost);
    };
};

private _markers = GVAR(trackMarkers) get _id;

if (isNil "_markers") then {
    _markers = [format ["%1_%2", QGVAR(track), _id], format ["%1_%2", QGVAR(path), _id]];
    _markers params ["_icon", "_line"];

    createMarkerLocal [_icon, _position];
    _icon setMarkerTypeLocal MARKER_TYPE;
    _icon setMarkerColorLocal MARKER_COLOR;

    createMarkerLocal [_line, _position];
    _line setMarkerShapeLocal "POLYLINE";
    _line setMarkerColorLocal MARKER_COLOR;

    GVAR(trackMarkers) set [_id, _markers];
};

_markers params ["_icon", "_line"];

private _text = if (_speed < TRACK_HOVER_SPEED * 3.6) then {
    format [LLSTRING(markerText_hover), _altitude]
} else {
    format [LLSTRING(markerText), _altitude, _heading, _speed]
};

_icon setMarkerPosLocal _position;
_icon setMarkerTextLocal _text;
_icon setMarkerAlphaLocal ([MARKER_ALPHA_SINGLE, 1] select _triangulated);

// The line ends at the drone. A polyline needs two points
private _points = _path + [_position select [0, 2]];

if (count _points > 1) then {
    _line setMarkerPolylineLocal flatten _points;
};
