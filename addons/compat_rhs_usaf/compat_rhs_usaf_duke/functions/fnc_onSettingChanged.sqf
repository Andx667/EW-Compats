#include "..\script_component.hpp"
/*
 * Author: Andx
 * Brings the jammer of every vehicle with a DUKE in line with the setting when it is changed in the game.
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
 * call ewc_compat_rhs_usaf_fnc_duke_onSettingChanged
 *
 * Public: No
 */

if (!isServer || {CBA_missionTime <= 0}) exitWith {};

{
    [_x] call FUNC(duke_syncJammer);
} forEach (vehicles select {getText (configOf _x >> "rhs_duke_type") isNotEqualTo ""});
