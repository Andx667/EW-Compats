#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Strongest jamming at an object from all the jammers that are on.
 *
 * Arguments:
 * 0: Object, a router or a client <OBJECT>
 * 1: Jammers, each [object, effective radius, falloff radius] <ARRAY>
 *
 * Return Value:
 * Strength, 0 to 1 <NUMBER>
 *
 * Example:
 * [_laptop, [[_terminal, 100, 100]]] call ewc_wifi_jamming_fnc_getJamStrength
 *
 * Public: No
 */

params [["_object", objNull, [objNull]], ["_jammers", [], [[]]]];

private _strength = 0;

{
    _x params ["_jammer", "_radEffective", "_radFalloff"];

    _strength = _strength max ([_object distance _jammer, _radEffective, _radFalloff] call FUNC(calcJamStrength));

    // Nothing is stronger than full strength
    if (_strength >= 1) exitWith {};
} forEach _jammers;

_strength
