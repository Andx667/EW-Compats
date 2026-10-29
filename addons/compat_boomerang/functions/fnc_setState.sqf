#include "..\script_component.hpp"
/*
 * Author: Andx
 * Switches the Boomerang of a vehicle. Active vehicles are in a list every machine gets, so the machine of a
 * shooter can check its shot against them.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Boomerang on <BOOL>
 * 2: Why it is switched off by itself, see fnc_getBlockReason <STRING> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, true] call ewc_compat_boomerang_fnc_setState
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_enabled", false, [false]], ["_reason", "", [""]]];

private _wasOn = _vehicle getVariable [QGVAR(on), false];

_vehicle setVariable [QGVAR(on), _enabled, true];

if (_enabled != _wasOn) then {
    [_vehicle, SYSTEM_NAME, _enabled, _reason] call EFUNC(main,notifyState);
};

if (_enabled) then {
    GVAR(vehicles) pushBackUnique _vehicle;

    if (GVAR(loopHandle) < 0) then {
        GVAR(loopHandle) = [LINKFUNC(loop), LOOP_INTERVAL] call CBA_fnc_addPerFrameHandler;
    };
} else {
    GVAR(vehicles) = GVAR(vehicles) - [_vehicle];
};

[QGVAR(listChanged), [GVAR(vehicles)]] call CBA_fnc_globalEvent;
