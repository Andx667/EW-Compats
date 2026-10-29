#include "..\script_component.hpp"
/*
 * Author: Andx
 * Shows a shot a Boomerang detected on the cTab of the side of the vehicle: a red user marker at the estimated position
 * of the shooter, like the ones a player places on the tablet. Everybody with the cTab of that side sees it, and
 * cTab notifies them. It is removed after the marker lifetime of the server.
 * Only the server adds the marker, cTab sends it on to the clients.
 *
 * Arguments:
 * 0: Vehicle that heard the shot <OBJECT>
 * 1: Estimated position of the shooter <ARRAY>
 * 2: Direction as on a clock, 12 is ahead <NUMBER>
 * 3: Estimated range in meters <NUMBER>
 * 4: Estimated bearing in degrees <NUMBER>
 * 5: Elevation, 0 above, 1 level, 2 below the vehicle <NUMBER>
 * 6: Side of the vehicle <SIDE>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, [100, 200, 0], 3, 300, 90, 1, west] call ewc_compat_cup_ctab_fnc_addMarker
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_position", [0, 0, 0], [[]]], "", "", "", "", ["_side", sideUnknown, [sideUnknown]]];

if (!isServer) exitWith {};

private _lifetime = EGVAR(compat_cup,markerLifetime);

// Nothing to do when the setting keeps the shots on the map, or the markers are switched off
if (EGVAR(compat_cup,markerTarget) == MARKER_TARGET_MAP || {_lifetime <= 0} || {isNull _vehicle}) exitWith {};

private _key = [_side] call FUNC(getEncryptionKey);

// Marker data of cTab: 2D position (cTab makes it ASL), icon, size, octant of movement, time and creator
private _markerData = [
    _position select [0, 2],
    CTAB_MARKER_ICON_UNKNOWN,
    CTAB_MARKER_SIZE_NONE,
    CTAB_MARKER_DIRECTION_NONE,
    call cTab_fnc_currentTime,
    effectiveCommander _vehicle
];

[_key, _markerData] call cTab_fnc_addUserMarker;

// cTab numbers its markers, the one just added has the last transaction ID. That is what it needs to delete it
private _markerId = cTab_userMarkerTransactionId;

[{
    params ["_key", "_markerId"];

    [_key, _markerId] call cTab_fnc_deleteUserMarker;
}, [_key, _markerId], _lifetime] call CBA_fnc_waitAndExecute;
