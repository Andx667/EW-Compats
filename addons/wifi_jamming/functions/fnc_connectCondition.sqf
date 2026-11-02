#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Connect condition of AE3 (AE3_network_fnc_addConnectCondition, id ewc_wifi_jamming). AE3 asks it before a laptop joins a
 * router (Network app, ACE menu) and every few seconds for a laptop that is connected (wireless sweep, which drops the
 * laptop when the answer is no), so one condition covers the connections that exist and the ones that are made.
 *
 * A wireless link works while the laptop is within the wireless range of its router. A jammer shortens that range by its
 * strength at the laptop or at the router, whichever is stronger: full strength (inside the effective radius) leaves no
 * range at all, half strength half of it, and none (outside the falloff band) all of it. A laptop in the falloff band of
 * a jammer therefore keeps a connection to a router that is close by, and loses one to a router far away.
 *
 * Registered on every machine, the answer of the server is the one that counts. Routers cascaded to another router are
 * left alone, like AE3 does.
 *
 * Arguments:
 * 0: Device that joins or stays <OBJECT>
 * 1: Router <OBJECT>
 *
 * Return Value:
 * [allowed, reason] <ARRAY>
 *
 * Example:
 * [_laptop, _router] call ewc_wifi_jamming_fnc_connectCondition
 *
 * Public: No
 */

params [["_device", objNull, [objNull]], ["_router", objNull, [objNull]]];

if (isNull _device || {isNull _router} || {_device getVariable [AE3_VAR_IS_ROUTER, false]}) exitWith {[true, ""]};

private _jammers = [];

{
    _y params ["_jammer", "_radFalloff", "_radEffective", "_enabled", "_capabilities"];

    if (_enabled && {WIFI_JAM_CAP in _capabilities} && {alive _jammer}) then {
        _jammers pushBack [_jammer, _radEffective, _radFalloff];
    };
} forEach (missionNamespace getVariable [CROWSEW_JAM_MAP_NAME, createHashMap]);

if (_jammers isEqualTo []) exitWith {[true, ""]};

private _strength = ([_router, _jammers] call FUNC(getJamStrength)) max ([_device, _jammers] call FUNC(getJamStrength));

if (_strength <= 0) exitWith {[true, ""]};

// AE3 checked the unjammed range before it asked us, the jammer only takes a share of it
private _range = [_router, _device] call AE3_network_fnc_getWirelessRange;

if (_strength < 1 && {(_device distance _router) <= (_range * (1 - _strength))}) exitWith {[true, ""]};

[false, LLSTRING(connection_jammed)]
