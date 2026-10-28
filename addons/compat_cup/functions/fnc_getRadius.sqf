#include "..\script_component.hpp"
/*
 * Author: Andx
 * Returns the full jamming radius of a vehicle: the radius from the settings scaled by the shown antennas.
 * Without any antenna the DUKE is off anyway, so the unscaled radius is returned for the disabled jammer.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Radius in meters <NUMBER>
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_getRadius
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

private _scale = _vehicle call FUNC(getRangeScale);

GVAR(radius) * ([_scale, 1] select (_scale == 0))
