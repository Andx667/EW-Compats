#include "..\script_component.hpp"
/*
 * Author: Andx
 * Adds the scroll wheel actions that switch the Boomerang on and off to a vehicle. The condition is checked
 * by fnc_canToggle, the request goes to the server.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_compat_boomerang_fnc_addActions
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

{
    _x params ["_turnOn", "_key"];

    _vehicle addAction [
        localize format ["STR_ewc_compat_boomerang_%1", _key],
        {
            params ["_vehicle", "", "", "_turnOn"];

            [QGVAR(toggle), [_vehicle, _turnOn]] call CBA_fnc_serverEvent;
        },
        _turnOn,
        6,
        false,
        true,
        "",
        format ["[_target, _this, %1, true] call %2", _turnOn, QFUNC(canToggle)],
        5
    ];
} forEach [[true, "activate"], [false, "deactivate"]];
