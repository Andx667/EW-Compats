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
 * call ewc_compat_cup_fnc_boomerangLoop
 *
 * Public: No
 */

{
    if (!([_x, SYSTEM_BOOMERANG] call FUNC(canActivate))) then {
        [_x, false] call FUNC(setBoomerang);
    };
} forEach +GVAR(boomerangVehicles);

// Deleted vehicles leave nulls in the list
if (GVAR(boomerangVehicles) findIf {isNull _x} != -1) then {
    GVAR(boomerangVehicles) = GVAR(boomerangVehicles) select {!isNull _x};
    publicVariable QGVAR(boomerangVehicles);
    [QGVAR(listChanged), [GVAR(boomerangVehicles)]] call CBA_fnc_globalEvent;
};

if (GVAR(boomerangVehicles) isEqualTo []) then {
    [GVAR(boomerangLoopHandle)] call CBA_fnc_removePerFrameHandler;
    GVAR(boomerangLoopHandle) = -1;
};
