#include "..\script_component.hpp"
/*
 * Author: Andx
 * Per frame handler running on the server while a Boomerang is on. Switches a Boomerang off when its vehicle is
 * destroyed, its antenna is hidden, its engine is stopped or the Boomerang is disabled in the settings.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_compat_boomerang_fnc_loop
 *
 * Public: No
 */

{
    private _reason = [_x] call FUNC(getBlockReason);

    if (_reason isNotEqualTo "") then {
        [_x, false, _reason] call FUNC(setState);
    };
} forEach +GVAR(vehicles);

// Deleted vehicles leave nulls in the list
if (GVAR(vehicles) findIf {isNull _x} != -1) then {
    GVAR(vehicles) = GVAR(vehicles) select {!isNull _x};
    [QGVAR(listChanged), [GVAR(vehicles)]] call CBA_fnc_globalEvent;
};

if (GVAR(vehicles) isEqualTo []) then {
    [GVAR(loopHandle)] call CBA_fnc_removePerFrameHandler;
    GVAR(loopHandle) = -1;
};
