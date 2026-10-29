#include "..\script_component.hpp"
/*
 * Author: Andx
 * Starts or stops watching projectiles on this machine, depending on whether a Boomerang is on. Every projectile
 * of the mission goes through the handler, so it only exists while there is a Boomerang to hear it.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_compat_boomerang_fnc_updateListening
 *
 * Public: No
 */

private _listen = GVAR(vehicles) isNotEqualTo [];

if (_listen && {GVAR(projectileHandler) < 0}) exitWith {
    GVAR(projectileHandler) = addMissionEventHandler ["ProjectileCreated", LINKFUNC(onFired)];
};

if (!_listen && {GVAR(projectileHandler) >= 0}) then {
    removeMissionEventHandler ["ProjectileCreated", GVAR(projectileHandler)];
    GVAR(projectileHandler) = -1;
};
