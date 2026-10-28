#include "..\script_component.hpp"
/*
 * Author: Andx
 * Checks if the Boomerang of a vehicle is listening: switched on and usable, not deafened by the weapons of the
 * vehicle and not faster than the real system works.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Listening <BOOL>
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_isBoomerangReady
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

!isNull _vehicle
    && {_vehicle getVariable [QGVAR(boomerangOn), false]}
    && {CBA_missionTime >= (_vehicle getVariable [QGVAR(deafUntil), 0])}
    && {speed _vehicle <= BOOMERANG_MAX_SPEED}
    && {[_vehicle, SYSTEM_BOOMERANG] call FUNC(canActivate)}
