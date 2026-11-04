#include "..\script_component.hpp"
/*
 * Author: Andx
 * Works out where a drone is from the measurements of the sensors of one side that hear it. Two or more bearings that
 * cross at MIN_CROSS_ANGLE or more are triangulated: the point with the least squared distance to all bearing lines,
 * each weighted by its accuracy. The height comes from the elevations at that distance. Otherwise the best sensor
 * alone gives the position from its bearing, elevation and the range it estimated from the level, which is much
 * less exact.
 *
 * Arguments:
 * 0: Measurements, see fnc_hearDrone <ARRAY>
 *
 * Return Value:
 * 0: Estimated position, ASL <ARRAY>
 * 1: Triangulated <BOOL>
 *
 * Example:
 * [[_measurementA, _measurementB]] call ewc_acoustic_fnc_estimatePosition
 *
 * Public: No
 */

params [["_measurements", [], [[]]]];

private _crossing = false;

if (count _measurements > 1) then {
    {
        private _azimuth = _x select 1;
        private _index = _forEachIndex;

        {
            // Acute angle between the two lines, a bearing and its opposite are the same line
            private _angle = abs ((((_azimuth - (_x select 1)) % 180) + 180) % 180);

            if ((_angle min (180 - _angle)) >= MIN_CROSS_ANGLE) exitWith {
                _crossing = true;
            };
        } forEach (_measurements select [_index + 1, count _measurements]);

        // exitWith above only leaves the inner forEach, this one leaves the outer
        if (_crossing) exitWith {};
    } forEach _measurements;
};

private _position = [];

// exitWith inside this block only leaves the block: a failed triangulation falls back to the best sensor below
if (_crossing) then {
    // Least squares intersection: sum of w (I - d d') over the lines, d the direction and w = 1 / error^2
    private _a11 = 0;
    private _a12 = 0;
    private _a22 = 0;
    private _b1 = 0;
    private _b2 = 0;

    {
        _x params ["_mic", "_azimuth", "", "_error"];

        private _dx = sin _azimuth;
        private _dy = cos _azimuth;
        private _weight = 1 / (_error * _error);
        private _m11 = _weight * (1 - _dx * _dx);
        private _m12 = -_weight * _dx * _dy;
        private _m22 = _weight * (1 - _dy * _dy);

        _a11 = _a11 + _m11;
        _a12 = _a12 + _m12;
        _a22 = _a22 + _m22;
        _b1 = _b1 + _m11 * (_mic select 0) + _m12 * (_mic select 1);
        _b2 = _b2 + _m12 * (_mic select 0) + _m22 * (_mic select 1);
    } forEach _measurements;

    private _determinant = _a11 * _a22 - _a12 * _a12;

    if (abs _determinant < 1e-9) exitWith {};

    private _x0 = (_a22 * _b1 - _a12 * _b2) / _determinant;
    private _y0 = (_a11 * _b2 - _a12 * _b1) / _determinant;

    // The lines can also cross behind a sensor, then the bearings do not agree on a drone
    private _behind = _measurements findIf {
        private _mic = _x select 0;

        (((_x0 - (_mic select 0)) * sin (_x select 1)) + ((_y0 - (_mic select 1)) * cos (_x select 1))) <= 0
    };

    if (_behind != -1) exitWith {};

    private _heightSum = 0;
    private _weightSum = 0;

    {
        _x params ["_mic", "", "_elevation", "_error"];

        private _weight = 1 / (_error * _error);

        // Straight above or below the sensor the tangent grows without bound, the elevation is not that exact anyway
        private _clamped = (_elevation max -MAX_ELEVATION) min MAX_ELEVATION;

        _heightSum = _heightSum + _weight * ((_mic select 2) + ([_x0, _y0] distance2D _mic) * tan _clamped);
        _weightSum = _weightSum + _weight;
    } forEach _measurements;

    _position = [_x0, _y0, _heightSum / _weightSum];
};

private _triangulated = _position isNotEqualTo [];

if (!_triangulated) then {
    // The sensor that hears the drone best
    private _best = _measurements select 0;

    {
        if ((_x select 5) > (_best select 5)) then {
            _best = _x;
        };
    } forEach _measurements;

    _best params ["_mic", "_azimuth", "_elevation", "", "_range"];

    private _horizontal = _range * cos _elevation;

    _position = _mic vectorAdd [_horizontal * sin _azimuth, _horizontal * cos _azimuth, _range * sin _elevation];
};

// Not below the ground
_position set [2, (_position select 2) max (getTerrainHeightASL _position)];

[_position, _triangulated]
