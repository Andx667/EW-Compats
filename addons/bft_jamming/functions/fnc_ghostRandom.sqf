#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * A number in [0, 1) that depends on a text only. Every client gets the same number for the same text, so the
 * clients agree on which units have a ghost and where it is, without anything being synced.
 * The hash stays below 50021 because a number is a float in SQF and is only exact up to 16.7 million.
 *
 * Arguments:
 * 0: Key, for example the net IDs of a unit and a jammer <STRING>
 * 1: Salt, so one key gives several independent numbers <STRING> (default: "")
 *
 * Return Value:
 * Number from 0 up to, not including, 1 <NUMBER>
 *
 * Example:
 * ["g_2:15_2:3", "angle"] call ewc_bft_jamming_fnc_ghostRandom
 *
 * Public: No
 */

params [["_key", "", [""]], ["_salt", "", [""]]];

private _hash = 7;

{
    _hash = (_hash * 31 + _x) mod 50021;
} forEach toArray (_key + "|" + _salt);

_hash / 50021
