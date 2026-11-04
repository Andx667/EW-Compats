#include "..\script_component.hpp"
/*
 * Author: Andx
 * Zeus module "Acoustic Drone Sensor": asks for the side in a ZEN dialog and makes the selected object, or a data
 * terminal placed at the position, an acoustic sensor of that side.
 *
 * Arguments:
 * 0: Position the module was placed at, ASL <ARRAY>
 * 1: Object the module was placed on <OBJECT> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [getPosASL player, objNull] call ewc_acoustic_fnc_zeusAddSensor
 *
 * Public: No
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_sensor", objNull, [objNull]]];

private _onConfirm = {
    params ["_dialogResult", "_in"];
    _dialogResult params ["_sideIndex"];
    _in params [["_pos", [0, 0, 0], [[]], 3], ["_sensor", objNull, [objNull]]];

    // No object selected: place a data terminal at the position, Zeus can edit it
    if (isNull _sensor) then {
        _sensor = createVehicle [SENSOR_PROP, ASLToAGL _pos, [], 0, "CAN_COLLIDE"];

        ["zen_common_addObjects", [[_sensor], objNull]] call CBA_fnc_serverEvent;
    };

    [_sensor, SENSOR_SIDES select _sideIndex] call FUNC(addSensor);
};

[
    LLSTRING(moduleAddSensor_displayName),
    [
        [
            "COMBO",
            [LLSTRING(module_side_displayName), LLSTRING(module_side_tooltip)],
            [
                [SENSOR_SIDE_WEST, SENSOR_SIDE_EAST, SENSOR_SIDE_INDEPENDENT],
                [LLSTRING(side_west), LLSTRING(side_east), LLSTRING(side_independent)],
                SENSOR_SIDE_WEST
            ]
        ]
    ],
    _onConfirm,
    {},
    [_pos, _sensor]
] call zen_dialog_fnc_create;
