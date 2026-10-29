#include "..\script_component.hpp"
/*
 * Author: Andx
 * Returns the encryption key cTab uses for the user markers of a side. cTab sets the keys on the clients only, so a
 * server that has none of its own gets the same defaults cTab would give the clients (cTab XEH_postInitClient).
 *
 * Arguments:
 * 0: Side <SIDE>
 *
 * Return Value:
 * Encryption key <STRING>
 *
 * Example:
 * [west] call ewc_boomerang_fnc_ctab_getEncryptionKey
 *
 * Public: No
 */

params [["_side", sideUnknown, [sideUnknown]]];

// cTab names the variables after the side as the engine writes it: cTab_encryptionKey_WEST, _EAST, _GUER and _CIV
private _key = missionNamespace getVariable [format ["cTab_encryptionKey_%1", _side], ""];

if (_key isNotEqualTo "") exitWith {_key};

if (_side isEqualTo west) exitWith {"b"};
if (_side isEqualTo east) exitWith {"o"};
if (_side isEqualTo civilian) exitWith {"c"};

// Independent shares the key of the side it is friendly to, and only of that one
private _westFriendly = [west, resistance] call BIS_fnc_areFriendly;
private _eastFriendly = [east, resistance] call BIS_fnc_areFriendly;

if (_westFriendly && {!_eastFriendly}) exitWith {"b"};
if (_eastFriendly && {!_westFriendly}) exitWith {"o"};

"i"
