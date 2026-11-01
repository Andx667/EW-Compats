#include "..\script_component.hpp"
/*
 * Author: Andx
 * Brings the jammer of every Dingo with a CG13 in line with the setting when it is changed in the game: a CG13 that is switched on starts jamming when the setting is switched on again, and stops when it is switched off.
 * Called by the settings of the addon when one of them changes. Nothing to do at the start, the vehicles read
 * the settings when they are switched.
 * SERVER ONLY.
 *
 * Arguments:
 * None (the new value of the setting is passed, it is not needed)
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_compat_bwa3_fnc_onSettingChanged
 *
 * Public: No
 */

if (!isServer || {CBA_missionTime <= 0}) exitWith {};

{
    // The switch of BWA3 is what the crew wants, handleToggle applies the setting to it
    [_x, _x getVariable ["BWA3_Dingo2_ECM_on", false], ["", "disabled"] select !GVAR(enableCG13)] call FUNC(handleToggle);
} forEach (vehicles select {getNumber (configOf _x >> "BWA3_hasECM") == 1});
