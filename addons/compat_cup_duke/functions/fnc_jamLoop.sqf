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
 * call ewc_compat_cup_duke_fnc_jamLoop
 *
 * Public: No
 */

{
    private _vehicle = objectFromNetId _x;

    if (!alive _vehicle) then {
        // Destroyed or deleted. Crows removes the jammer by itself
        [_x] call FUNC(releaseMines);
        GVAR(active) deleteAt _x;

        if (!isNull _vehicle) then {
            _vehicle setVariable [QGVAR(on), false, true];
        };
    } else {
        if (!(_vehicle call FUNC(canActivate))) then {
            [_vehicle, false] call FUNC(setJammer);
        } else {
            // Antennas hidden or shown again change the range, and Crows can only replace the jammer for that
            private _state = _vehicle getVariable [QEGVAR(main,jammerState), []];

            if (_state isNotEqualTo [] && {(_state select 1) != (_vehicle call FUNC(getRadius))}) then {
                [_vehicle, true] call FUNC(setJammer);
            };

            if (GVAR(jamMines)) then {
                [_x, _vehicle] call FUNC(updateMines);
            } else {
                [_x] call FUNC(releaseMines);
            };
        };
    };
} forEach (keys GVAR(active));

if (count GVAR(active) == 0) then {
    [GVAR(loopHandle)] call CBA_fnc_removePerFrameHandler;
    GVAR(loopHandle) = -1;
};
