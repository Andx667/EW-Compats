#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Per frame handler running on the server while a Wi-Fi jammer is on. Ends every AE3 connection that the jamming cuts.
 *
 * A wireless link works while the laptop is within the wireless range of its router. A jammer shortens that range by its
 * strength at the laptop or at the router, whichever is stronger: full strength (inside the effective radius) leaves no
 * range at all, half strength half of it, and none (outside the falloff band) all of it. A laptop in the falloff band of
 * a jammer therefore keeps a connection to a router that is close by, and loses one to a router far away.
 *
 * A dropped laptop loses its address, as if it had left the range, and has to connect again. AE3 lets it connect from the
 * Network app or the ACE menu without a look at the jamming, so a new connection of a jammed laptop lasts up to one
 * interval before it is dropped again. Cascaded routers are left alone, like AE3 does.
 *
 * Raises the event ewc_wifi_jamming_connectionJammed on the server for every connection it ends.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_wifi_jamming_fnc_jamLoop
 *
 * Public: No
 */

private _jammers = [];

{
    _y params ["_jammer", "_radFalloff", "_radEffective", "_enabled", "_capabilities"];

    if (_enabled && {WIFI_JAM_CAP in _capabilities} && {alive _jammer}) then {
        _jammers pushBack [_jammer, _radEffective, _radFalloff];
    };
} forEach CROWSEW_JAM_MAP;

// The last Wi-Fi jammer was switched off or removed
if (_jammers isEqualTo []) exitWith {
    [GVAR(loopHandle)] call CBA_fnc_removePerFrameHandler;
    GVAR(loopHandle) = -1;
};

{
    private _router = _x;
    private _clients = _router getVariable [AE3_VAR_CHILDREN, []];

    if (isNull _router || {_clients isEqualTo []}) then {continue};

    private _range = _router getVariable [AE3_VAR_RANGE, AE3_DEFAULT_RANGE];
    private _routerStrength = [_router, _jammers] call FUNC(getJamStrength);

    // Copied before iterating: dropping a client edits the list of the router
    {
        private _client = _x;

        if (isNull _client || {_client getVariable [AE3_VAR_IS_ROUTER, false]}) then {continue};

        private _strength = _routerStrength max ([_client, _jammers] call FUNC(getJamStrength));

        if (_strength > 0 && {_strength >= 1 || {(_client distance _router) > (_range * (1 - _strength))}}) then {
            private _owner = owner _client;

            if (_owner > 0) then {
                [AE3_NET_RESULT_EVENT, [false, LLSTRING(connection_jammed)], _owner] call CBA_fnc_ownerEvent;
            };

            [_client] call AE3_network_fnc_removeNetworkConnection;

            // For missions and mods that follow the connections: [laptop, router, strength 0 to 1], on the server
            [QGVAR(connectionJammed), [_client, _router, _strength]] call CBA_fnc_localEvent;
        };
    } forEach (+_clients);
} forEach (missionNamespace getVariable [AE3_ROUTERS, []]);
