#include "..\script_component.hpp"
/*
 * Author: Andx
 * Atmospheric absorption of sound in dB per m after ISO 9613-1: the relaxation of oxygen and nitrogen molecules and
 * classical absorption, at sea level pressure. High frequencies, dry and cold air are absorbed most. 1 kHz at 20 °C and
 * 70 % humidity is about 5 dB per km, 125 Hz only 0.3 dB per km.
 *
 * Arguments:
 * 0: Frequency in Hz <NUMBER>
 * 1: Air temperature in °C <NUMBER>
 * 2: Relative humidity in % <NUMBER>
 *
 * Return Value:
 * Absorption in dB per m <NUMBER>
 *
 * Example:
 * [1000, 20, 70] call ewc_acoustic_fnc_getAbsorption
 *
 * Public: No
 */

params [["_frequency", 1000, [0]], ["_temperature", DEFAULT_TEMPERATURE, [0]], ["_humidity", 70, [0]]];

// Reference temperature 293.15 K and triple point of water 273.16 K, the pressure is the reference pressure
private _kelvin = _temperature + 273.15;
private _ratio = _kelvin / 293.15;

// Molar concentration of water vapour in %, from the relative humidity and the saturation pressure
private _saturation = 10 ^ (-6.8346 * ((273.16 / _kelvin) ^ 1.261) + 4.6151);
private _vapour = (_humidity max 0.1) * _saturation;

// Relaxation frequencies of oxygen and nitrogen
private _relaxO = 24 + 4.04e4 * _vapour * (0.02 + _vapour) / (0.391 + _vapour);
private _relaxN = (_ratio ^ -0.5) * (9 + 280 * _vapour * exp (-4.170 * ((_ratio ^ (-1 / 3)) - 1)));

private _f2 = _frequency * _frequency;

8.686 * _f2 * (
    1.84e-11 * sqrt _ratio
    + (_ratio ^ -2.5) * (
        0.01275 * (exp (-2239.1 / _kelvin)) / (_relaxO + _f2 / _relaxO)
        + 0.1068 * (exp (-3352 / _kelvin)) / (_relaxN + _f2 / _relaxN)
    )
)
