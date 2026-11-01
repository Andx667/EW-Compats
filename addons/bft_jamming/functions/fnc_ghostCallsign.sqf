#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * The callsign of a ghost: the one of the unit it copies with another last digit ("Alpha 1-1" becomes "Alpha 1-4"),
 * or a number added to a callsign without a digit. The same for every client. Unchanged with the setting
 * ewc_bft_jamming_ghostExactCallsign.
 *
 * Arguments:
 * 0: Callsign of the unit <STRING>
 * 1: Key of the ghost, see fnc_ghostRandom <STRING>
 *
 * Return Value:
 * Callsign of the ghost <STRING>
 *
 * Example:
 * ["Alpha 1-1", "g_2:15_2:3"] call ewc_bft_jamming_fnc_ghostCallsign
 *
 * Public: No
 */

params [["_text", "", [""]], ["_key", "", [""]]];

if (GVAR(ghostExactCallsign) || {_text isEqualTo ""}) exitWith {_text};

private _random = [_key, "callsign"] call FUNC(ghostRandom);
private _digit = "0123456789" find (_text select [count _text - 1, 1]);

if (_digit == -1) exitWith {
    format ["%1 %2", _text, 2 + floor (_random * 7)]
};

// 1 to 8 on top of the digit, so it is never the same
format ["%1%2", _text select [0, count _text - 1], (_digit + 1 + floor (_random * 8)) mod 10]
