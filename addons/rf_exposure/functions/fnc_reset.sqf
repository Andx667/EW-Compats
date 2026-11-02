#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Ends the exposure: back to 0, our fatigue factor is taken away from ACE advanced fatigue, the hints can come again.
 * The pain is left to fade, as ACE does with any pain.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_rf_exposure_fnc_reset
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

GVAR(exposure) = 0;
GVAR(hintedHeadache) = false;
GVAR(hintedFatigue) = false;

if (GVAR(dutyFactor) != 1) then {
    if (!isNil "ace_advanced_fatigue_fnc_removeDutyFactor") then {
        [FATIGUE_FACTOR_ID] call ace_advanced_fatigue_fnc_removeDutyFactor;
    };

    GVAR(dutyFactor) = 1;
};
