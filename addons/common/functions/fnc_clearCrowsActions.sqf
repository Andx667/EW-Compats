#include "..\script_component.hpp"
/*
 * Author: Andx
 * Removes the activate/deactivate actions Crows adds to a jammer, and nothing else. The switch of a
 * compat addon can be an action of the vehicle as well, so removeAllActions would take that away too.
 *
 * Deprecated: set the public variable crowsEW_main_hideActions on the jammer instead, Crows then hides its
 * actions itself. ewc_common_fnc_addJammer does that for every jammer of ewc_common. Removed in 2.0.0.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_common_fnc_clearCrowsActions
 *
 * Public: Yes (deprecated)
 */

params [["_vehicle", objNull, [objNull]]];

WARNING_1("ewc_common_fnc_clearCrowsActions is deprecated and will be removed in 2.0.0. Set %1 on the jammer instead",CROWS_VAR_HIDE_ACTIONS);

{
    private _params = _vehicle actionParams _x;

    // Crows colours the title of its actions, ours are plain
    if (_params isNotEqualTo [] && {(_params select 0) find CROWS_ACTION_MARKER >= 0}) then {
        _vehicle removeAction _x;
    };
} forEach actionIDs _vehicle;
