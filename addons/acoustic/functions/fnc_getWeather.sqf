#include "..\script_component.hpp"
/*
 * Author: Andx
 * Reads the weather that changes how sound travels and how much noise the microphones pick up. The weather changes
 * slowly, so a scan reads it once for all sensors.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Weather <ARRAY>
 * 0: Air temperature in °C <NUMBER>
 * 1: Relative humidity in % <NUMBER>
 * 2: Wind, the velocity of the air in m/s <ARRAY>
 * 3: Rain, 0 to 1 <NUMBER>
 * 4: Speed of sound in m/s <NUMBER>
 *
 * Example:
 * call ewc_acoustic_fnc_getWeather
 *
 * Public: No
 */

private _temperature = (ambientTemperature select 0);

if (!finite _temperature) then {
    _temperature = DEFAULT_TEMPERATURE;
};

// Speed of sound in dry air, 331.3 m/s at 0 °C, growing with the square root of the absolute temperature
private _speedOfSound = 331.3 * sqrt (1 + _temperature / 273.15);

[_temperature, 100 * humidity, wind, rain, _speedOfSound]
