#include "..\script_component.hpp"
/*
 * Author: Andx
 * Shows a shot a Boomerang detected: a hint for the crew of the vehicle and, for everybody friendly to it, a map
 * marker at the estimated position of the shooter for a while.
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
 * [_vehicle, [100, 200, 0], 3, 300, 90, 1, west] call ewc_compat_cup_fnc_onShotDetected
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_position", [0, 0, 0], [[]]], ["_clock", 12, [0]], ["_range", 0, [0]], ["_bearing", 0, [0]], ["_elevation", 1, [0]], ["_side", sideUnknown, [sideUnknown]]];

if (isNull player) exitWith {};

// No audio, a hint that does not make a sound
if (vehicle player == _vehicle) then {
    // The text has one line per piece of information, separated by |
    hintSilent parseText ((format [
        LLSTRING(boomerang_hint),
        _clock,
        _range,
        _bearing,
        [LLSTRING(boomerang_elevation_high), LLSTRING(boomerang_elevation_level), LLSTRING(boomerang_elevation_low)] select _elevation
    ]) splitString "|" joinString "<br/>");
};

// Markers are local, so only the side of the vehicle gets to see where the shot came from
if (GVAR(markerLifetime) > 0 && {(playerSide getFriend _side) >= 0.6}) then {
    GVAR(markerCounter) = GVAR(markerCounter) + 1;

    private _marker = format ["%1_%2", QGVAR(shot), GVAR(markerCounter)];

    createMarkerLocal [_marker, _position];
    _marker setMarkerTypeLocal "hd_warning";
    _marker setMarkerColorLocal "ColorRed";
    _marker setMarkerTextLocal LLSTRING(boomerang_markerText);

    [{deleteMarkerLocal _this}, _marker, GVAR(markerLifetime)] call CBA_fnc_waitAndExecute;
};
