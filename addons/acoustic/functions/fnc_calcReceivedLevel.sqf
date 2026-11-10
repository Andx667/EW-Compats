#include "..\script_component.hpp"
/*
 * Author: Andx
 * Sound level a microphone receives from a source, after the outdoor propagation of ISO 9613:
 * - spherical spreading, 20 log10(d) for the distance d in m (6 dB less per doubled distance)
 * - atmospheric absorption of ISO 9613-1, the given dB per m times the distance
 * - ground effect of ISO 9613-2 (simplified method for porous ground): 4.8 - (2 hm / d) (17 + 300 / d) dB, at least 0,
 *   hm the mean height of the path above the terrain. Low paths over long distances lose most, an elevated drone little
 * - terrain screening of ISO 9613-2: the highest point of the terrain that blocks the line of sight is a single
 *   diffracting edge, Dz = 10 log10(3 + 20 z / wavelength) with z the detour of the sound over the edge, up to 20 dB.
 *   Dz replaces the ground effect when it is larger (A_bar = Dz - A_gr in the standard)
 * - upwind shadow zone: the wind gradient bends sound upwards against the wind, so a receiver upwind of the source loses
 *   up to WIND_SHADOW_MAX dB. Empirical, grows with the headwind and the distance, gone for a source high above
 *
 * Arguments:
 * 0: Position of the source, ASL <ARRAY>
 * 1: Position of the microphone, ASL <ARRAY>
 * 2: Source level in dB at 1 m <NUMBER>
 * 3: Frequency in Hz <NUMBER>
 * 4: Weather, see fnc_getWeather <ARRAY>
 * 5: Atmospheric absorption at that frequency in dB per m, see fnc_getAbsorption <NUMBER>
 *
 * Return Value:
 * 0: Received level in dB <NUMBER>
 * 1: Losses in dB: spreading, absorption, ground or terrain, wind <ARRAY>
 *
 * Example:
 * [getPosASL _drone, getPosASL _sensor, 78, 400, call ewc_acoustic_fnc_getWeather, 0.002] call ewc_acoustic_fnc_calcReceivedLevel
 *
 * Public: No
 */

params [
    ["_source", [0, 0, 0], [[]], 3],
    ["_mic", [0, 0, 0], [[]], 3],
    ["_level", 0, [0]],
    ["_frequency", 1000, [0]],
    ["_weather", [], [[]]],
    ["_absorption", 0, [0]]
];

_weather params ["", "", ["_wind", [0, 0, 0], [[]]], "", ["_speedOfSound", 340, [0]]];

private _path = _mic vectorDiff _source;
private _distance = (vectorMagnitude _path) max MIN_DISTANCE;
private _horizontal = vectorMagnitude [_path select 0, _path select 1, 0];

private _spreading = 20 * log _distance;
private _absorbed = _absorption * _distance;

// Walk the path: mean height above the terrain for the ground effect, and the point that blocks it most for the screening
private _samples = ((ceil (_horizontal / BARRIER_SAMPLE_SPACING)) max 2) min BARRIER_MAX_SAMPLES;
private _heightSum = ((_source select 2) - getTerrainHeightASL _source) + ((_mic select 2) - getTerrainHeightASL _mic);
private _lowest = 0;
private _edgeFraction = 0;
private _edgeHeight = 0;

for "_i" from 1 to (_samples - 1) do {
    private _fraction = _i / _samples;
    private _point = _source vectorAdd (_path vectorMultiply _fraction);
    private _terrain = getTerrainHeightASL _point;
    private _above = (_point select 2) - _terrain;

    _heightSum = _heightSum + _above;

    if (_above < _lowest) then {
        _lowest = _above;
        _edgeFraction = _fraction;
        _edgeHeight = _terrain;
    };
};

private _meanHeight = (_heightSum / (_samples + 1)) max 0;
private _ground = (4.8 - (2 * _meanHeight / _distance) * (17 + 300 / _distance)) max 0;

if (_lowest < 0) then {
    private _toEdge = _horizontal * _edgeFraction;
    private _fromEdge = _horizontal - _toEdge;
    private _detour = (sqrt (_toEdge ^ 2 + (_edgeHeight - (_source select 2)) ^ 2))
        + (sqrt (_fromEdge ^ 2 + (_edgeHeight - (_mic select 2)) ^ 2))
        - _distance;
    private _screening = (10 * log (3 + 20 * _detour * _frequency / _speedOfSound)) min BARRIER_MAX_ATTENUATION;

    _ground = _ground max _screening;
};

// Wind along the path, from the source to the microphone. Negative is a headwind for the sound
private _shadow = 0;

if (_horizontal > MIN_DISTANCE) then {
    private _along = ([_wind select 0, _wind select 1, 0] vectorDotProduct [_path select 0, _path select 1, 0]) / _horizontal;

    if (_along < 0) then {
        private _elevation = ((_source select 2) - (_mic select 2)) atan2 _horizontal;

        _shadow = ((-_along * WIND_SHADOW_DB_PER_MS) min WIND_SHADOW_MAX)
            * ((_horizontal / WIND_SHADOW_DISTANCE) min 1)
            * ((1 - _elevation / WIND_SHADOW_ELEVATION) max 0 min 1);
    };
};

[
    _level - _spreading - _absorbed - _ground - _shadow,
    [_spreading, _absorbed, _ground, _shadow]
]
