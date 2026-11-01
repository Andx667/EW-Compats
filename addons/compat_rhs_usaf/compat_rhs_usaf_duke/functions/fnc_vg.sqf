#include "..\script_component.hpp"
/*
 * Author: Andx
 * Replaces rhs_fnc_duke_vg, the function RHS runs when the DUKE antenna of a vehicle is hidden or shown (the
 * onPhaseChanged of its animation source, also the Virtual Garage). RHS takes the weapon of the switched off DUKE away
 * and nothing else, so a DUKE that is on keeps its weapon and its jammer: the crew can still switch it, and when it is
 * switched off the weapon of the off state comes back. This function takes both weapons away, switches the DUKE off
 * and asks the server to sync the jammer, which tells the crew that the antenna is hidden. Shown again, the antenna
 * gives the crew the weapon of the off state, like RHS does.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Phase of the animation source, 1 is hidden <NUMBER>
 * 2: Turret of the weapon, [-1] is the driver, RHS passes [0,0] for the tanks <ARRAY> (default: [-1])
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, 1] call rhs_fnc_duke_vg
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_phase", 0, [0]], ["_turret", [-1], [[]]]];

if (isNull _vehicle) exitWith {};

if (_phase > 0.5) then {
    _vehicle removeWeaponTurret ["rhsusf_weap_duke", _turret];
    _vehicle removeWeaponTurret ["rhsusf_weap_duke_on", _turret];

    // The off handler of rhs_duke.sqf, it ends the script and sets the state variable. It does nothing where the vehicle is not local
    if (local _vehicle && {_vehicle getVariable [DUKE_STATE_VAR, false]}) then {
        [_vehicle, 0] spawn rhs_fnc_duke_jammer;
    };
} else {
    if ((["rhsusf_weap_duke", "rhsusf_weap_duke_on"] arrayIntersect (_vehicle weaponsTurret _turret)) isEqualTo []) then {
        _vehicle addWeaponTurret ["rhsusf_weap_duke", _turret];
    };
};

// RHS sets its state variable in a spawned script, give it time before the server reads it
[{
    [QGVAR(syncJammer), _this] call CBA_fnc_serverEvent;
}, [_vehicle], DUKE_SYNC_DELAY] call CBA_fnc_waitAndExecute;
