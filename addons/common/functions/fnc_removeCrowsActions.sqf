#include "..\script_component.hpp"
/*
 * Author: Andx
 * Removes the activate/deactivate actions Crows adds to our jammers (the ones registered by fnc_addJammer). Crows only
 * adds them to a jammer that is new to a machine, so only the jammers that were not cleaned before are looked at. That
 * keeps a switch of one jammer from walking the actions of all of them.
 *
 * Arguments:
 * 0: Jammer map <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_jamMap] call ewc_common_fnc_removeCrowsActions
 *
 * Public: No
 */

params [["_jamMap", createHashMap, [createHashMap]]];

// Crows adds the actions of a new jammer in its own handler of this event. Ours is registered in preInit, Crows' in
// postInit, so ours runs first and the actions would stay until the next update. A frame later they exist
[{
    params ["_jamMap"];

    private _cleaned = GVAR(cleanedJammers);

    // A jammer that is gone is cleaned again when it comes back, for example with another radius
    {
        if !(_x in _jamMap) then {
            _cleaned deleteAt _x;
        };
    } forEach (keys _cleaned);

    {
        private _jammer = _y select 0;

        if (!(_x in _cleaned) && {!isNull _jammer} && {_jammer getVariable [QGVAR(isJammer), false]}) then {
            _jammer call FUNC(clearCrowsActions);
            _cleaned set [_x, true];
        };
    } forEach _jamMap;
}, [_jamMap]] call CBA_fnc_execNextFrame;
