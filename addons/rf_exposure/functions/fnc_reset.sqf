#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Ends the exposure: back to 0, our fatigue factor is taken away from ACE advanced fatigue, the hints can come again.
 * The pain is left to fade, as ACE does with any pain.
 *
 * Arguments:
 * 0: Unit the exposure belonged to <OBJECT> (default: ACE_player)
 *
 * Return Value:
 * None
 *
 * Raises the event ewc_rf_exposure_API_stageChanged if there was a stage.
 *
 * Example:
 * [ACE_player] call ewc_rf_exposure_fnc_reset
 *
 * Public: No
 */

params [["_unit", ACE_player, [objNull]]];

if (!hasInterface) exitWith {};

GVAR(exposure) = 0;
GVAR(hintedHeadache) = false;
GVAR(hintedFatigue) = false;

if (GVAR(stage) != 0) then {
    GVAR(stage) = 0;

    [QGVAR(API_stageChanged), [_unit, 0]] call CBA_fnc_localEvent;
};

if (GVAR(dutyFactor) != 1) then {
    if (!isNil "ace_advanced_fatigue_fnc_removeDutyFactor") then {
        [FATIGUE_FACTOR_ID] call ace_advanced_fatigue_fnc_removeDutyFactor;
    };

    GVAR(dutyFactor) = 1;
};
