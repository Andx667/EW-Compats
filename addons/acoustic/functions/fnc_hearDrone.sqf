#include "..\script_component.hpp"
/*
 * Author: Andx
 * Checks whether a sensor hears a drone and what it measures. Sound is slow, so the sensor hears the drone where it
 * was when the sound left it, not where it is: a drone at 50 m/s and 2 km is heard about 300 m behind. The drone is
 * heard when its received level plus the processing gain of the array is DETECTION_THRESHOLD above the noise.
 * The measurement is not exact: the bearing error falls with the signal to noise ratio, and the range comes from the
 * received level and the nominal source level of the drone type, which individual drones miss by up to
 * LEVEL_UNCERTAINTY dB. Terrain, wind and the ground make a drone sound further away than it is.
 *
 * Arguments:
 * 0: Position of the microphone, ASL <ARRAY>
 * 1: Background noise at the microphone in dB <NUMBER>
 * 2: Drone <OBJECT>
 * 3: Weather, see fnc_getWeather <ARRAY>
 * 4: Atmospheric absorption per frequency, frequency -> dB per m, filled as needed <HASHMAP>
 *
 * Return Value:
 * Measurement, empty when the drone is not heard <ARRAY>
 * 0: Position of the microphone, ASL <ARRAY>
 * 1: Measured azimuth in degrees <NUMBER>
 * 2: Measured elevation in degrees <NUMBER>
 * 3: Bearing error (one standard deviation) in degrees <NUMBER>
 * 4: Estimated range in m <NUMBER>
 * 5: Signal to noise ratio after processing in dB <NUMBER>
 * 6: Travel time of the sound in s <NUMBER>
 *
 * Example:
 * [_mic, 40, _drone, _weather, createHashMap] call ewc_acoustic_fnc_hearDrone
 *
 * Public: No
 */

params [
    ["_mic", [0, 0, 0], [[]], 3],
    ["_noise", 0, [0]],
    ["_drone", objNull, [objNull]],
    ["_weather", [], [[]]],
    ["_absorptionCache", createHashMap, [createHashMap]]
];

_weather params [["_temperature", DEFAULT_TEMPERATURE, [0]], ["_humidity", 70, [0]], "", "", ["_speedOfSound", 340, [0]]];

([_drone] call FUNC(getSignature)) params ["_level", "_frequency"];

private _absorption = _absorptionCache get _frequency;

if (isNil "_absorption") then {
    _absorption = [_frequency, _temperature, _humidity] call FUNC(getAbsorption);
    _absorptionCache set [_frequency, _absorption];
};

// Position at the time the sound was emitted. Two steps of the fixed point are exact enough below the speed of sound
private _position = getPosASL _drone;
private _velocity = velocity _drone;
private _delay = (_position vectorDistance _mic) / _speedOfSound;

for "_i" from 1 to 2 do {
    private _emitted = _position vectorDiff (_velocity vectorMultiply _delay);

    _delay = (_emitted vectorDistance _mic) / _speedOfSound;
};

private _emitted = _position vectorDiff (_velocity vectorMultiply _delay);

([_emitted, _mic, _level, _frequency, _weather, _absorption] call FUNC(calcReceivedLevel)) params ["_received"];

private _snr = _received + PROCESSING_GAIN - _noise;

if (_snr < DETECTION_THRESHOLD) exitWith {[]};

// 1 / sqrt(SNR) of the power ratio is 10 ^ (-dB / 20)
private _error = (BEARING_ERROR_MAX * 10 ^ (-(_snr - DETECTION_THRESHOLD) / 20)) max BEARING_ERROR_MIN;
private _elevationError = _error * ELEVATION_ERROR_FACTOR;

private _toDrone = _emitted vectorDiff _mic;
private _horizontal = vectorMagnitude [_toDrone select 0, _toDrone select 1, 0];
private _azimuth = (_toDrone select 0) atan2 (_toDrone select 1);
private _elevation = (_toDrone select 2) atan2 _horizontal;

_azimuth = (_azimuth + random [-2 * _error, 0, 2 * _error] + 360) % 360;
_elevation = ((_elevation + random [-2 * _elevationError, 0, 2 * _elevationError]) max -90) min 90;

// Range from the measured level: invert spreading and absorption for the nominal source level. The ground, terrain
// and wind are unknown to the sensor, they make the drone sound further away
private _measured = _received + random [-LEVEL_UNCERTAINTY, 0, LEVEL_UNCERTAINTY];
private _range = 10 ^ ((_level - _measured) / 20);

for "_i" from 1 to 3 do {
    _range = 10 ^ ((_level - _measured - _absorption * _range) / 20);
};

_range = (_range max MIN_DISTANCE) min (2 * GVAR(maxRange));

[_mic, _azimuth, _elevation, _error, _range, _snr, _delay]
