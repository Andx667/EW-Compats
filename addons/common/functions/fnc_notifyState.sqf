#include "..\script_component.hpp"
/*
 * Author: Andx
 * Tells the people in a vehicle that one of its systems (a jammer, a shot finder) was switched on or off. Raises the
 * event ewc_common_stateChanged on every machine, and the ones with the vehicle's occupants show a hint (fnc_onStateChanged).
 * Call it where the state changes, on the server, and only when it really changed.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Name of the system, shown as it is <STRING>
 * 2: System is on <BOOL>
 * 3: Reason for a system that switched itself off, the end of the string ewc_common_reason_<reason> <STRING> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "DUKE", false, "engine"] call ewc_common_fnc_notifyState
 *
 * Public: Yes
 */

params [["_vehicle", objNull, [objNull]], ["_name", "", [""]], ["_on", false, [false]], ["_reason", "", [""]]];

if (isNull _vehicle) exitWith {};

[QGVAR(stateChanged), [_vehicle, _name, _on, _reason]] call CBA_fnc_globalEvent;
