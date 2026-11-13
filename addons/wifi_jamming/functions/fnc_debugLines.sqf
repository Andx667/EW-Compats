#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Lines of the debug overlay of ewc_common (ewc_common_debug) for an AE3 router or a laptop connected to one, see
 * fnc_registerDebug of ewc_common. A router shows its wireless range, how much of it a jammer leaves and its clients, a
 * laptop its router, the distance and whether the link is jammed.
 *
 * Arguments:
 * 0: Router or laptop <OBJECT>
 *
 * Return Value:
 * Lines <ARRAY> of <STRING>
 *
 * Example:
 * [_router] call ewc_wifi_jamming_fnc_debugLines
 *
 * Public: No
 */

params [["_object", objNull, [objNull]]];

private _jammers = GVAR(jammers) select {alive (_x select 0)};
private _routers = call AE3_network_fnc_getRouters;

if (_object in _routers) exitWith {
    private _range = [_object] call AE3_network_fnc_getWirelessRange;
    private _strength = [_object, _jammers] call FUNC(getJamStrength);
    private _clients = count ([_object] call AE3_network_fnc_getClients);

    if (_strength <= 0) exitWith {
        [format ["Wi-Fi router | range %1 m | %2 clients | not jammed", round _range, _clients]]
    };

    [format ["Wi-Fi router | range %1 m, jammed %2 m | jam %3%4 | %5 clients", round _range, round (_range * (1 - _strength)), round (_strength * 100), "%", _clients]]
};

private _routerIndex = _routers findIf {_object in ([_x] call AE3_network_fnc_getClients)};

if (_routerIndex == -1) exitWith {[]};

private _router = _routers select _routerIndex;
private _range = [_router, _object] call AE3_network_fnc_getWirelessRange;

([_object, _router, _jammers] call FUNC(getConnectionJam)) params ["_strength", "_jammed"];

[format [
    "Wi-Fi client of %1 | %2 m of %3 m | jam %4%5 | %6",
    getText (configOf _router >> "displayName"),
    round (_object distance _router),
    round _range,
    round (_strength * 100),
    "%",
    ["connected", "JAMMED, AE3 drops it in its next sweep"] select _jammed
]]
