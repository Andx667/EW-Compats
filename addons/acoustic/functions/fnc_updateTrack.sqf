#include "..\script_component.hpp"
/*
 * Author: Andx
 * Takes a new position fix of a drone into its track for a side and sends the track to every machine. The fixes are
 * noisy, so the track smooths them with an alpha-beta filter (a fixed gain Kalman filter): the predicted position
 * moves part of the way to the fix, and the difference corrects the velocity, which gives heading and speed. A single
 * sensor fix is trusted less than a triangulated one. The path keeps a point every PATH_MIN_STEP m.
 *
 * Arguments:
 * 0: Key of the track, "<side>:<drone ID>" <STRING>
 * 1: Side of the sensors <SIDE>
 * 2: Drone <OBJECT>
 * 3: Position fix, ASL <ARRAY>
 * 4: Triangulated <BOOL>
 * 5: Time the sound of the fix was emitted, CBA_missionTime <NUMBER>
 * 6: Sensor that heard the drone best <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["WEST:1", west, _drone, [100, 200, 150], true, CBA_missionTime - 2, _sensor] call ewc_acoustic_fnc_updateTrack
 *
 * Public: No
 */

params [
    ["_key", "", [""]],
    ["_side", sideUnknown, [sideUnknown]],
    ["_drone", objNull, [objNull]],
    ["_fix", [0, 0, 0], [[]], 3],
    ["_triangulated", false, [false]],
    ["_time", 0, [0]],
    ["_sensor", objNull, [objNull]]
];

private _track = GVAR(tracks) get _key;

if (isNil "_track") then {
    GVAR(trackCounter) = GVAR(trackCounter) + 1;

    // ID, side, position ASL, velocity, time of the position, path [[x, y], ...], kind, last time the drone was heard
    _track = [GVAR(trackCounter), _side, _fix, [0, 0, 0], _time, [], ([_drone] call FUNC(getSignature)) select 2, CBA_missionTime];
    GVAR(tracks) set [_key, _track];
} else {
    _track params ["", "", "_position", "_velocity", "_lastTime"];

    // The sound of a closer sensor can arrive before an older one, a fix never goes back in time
    private _step = (_time - _lastTime) max (SCAN_INTERVAL / 10);
    private _predicted = _position vectorAdd (_velocity vectorMultiply _step);
    private _residual = _fix vectorDiff _predicted;
    private _alpha = [TRACK_ALPHA_SINGLE, TRACK_ALPHA_TRIANGULATED] select _triangulated;

    _track set [2, _predicted vectorAdd (_residual vectorMultiply _alpha)];
    _track set [3, _velocity vectorAdd (_residual vectorMultiply (TRACK_BETA / _step))];
    _track set [4, _lastTime max _time];
    _track set [7, CBA_missionTime];
};

_track params ["_id", "", "_position", "_velocity", "", "_path", "_kind"];

private _point = _position select [0, 2];

if (_path isEqualTo [] || {(_path select -1) distance2D _point >= PATH_MIN_STEP}) then {
    _path pushBack _point;

    if (count _path > PATH_MAX_POINTS) then {
        _path deleteAt 0;
    };
};

private _speed = vectorMagnitude [_velocity select 0, _velocity select 1, 0];
private _heading = (((_velocity select 0) atan2 (_velocity select 1)) + 360) % 360;
private _altitude = (_position select 2) - (getTerrainHeightASL _position);

[QGVAR(trackUpdated), [
    _id,
    _side,
    _position,
    round _heading,
    round (_speed * 3.6),
    round (_altitude max 0),
    _path,
    _triangulated,
    _kind,
    _sensor
]] call CBA_fnc_globalEvent;
