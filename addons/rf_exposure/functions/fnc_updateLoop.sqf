#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Starts or stops the loop of the exposure. It runs while the feature is on and a jammer is on or there is exposure
 * left, and costs nothing otherwise. Called when a setting changes, when a jammer is switched, and at the start.
 * The arguments (the value of a setting) are not used.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_rf_exposure_fnc_updateLoop
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

// The feature was switched off
if !(missionNamespace getVariable [QGVAR(enable), false]) exitWith {
    if (GVAR(loopHandle) >= 0) then {
        [GVAR(loopHandle)] call CBA_fnc_removePerFrameHandler;
        GVAR(loopHandle) = -1;
    };

    call FUNC(reset);
};

if (GVAR(loopHandle) >= 0) exitWith {};

// Nothing to do while no jammer is on
if (GVAR(exposure) <= 0 && {GVAR(jammers) findIf {JAMMER_COUNTS(_x)} == -1}) exitWith {};

GVAR(lastTime) = CBA_missionTime;
GVAR(loopHandle) = [LINKFUNC(exposureLoop), LOOP_INTERVAL] call CBA_fnc_addPerFrameHandler;
