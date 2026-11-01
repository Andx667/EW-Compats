#include "..\script_component.hpp"
/*
 * Author: Andx
 * Gives a CUP drone (MQ-9, Pchela-1T) the spectrum signal that Crows gives its own drones, which is what makes a drone
 * jammable by the drone jammers. Crows lists only the vanilla drone bases, and these two derive from the plain UAV class.
 * SERVER ONLY. Does nothing for a drone that has a signal already, for example from the Crows setting with the jammable classes.
 *
 * Arguments:
 * 0: Drone <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_drone] call ewc_compat_cup_fnc_drones_initVehicle
 *
 * Public: No
 */

params [["_drone", objNull, [objNull]]];

if (isNull _drone || {!isServer} || {!GVAR(drones_enable)}) exitWith {};

// Editor-placed drones initialise before Crows has registered its server event handlers
[{CBA_missionTime > 0 && {!isNil CROWS_VAR_BEACONS} && {!isNil CROWS_VAR_FREQUENCY_RANGE}}, {
    params ["_drone"];

    if (isNull _drone || {!alive _drone}) exitWith {};

    private _beacons = missionNamespace getVariable [CROWS_VAR_BEACONS, []];

    if (_beacons findIf {_x#0 == _drone && {_x#3 == CROWS_BEACON_DRONE}} > -1) exitWith {};

    // Same as Crows does for its drones: a random frequency in the drone band, starting at 433 MHz
    private _band = missionNamespace getVariable CROWS_VAR_FREQUENCY_RANGE;
    private _frequency = 433 + random abs ((_band#2#0) - (_band#2#1));

    [CROWS_EVENT_ADD_BEACON, [_drone, _frequency, GVAR(drones_range), CROWS_BEACON_DRONE]] call CBA_fnc_serverEvent;
}, [_drone]] call CBA_fnc_waitUntilAndExecute;
