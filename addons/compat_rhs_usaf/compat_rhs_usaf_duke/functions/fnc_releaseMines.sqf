#include "..\script_component.hpp"
/*
 * Author: Andx
 * Enables the simulation of the IEDs around a vehicle whose DUKE went offline. rhs_duke.sqf releases the IEDs it holds
 * with a plain enableSimulationGlobal at its end, which does nothing for IEDs that are not local to the machine of
 * the gunner, so they would stay disabled. IEDs another running DUKE still holds are left alone.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call ewc_compat_rhs_usaf_fnc_duke_releaseMines
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

if (isNull _vehicle) exitWith {};

// The DUKE was switched on again meanwhile and holds its IEDs
if (_vehicle getVariable [DUKE_STATE_VAR, false]) exitWith {};

// Other running DUKEs
private _others = (_vehicle nearEntities [["LandVehicle"], DUKE_EFFECTIVE_RADIUS * 2]) select {
    _x != _vehicle && {_x getVariable [DUKE_STATE_VAR, false]}
};

{
    private _mine = _x;

    if (
        !simulationEnabled _mine
        && {_mine isKindOf "PipeBombBase"}
        && {_others findIf {
            // The range a DUKE has left with one antenna destroyed
            private _hit = ((_x getHitPointDamage "HitDuke1") >= DUKE_ANTENNA_DESTROYED) || {(_x getHitPointDamage "HitDuke2") >= DUKE_ANTENNA_DESTROYED};

            _mine distance _x < DUKE_EFFECTIVE_RADIUS * ([1, DUKE_SINGLE_ANTENNA_SCALE] select _hit)
        } == -1}
    ) then {
        _mine enableSimulationGlobal true;
    };
} forEach (allMines inAreaArray [getPosWorld _vehicle, DUKE_EFFECTIVE_RADIUS, DUKE_EFFECTIVE_RADIUS]);
