#include "..\script_component.hpp"
/*
 * Author: Andx
 * Registers a system of a vehicle with extra lines for the debug overlay (fnc_debugDraw). The overlay already shows
 * the Crows jammer of a vehicle and the systems registered with fnc_registerSwitch, so this is only for what they
 * do not tell. Call it on every machine with an interface, in preInit.
 *
 * Arguments:
 * 0: Id of the system, unique across the addons <STRING>
 * 1: Does the vehicle have the system, called with [vehicle]. The answer is kept for the vehicle <CODE>
 * 2: Lines of the label, called with [vehicle], returns an array of texts <CODE>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["boomerang", {([_this select 0] call ewc_boomerang_fnc_getSources) isNotEqualTo []}, {["deaf 3 s"]}] call ewc_common_fnc_registerDebug
 *
 * Public: Yes
 */

params [["_id", "", [""]], ["_hasSystem", {false}, [{}]], ["_getLines", {[]}, [{}]]];

if (_id isEqualTo "") exitWith {};

GVAR(debugProviders) set [_id, [_hasSystem, _getLines]];
