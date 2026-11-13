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
 * left alone, like AE3 does. Uses only the public API of AE3 (getWirelessRange, getRouters, getClients).
 *
 * Raises the event ewc_wifi_jamming_API_connectionJammed on the server for a connected laptop that is refused: AE3 drops it in
 * the same call of its wireless sweep, so one frame later the laptop is no longer a child of the router. A refusal that
 * does not end a connection (a laptop that tries to connect) raises nothing.
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

if (isNull _device || {isNull _router}) exitWith {[true, ""]};

if (GVAR(jammers) isEqualTo []) exitWith {[true, ""]};

// A destroyed jammer stays in the jamMap until the cleanup of Crows
private _jammers = GVAR(jammers) select {alive (_x select 0)};

if (_jammers isEqualTo []) exitWith {[true, ""]};

// Asked only once a jammer is on, so there is no cost without one. The sweep of AE3 never passes a router (getClients
// leaves them out), but a cascade from the ACE menu can
if (_device in (call AE3_network_fnc_getRouters)) exitWith {[true, ""]};

([_device, _router, _jammers] call FUNC(getConnectionJam)) params ["_strength", "_jammed"];

if (!_jammed) exitWith {[true, ""]};

// A laptop that is a client of the router is connected and dropped by the sweep, one that is not tries to connect
if (isServer && {!(_device getVariable [QGVAR(jamPending), false])} && {_device in ([_router] call AE3_network_fnc_getClients)}) then {
    _device setVariable [QGVAR(jamPending), true];

    [{
        params ["_device", "_router", "_strength"];

        _device setVariable [QGVAR(jamPending), nil];

        if !(isNull _device || {_device in ([_router] call AE3_network_fnc_getClients)}) then {
            // For missions and mods that follow the connections: [laptop, router, strength 0 to 1], on the server
            [QGVAR(API_connectionJammed), [_device, _router, _strength]] call CBA_fnc_localEvent;
        };
    }, [_device, _router, _strength]] call CBA_fnc_execNextFrame;
};

// The answer of a client is only shown on that client (hint of the ACE menu), the one of the server goes to the player
[false, [LLSTRING(connection_jammed), WIFI_JAM_REASON_SERVER] select isServer]
