#include "..\script_component.hpp"
/*
 * Author: Andx
 * Handler of every projectile created on a machine that has a Boomerang to hear it (see fnc_updateListening).
 * Checks a bullet against the vehicles with a listening Boomerang and sends a report for each one that hears it.
 * A supersonic bullet is heard if its path passes close to the vehicle, a slower one only from short range.
 * It runs for every shot of the mission, so the cheap checks come first and the expensive ones only for the
 * few shots that are really heard.
 *
 * Arguments:
 * 0: Projectile <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_projectile] call ewc_compat_cup_boomerang_fnc_onFired
 *
 * Public: No
 */

params [["_projectile", objNull, [objNull]]];

// Projectiles of other machines are their machine's business, or the report would be sent twice
if (isNull _projectile || {!local _projectile}) exitWith {};

private _ammo = typeOf _projectile;
private _isBullet = GVAR(bulletCache) get _ammo;

if (isNil "_isBullet") then {
    _isBullet = _ammo isKindOf ["BulletBase", configFile >> "CfgAmmo"];
    GVAR(bulletCache) set [_ammo, _isBullet];
};

if (!_isBullet) exitWith {};

private _velocity = velocity _projectile;
private _speed = vectorMagnitude _velocity;

if (_speed < 1) exitWith {};

private _origin = getPosASL _projectile;
private _direction = _velocity vectorMultiply (1 / _speed);
private _supersonic = _speed >= BOOMERANG_SONIC_SPEED;

{
    private _vehicle = _x;
    private _toVehicle = (getPosASL _vehicle) vectorDiff _origin;
    private _distanceSqr = vectorMagnitudeSqr _toVehicle;
    private _along = _toVehicle vectorDotProduct _direction;

    // Too far away, going away from the vehicle, or the vehicle just reported a shot of the same burst
    if (
        _distanceSqr <= (BOOMERANG_MAX_RANGE * BOOMERANG_MAX_RANGE)
        && {_along > 0}
        && {CBA_missionTime - (_vehicle getVariable [QGVAR(lastReport), -1]) >= BOOMERANG_REPORT_INTERVAL}
    ) then {
        private _heard = if (_supersonic) then {
            private _miss = vectorMagnitude (_toVehicle vectorDiff (_direction vectorMultiply _along));

            _miss <= BOOMERANG_MISS_DISTANCE
        } else {
            _distanceSqr <= (BOOMERANG_SUBSONIC_RANGE * BOOMERANG_SUBSONIC_RANGE)
        };

        // Only now the more expensive checks: the state of the vehicle and who shot
        if (_heard && {_vehicle call FUNC(isReady)}) then {
            private _commander = effectiveCommander _vehicle;
            private _side = side group _commander;

            (getShotParents _projectile) params [["_shotVehicle", objNull], ["_instigator", objNull]];

            private _shooter = [_instigator, _shotVehicle] select isNull _instigator;

            // Vehicles without crew have nobody to report to. The shots of the own vehicle and its crew are not reported,
            // and neither are shots that start at the vehicle when the shooter is not known
            private _own = (vehicle _shooter == _vehicle) || {isNull _shooter && {_distanceSqr < 25}};
            private _friendly = !isNull _shooter && {((side group _shooter) getFriend _side) >= 0.6};

            if (!isNull _commander && {!_own} && {GVAR(friendlyFire) || {!_friendly}}) then {
                _vehicle setVariable [QGVAR(lastReport), CBA_missionTime];

                private _range = sqrt _distanceSqr;
                private _elevation = (-(_toVehicle select 2)) atan2 (vectorMagnitude [_toVehicle select 0, _toVehicle select 1]);

                // The real system is not exact, so neither is the report
                private _bearing = (_vehicle getDir _origin) + (random (2 * BOOMERANG_BEARING_ERROR)) - BOOMERANG_BEARING_ERROR;
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
} forEach GVAR(vehicles);
