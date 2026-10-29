#include "..\script_component.hpp"
/*
 * Author: Andx
 * Removes the activate/deactivate actions Crows adds to a jammer, and nothing else. The switch of a
 * compat addon can be an action of the vehicle as well, so removeAllActions would take that away too.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_main_fnc_clearCrowsActions
 *
 * Public: Yes
 */

params [["_vehicle", objNull, [objNull]]];

{
    private _params = _vehicle actionParams _x;

    // Crows colours the title of its actions, ours are plain
    if (_params isNotEqualTo [] && {(_params select 0) find CROWS_ACTION_MARKER >= 0}) then {
        _vehicle removeAction _x;
    };
} forEach actionIDs _vehicle;
