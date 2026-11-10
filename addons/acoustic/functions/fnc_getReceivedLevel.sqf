#include "..\script_component.hpp"
/*
 * Author: Andx
 * What a sensor hears of a drone right now, with the parts of the propagation. For tuning and missions, the detection
 * itself runs in the scan of the server. The losses do not include the travel time of the sound.
 *
 * Arguments:
 * 0: Sensor, or any object with microphones at MIC_HEIGHT above it <OBJECT>
 * 1: Drone <OBJECT>
 *
 * Return Value:
 * 0: Received level in dB <NUMBER>
 * 1: Background noise in dB <NUMBER>
 * 2: Signal to noise ratio after processing in dB, heard from DETECTION_THRESHOLD <NUMBER>
 * 3: Losses in dB: spreading, absorption, ground or terrain, wind <ARRAY>
 * 4: Signature of the drone: source level, frequency, kind <ARRAY>
 *
 * Example:
 * [_mast, _drone] call ewc_acoustic_fnc_getReceivedLevel
 *
 * Public: Yes
 */

params [["_sensor", objNull, [objNull]], ["_drone", objNull, [objNull]]];

if (isNull _sensor || {isNull _drone}) exitWith {[]};

private _weather = call FUNC(getWeather);
private _mic = (getPosASL _sensor) vectorAdd [0, 0, MIC_HEIGHT];
private _signature = [_drone] call FUNC(getSignature);

_signature params ["_level", "_frequency"];
_weather params ["_temperature", "_humidity"];

private _absorption = [_frequency, _temperature, _humidity] call FUNC(getAbsorption);
private _noise = [_mic, _weather] call FUNC(getNoiseLevel);

([getPosASL _drone, _mic, _level, _frequency, _weather, _absorption] call FUNC(calcReceivedLevel)) params ["_received", "_losses"];

[_received, _noise, _received + PROCESSING_GAIN - _noise, _losses, _signature]
