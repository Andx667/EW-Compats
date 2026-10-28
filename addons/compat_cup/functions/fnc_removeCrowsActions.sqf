#include "..\script_component.hpp"
/*
 * Author: Andx
 * Removes the activate/deactivate actions Crows adds to jammers from vehicles with a CUP DUKE.
 *
 * Arguments:
 * 0: Jammer map <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_jamMap] call ewc_compat_cup_fnc_removeCrowsActions
 *
 * Public: No
 */

params [["_jamMap", createHashMap, [createHashMap]]];

{
    private _jammer = _y select 0;

    if (!isNull _jammer && {([_jammer, SYSTEM_DUKE] call FUNC(getSources)) isNotEqualTo []}) then {
        _jammer call FUNC(clearCrowsActions);
    };
} forEach _jamMap;
