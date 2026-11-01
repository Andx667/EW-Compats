#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Registers the Zeus modules to set and remove a BFT jammer with Zeus Enhanced, in the category of Crows.
 * Needs Zeus Enhanced, which Crows requires as well. Does nothing without it.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_bft_jamming_fnc_zeusRegister
 *
 * Public: No
 */

if (!hasInterface || {!isClass (configFile >> "CfgPatches" >> "zen_custom_modules")}) exitWith {};

{
    [ZEUS_CATEGORY, _x select 0, _x select 1, BFT_JAM_ICON] call zen_custom_modules_fnc_register;
} forEach [
    [LLSTRING(moduleAddBftJammer_displayName), {_this call FUNC(addBftJammerZeus)}],
    [LLSTRING(zeus_remove_displayName), {_this call FUNC(removeBftJammerZeus)}]
];
