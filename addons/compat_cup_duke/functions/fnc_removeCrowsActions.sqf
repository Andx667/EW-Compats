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
 * [_jamMap] call ewc_compat_cup_duke_fnc_removeCrowsActions
 *
 * Public: No
 */

params [["_jamMap", createHashMap, [createHashMap]]];

// Crows adds the actions of a new jammer in its own handler of this event, which may run after this one.
// A frame later they exist
[{
    params ["_jamMap"];

    {
        private _jammer = _y select 0;

        if (!isNull _jammer && {([_jammer, SYSTEM_DUKE] call EFUNC(compat_cup,getSources)) isNotEqualTo []}) then {
            _jammer call EFUNC(common,clearCrowsActions);
        };
    } forEach _jamMap;
}, [_jamMap]] call CBA_fnc_execNextFrame;
