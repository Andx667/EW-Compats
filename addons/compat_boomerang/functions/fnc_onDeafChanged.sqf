#include "..\script_component.hpp"
/*
 * Author: Andx
 * Tells the crew of a Boomerang that it went deaf after the own fire of the vehicle, or listens again. The hint is
 * silent, so it makes no sound.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Boomerang is deaf <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true] call ewc_compat_boomerang_fnc_onDeafChanged
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_deaf", false, [false]]];

if (isNull player || {vehicle player != _vehicle}) exitWith {};

hintSilent (if (_deaf) then {LLSTRING(hint_deaf)} else {LLSTRING(hint_listening)});
