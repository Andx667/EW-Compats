#include "..\script_component.hpp"
/*
 * Author: Andx
 * Adds the scroll wheel actions to switch a registered system (fnc_registerSwitch) of a vehicle on and off. They raise
 * the server event of the system with [vehicle, switch on]. Call it where the vehicle is initialised, on every machine
 * with an interface.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Id of the system <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "duke"] call ewc_common_fnc_addSwitchActions
 *
 * Public: Yes
 */

params [["_vehicle", objNull, [objNull]], ["_id", "", [""]]];

private _switch = GVAR(switches) getOrDefault [_id, []];

if (isNull _vehicle || {_switch isEqualTo []}) exitWith {};

_switch params ["", "", "", "_titleActivate", "_titleDeactivate"];

{
    _x params ["_turnOn", "_title"];

    _vehicle addAction [
        localize _title,
        {
            params ["_vehicle", "", "", "_arguments"];
            _arguments params ["_turnOn", "_id"];

            [(GVAR(switches) get _id) select 0, [_vehicle, _turnOn]] call CBA_fnc_serverEvent;
        },
        [_turnOn, _id],
        6,
        false,
        true,
        "",
        format ["[_target, _this, %1, true, '%2'] call %3", _turnOn, _id, QFUNC(canToggle)],
        5
    ];
} forEach [[true, _titleActivate], [false, _titleDeactivate]];
