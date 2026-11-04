#include "..\script_component.hpp"
/*
 * Author: Andx
 * Background noise at the microphones of a sensor in dB, the energetic sum of the ambient noise of the setting, wind on
 * the windscreen, rain and the running engines of vehicles nearby (spherical spreading from their level at 1 m). The
 * drones themselves are not counted, they are what the sensor listens for. A sensor that is a vehicle with its engine
 * running hears next to nothing.
 *
 * Arguments:
 * 0: Position of the microphone, ASL <ARRAY>
 * 1: Weather, see fnc_getWeather <ARRAY>
 *
 * Return Value:
 * Noise level in dB <NUMBER>
 *
 * Example:
 * [getPosASL _sensor, call ewc_acoustic_fnc_getWeather] call ewc_acoustic_fnc_getNoiseLevel
 *
 * Public: No
 */

params [["_mic", [0, 0, 0], [[]], 3], ["_weather", [], [[]]]];

_weather params ["", "", ["_wind", [0, 0, 0], [[]]], ["_rain", 0, [0]]];

// Levels are summed as energies, 10 ^ (L / 10)
private _energy = 10 ^ (GVAR(ambientNoise) / 10);

private _windSpeed = vectorMagnitude [_wind select 0, _wind select 1, 0];

if (_windSpeed > WIND_NOISE_MIN_SPEED) then {
    _energy = _energy + 10 ^ ((WIND_NOISE_REFERENCE + WIND_NOISE_SLOPE * log (_windSpeed / WIND_NOISE_REFERENCE_SPEED)) / 10);
};

if (_rain > 0) then {
    _energy = _energy + 10 ^ ((RAIN_NOISE_BASE + RAIN_NOISE_RANGE * _rain) / 10);
};

{
    if (isEngineOn _x && {!unitIsUAV _x}) then {
        private _level = switch (true) do {
            case (_x isKindOf "Tank"): {NOISE_LEVEL_TANK};
            case (_x isKindOf "Helicopter"): {NOISE_LEVEL_HELICOPTER};
            case (_x isKindOf "Plane"): {NOISE_LEVEL_PLANE};
            case (_x isKindOf "Ship"): {NOISE_LEVEL_SHIP};
            default {NOISE_LEVEL_CAR};
        };
        private _distance = ((getPosASL _x) vectorDistance _mic) max MIN_DISTANCE;

        _energy = _energy + 10 ^ ((_level - 20 * log _distance) / 10);
    };
} forEach ((ASLToAGL _mic) nearEntities [["LandVehicle", "Air", "Ship"], NOISE_SOURCE_RADIUS]);

10 * log _energy
