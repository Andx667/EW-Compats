#include "..\script_component.hpp"
/*
 * Author: Andx
 * Enables the simulation of the IEDs around a vehicle whose DUKE went offline. rhs_duke.sqf releases the IEDs it holds
 * with a plain enableSimulationGlobal at its end, which does nothing for IEDs that are not local to the machine of
 * the gunner, so they would stay disabled. IEDs another jammer still holds are left alone.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_compat_rhs_usaf_fnc_releaseMines
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

if (isNull _vehicle) exitWith {};

// The DUKE was switched on again meanwhile and holds its IEDs
if (_vehicle getVariable [DUKE_STATE_VAR, false]) exitWith {};

// Other jammers that disable IEDs: running RHS DUKEs, CG13 and CUP DUKEs, each with its range
private _others = (_vehicle nearEntities [["LandVehicle", "Air", "Ship"], 150]) select {
    _x != _vehicle
    && {(_x getVariable [DUKE_STATE_VAR, false]) || {_x getVariable ["BWA3_Dingo2_ECM_on", false]} || {_x getVariable ["ewc_compat_cup_duke_on", false]}}
};

{
    private _mine = _x;

    if (
        !simulationEnabled _mine
        && {_mine isKindOf "PipeBombBase"}
        && {_others findIf {
            _mine distance _x < ([DUKE_EFFECTIVE_RADIUS, ECM_EFFECTIVE_RADIUS] select (_x getVariable ["BWA3_Dingo2_ECM_on", false]))
        } == -1}
    ) then {
        _mine enableSimulationGlobal true;
    };
} forEach (allMines inAreaArray [getPosWorld _vehicle, DUKE_EFFECTIVE_RADIUS, DUKE_EFFECTIVE_RADIUS]);
