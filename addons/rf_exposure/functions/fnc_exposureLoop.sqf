#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Per frame handler of the exposure of the local player. The exposure goes from 0 to 1 at the rate of the nearest jammer
 * (fnc_getRate) and back to 0 over the recovery time. Somebody in a vehicle is safe, so there is no rate then.
 * Ends itself when no jammer is on and the exposure is gone, fnc_updateLoop starts it again.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_rf_exposure_fnc_exposureLoop
 *
 * Public: No
 */

private _unit = ACE_player;

// The time since the last update, limited so a long pause does not count as a long exposure
private _deltaTime = (CBA_missionTime - GVAR(lastTime)) max 0 min 5;
GVAR(lastTime) = CBA_missionTime;

if (isNull _unit) exitWith {};

// Anybody inside of a vehicle is safe, the crew of the jammer too
private _rate = if (alive _unit && {isNull objectParent _unit}) then {
    [_unit] call FUNC(getRate)
} else {
    0
};

GVAR(exposure) = if (_rate > 0) then {
    (GVAR(exposure) + _rate * _deltaTime) min 1
} else {
    (GVAR(exposure) - _deltaTime / GVAR(recoveryTime)) max 0
};

[_unit, _deltaTime] call FUNC(applyEffects);

// A destroyed jammer stays on in the jamMap until the cleanup of Crows, it does not keep the loop running
if (GVAR(exposure) <= 0 && {GVAR(jammers) findIf {JAMMER_COUNTS(_x)} == -1}) then {
    [GVAR(loopHandle)] call CBA_fnc_removePerFrameHandler;
    GVAR(loopHandle) = -1;
};
