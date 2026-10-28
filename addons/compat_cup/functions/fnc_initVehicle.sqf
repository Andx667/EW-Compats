#include "..\script_component.hpp"
/*
 * Author: Andx
 * Prepares a vehicle with a CUP DUKE antenna: scroll wheel actions on every machine and, on the server,
 * a disabled Crows radio jammer.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_initVehicle
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

if ((_vehicle call FUNC(getDukeSources)) isEqualTo []) exitWith {};

if (hasInterface) then {
    _vehicle addAction [
        LLSTRING(activate),
        {[QGVAR(toggle), [_this select 0, true]] call CBA_fnc_serverEvent},
        nil,
        6,
        false,
        true,
        "",
        QUOTE([ARR_4(_target,_this,true,true)] call FUNC(canToggle)),
        5
    ];

    _vehicle addAction [
        LLSTRING(deactivate),
        {[QGVAR(toggle), [_this select 0, false]] call CBA_fnc_serverEvent},
        nil,
        6,
        false,
        true,
        "",
        QUOTE([ARR_4(_target,_this,false,true)] call FUNC(canToggle)),
        5
    ];
};

if (!isServer) exitWith {};

// Editor-placed vehicles initialise before Crows has registered its server event handlers
[{CBA_missionTime > 0}, LINKFUNC(registerJammer), [_vehicle]] call CBA_fnc_waitUntilAndExecute;
