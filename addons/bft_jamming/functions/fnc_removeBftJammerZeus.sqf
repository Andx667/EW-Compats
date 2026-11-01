#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Zeus module "Remove BFT Jammer": removes the jammer from the selected object. Only BFT jammers, the radio and drone
 * jammers of Crows are removed with its own module. The Spectrum signal goes with the jammer (fnc_removeJammerServer of Crows).
 * The object itself stays.
 *
 * Arguments:
 * 0: Position the module was placed at, ASL <ARRAY>
 * 1: Object the module was placed on <OBJECT> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [getPosASL player, _terminal] call ewc_bft_jamming_fnc_removeBftJammerZeus
 *
 * Public: No
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_unit", objNull, [objNull]]];

private _entry = [[], CROWSEW_JAM_MAP getOrDefault [netId _unit, []]] select !isNull _unit;
private _capabilities = _entry param [4, []];

private _isBftJammer = (BFT_JAM_CAP_BLACKOUT in _capabilities) || {BFT_JAM_CAP_DRIFT in _capabilities} || {BFT_JAM_CAP_MIXED in _capabilities};

if (!_isBftJammer) exitWith {
    hint LLSTRING(zeus_remove_error);
};

[CROWSEW_REMOVE_JAMMER_EVENT, [netId _unit]] call CBA_fnc_serverEvent;
