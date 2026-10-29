#include "..\script_component.hpp"
/*
 * Author: Andx
 * Removes the activate/deactivate actions Crows adds to the jammers that are in CfgEWC >> Jammers.
 *
 * Arguments:
 * 0: Jammer map <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_jamMap] call ewc_main_fnc_removeCrowsActions
 *
 * Public: No
 */

params [["_jamMap", createHashMap, [createHashMap]]];

{
    private _jammer = _y select 0;

    if (!isNull _jammer && {!isNull ([_jammer] call FUNC(getJammerConfig))}) then {
        _jammer call FUNC(clearCrowsActions);
    };
} forEach _jamMap;
