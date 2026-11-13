#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Is the wireless link between a laptop and a router jammed? A jammer shortens the wireless range of the router by its
 * strength at the laptop or at the router, whichever is stronger, see fnc_connectCondition. Shared by the connect
 * condition and the debug overlay (fnc_debugLines).
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 1: Router <OBJECT>
 * 2: Wi-Fi jammers that are on and alive, [[jammer, effective radius, falloff radius], ...] <ARRAY>
 *
 * Return Value:
 * [strength 0 to 1, jammed] <ARRAY>
 *
 * Example:
 * [_laptop, _router, ewc_wifi_jamming_jammers] call ewc_wifi_jamming_fnc_getConnectionJam
 *
 * Public: No
 */

params [["_device", objNull, [objNull]], ["_router", objNull, [objNull]], ["_jammers", [], [[]]]];

private _strength = ([_router, _jammers] call FUNC(getJamStrength)) max ([_device, _jammers] call FUNC(getJamStrength));

if (_strength <= 0) exitWith {[0, false]};

if (_strength >= 1) exitWith {[1, true]};

// AE3 checks the unjammed range before the connect conditions, the jammer only takes a share of it
private _range = [_router, _device] call AE3_network_fnc_getWirelessRange;

[_strength, (_device distance _router) > (_range * (1 - _strength))]
