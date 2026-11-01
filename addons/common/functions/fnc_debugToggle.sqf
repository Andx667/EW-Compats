#include "..\script_component.hpp"
/*
 * Author: Andx
 * Switches the debug overlay (fnc_debugDraw) on or off. Called by the setting ewc_common_debug.
 *
 * Arguments:
 * 0: Overlay on <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call ewc_common_fnc_debugToggle
 *
 * Public: No
 */

params [["_enabled", false, [false]]];

if (!hasInterface) exitWith {};

if (GVAR(debugHandle) >= 0) then {
    removeMissionEventHandler ["Draw3D", GVAR(debugHandle)];
    GVAR(debugHandle) = -1;
};

if (_enabled) then {
    GVAR(debugHandle) = addMissionEventHandler ["Draw3D", LINKFUNC(debugDraw)];
};
