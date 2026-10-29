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

// Crows adds the actions of a new jammer in its own handler of this event. Ours is registered in preInit, Crows' in
// postInit, so ours runs first and the actions would stay until the next update. A frame later they exist
[{
    params ["_jamMap"];

    {
        private _jammer = _y select 0;

        if (!isNull _jammer && {!isNull ([_jammer] call FUNC(getJammerConfig))}) then {
            _jammer call FUNC(clearCrowsActions);
        };
    } forEach _jamMap;
}, [_jamMap]] call CBA_fnc_execNextFrame;
