#include "..\script_component.hpp"
/*
 * Author: Andx
 * Fired handler of every unit, on the machine the shot comes from. Checks a bullet against the vehicles with a
 * listening Boomerang and sends a report for each one that hears it.
 * A supersonic bullet is heard if its path passes close to the vehicle, a slower one only from short range.
 *
 * Arguments:
 * Arguments of the Fired event handler
 *
 * Return Value:
 * None
 *
 * Example:
 * _this call ewc_compat_cup_fnc_onFired
 *
 * Public: No
 */

params ["_unit", "", "", "", "_ammo", "", "_projectile", "_gunner"];

// Runs for every shot of the mission, so leave as early as possible
if (GVAR(boomerangVehicles) isEqualTo [] || {isNull _projectile} || {!(_ammo isKindOf "BulletBase")}) exitWith {};

private _velocity = velocity _projectile;
private _speed = vectorMagnitude _velocity;

if (_speed < 1) exitWith {};

private _shooter = [_gunner, _unit] select (isNull _gunner);
private _origin = getPosASL _projectile;
private _direction = _velocity vectorMultiply (1 / _speed);
private _shooterPos = getPosASL _unit;

{
    private _vehicle = _x;

    if (vehicle _shooter != _vehicle && {_vehicle call FUNC(isBoomerangReady)}) then {
        private _toVehicle = (getPosASL _vehicle) vectorDiff _origin;
        private _along = _toVehicle vectorDotProduct _direction;
        private _distance = vectorMagnitude _toVehicle;

        // Shots going away from the vehicle or from too far away are not heard
        if (_along > 0 && {_distance <= BOOMERANG_MAX_RANGE}) then {
            private _miss = vectorMagnitude (_toVehicle vectorDiff (_direction vectorMultiply _along));
            private _heard = if (_speed >= BOOMERANG_SONIC_SPEED) then {
                _miss <= GVAR(missDistance)
            } else {
                _distance <= BOOMERANG_SUBSONIC_RANGE
            };

            private _commander = effectiveCommander _vehicle;
            private _side = side group _commander;

            // Vehicles without crew have nobody to report to
            if (
                _heard
                && {!isNull _commander}
                && {GVAR(friendlyFire) || {((side group _shooter) getFriend _side) < 0.6}}
                && {CBA_missionTime - (_vehicle getVariable [QGVAR(lastReport), -1]) >= BOOMERANG_REPORT_INTERVAL}
            ) then {
                _vehicle setVariable [QGVAR(lastReport), CBA_missionTime];

                private _range = (getPosASL _vehicle) vectorDistance _shooterPos;
                private _elevation = (((_shooterPos select 2) - ((getPosASL _vehicle) select 2)) atan2 _range) max -90 min 90;

                // The real system is not exact, so neither is the report
                private _bearing = (_vehicle getDir _unit) + (random (2 * BOOMERANG_BEARING_ERROR)) - BOOMERANG_BEARING_ERROR;
                private _reportedRange = _range * (1 + (random (2 * BOOMERANG_RANGE_ERROR)) - BOOMERANG_RANGE_ERROR);

                _bearing = (_bearing + 360) % 360;

                private _clock = round ((((_bearing - getDir _vehicle) + 360) % 360) / 30);

                [QGVAR(shotDetected), [
                    _vehicle,
                    _vehicle getPos [_reportedRange, _bearing],
                    [_clock, 12] select (_clock == 0),
                    round (_reportedRange / 10) * 10,
                    round _bearing,
                    [1, [2, 0] select (_elevation > BOOMERANG_ELEVATION_LIMIT)] select (abs _elevation > BOOMERANG_ELEVATION_LIMIT),
                    _side
                ]] call CBA_fnc_globalEvent;
            };
        };
    };
} forEach GVAR(boomerangVehicles);
