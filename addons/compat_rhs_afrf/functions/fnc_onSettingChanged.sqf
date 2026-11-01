#include "..\script_component.hpp"
/*
 * Author: Andx
 * Brings the jammer of every R-142N in line with the settings (on/off, radius, jammed signals) when one of them is changed in the game.
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
 * call ewc_compat_rhs_afrf_fnc_onSettingChanged
 *
 * Public: No
 */

if (!isServer || {CBA_missionTime <= 0}) exitWith {};

{
    [_x] call FUNC(syncJammer);
} forEach (vehicles select {getNumber (configOf _x >> QGVAR(jammer)) == 1});
