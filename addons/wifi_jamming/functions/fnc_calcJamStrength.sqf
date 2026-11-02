#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Jamming strength from the distance to a jammer, with the two radii Crows uses elsewhere: full strength (1) inside the
 * effective radius, falling linearly to 0 at the outer edge (effective radius plus falloff radius), 0 beyond.
 *
 * Arguments:
 * 0: Distance to the jammer in m <NUMBER>
 * 1: Effective radius in m <NUMBER>
 * 2: Falloff radius in m, the band beyond the effective radius <NUMBER>
 *
 * Return Value:
 * Strength, 0 to 1 <NUMBER>
 *
 * Example:
 * [150, 100, 100] call ewc_wifi_jamming_fnc_calcJamStrength // 0.5
 *
 * Public: No
 */

params [["_distance", 0, [0]], ["_radEffective", 0, [0]], ["_radFalloff", 0, [0]]];

if (_distance <= _radEffective) exitWith {1};

private _outerEdge = _radEffective + _radFalloff;

if (_distance >= _outerEdge) exitWith {0};

linearConversion [_radEffective, _outerEdge, _distance, 1, 0, true]
