#include "..\script_component.hpp"
/*
 * Author: Andx
 * Shows a shot a Boomerang detected: a hint for the crew of the vehicle and, for everybody friendly to it, a map
 * marker at the estimated position of the shooter for a while. A shot close to a marker that is still there does not
 * add one, it only keeps that marker longer. The marker is left out when the setting sends the
 * shots to cTab only (the cTab sub-addon adds the marker there).
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
 * [_vehicle, [100, 200, 0], 3, 300, 90, 1, west] call ewc_compat_cup_boomerang_fnc_onShotDetected
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_position", [0, 0, 0], [[]]], ["_clock", 12, [0]], ["_range", 0, [0]], ["_bearing", 0, [0]], ["_elevation", 1, [0]], ["_side", sideUnknown, [sideUnknown]]];

if (isNull player) exitWith {};

// No audio, a hint that does not make a sound
if (vehicle player == _vehicle) then {
    // The text has one line per piece of information, separated by |
    hintSilent parseText ((format [
        LLSTRING(hint),
        _clock,
        _range,
        _bearing,
        [LLSTRING(elevation_high), LLSTRING(elevation_level), LLSTRING(elevation_low)] select _elevation
    ]) splitString "|" joinString "<br/>");
};

// The setting belongs to the cTab sub-addon. Without cTab it does not exist and the map is the only place for a marker
private _onMap = isNil QGVAR(ctab_markerTarget) || {GVAR(ctab_markerTarget) != MARKER_TARGET_CTAB};

// Markers are local, so only the side of the vehicle gets to see where the shot came from
if (_onMap && {GVAR(markerLifetime) > 0} && {(playerSide getFriend _side) >= 0.6}) then {
    private _near = [GVAR(shotMarkers), _position, _range] call FUNC(findNearMarker);

    if (_near != -1) then {
        // The shooter is already marked, so the map does not fill up. The marker stays while shots keep coming
        (GVAR(shotMarkers) select _near) set [2, CBA_missionTime + GVAR(markerLifetime)];
    } else {
        GVAR(markerCounter) = GVAR(markerCounter) + 1;

        private _marker = format ["%1_%2", QGVAR(shot), GVAR(markerCounter)];

        createMarkerLocal [_marker, _position];
        _marker setMarkerTypeLocal "hd_warning";
        _marker setMarkerColorLocal "ColorRed";
        _marker setMarkerTextLocal LLSTRING(markerText);

        GVAR(shotMarkers) pushBack [_marker, _position, CBA_missionTime + GVAR(markerLifetime)];

        [LINKFUNC(expireShotMarker), _marker, GVAR(markerLifetime)] call CBA_fnc_waitAndExecute;
    };
};
