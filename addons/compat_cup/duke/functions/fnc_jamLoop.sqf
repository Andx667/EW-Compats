#include "..\script_component.hpp"
/*
 * Author: Andx
 * Per frame handler running on the server while a DUKE is on. Switches a DUKE off when its vehicle is
 * destroyed, its antennas are hidden or its engine is stopped, and keeps the mines in range jammed.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_compat_cup_fnc_duke_jamLoop
 *
 * Public: No
 */

{
    private _vehicle = objectFromNetId _x;

    if (!alive _vehicle) then {
        // Destroyed or deleted. Crows removes the jammer by itself
        [_x] call FUNC(duke_releaseMines);
        GVAR(duke_active) deleteAt _x;

        if (!isNull _vehicle) then {
            _vehicle setVariable [QGVAR(duke_on), false, true];
        };
    } else {
        private _reason = _vehicle call FUNC(duke_getBlockReason);

        if (_reason isNotEqualTo "") then {
            [_vehicle, false, _reason] call FUNC(duke_setJammer);
        } else {
            // Antennas hidden or shown again change the range, and Crows can only replace the jammer for that
            private _state = _vehicle getVariable [QEGVAR(common,jammerState), []];

            if (_state isNotEqualTo [] && {(_state select 1) != (_vehicle call FUNC(duke_getRadius))}) then {
                [_vehicle, true] call FUNC(duke_setJammer);
            };

            if (GVAR(duke_jamMines)) then {
                [_x, _vehicle] call FUNC(duke_updateMines);
            } else {
                [_x] call FUNC(duke_releaseMines);
            };
        };
    };
} forEach (keys GVAR(duke_active));

if (count GVAR(duke_active) == 0) then {
    [GVAR(duke_loopHandle)] call CBA_fnc_removePerFrameHandler;
    GVAR(duke_loopHandle) = -1;
};
