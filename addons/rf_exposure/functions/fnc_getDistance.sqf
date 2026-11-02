#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Distance from a unit to the surface of an object: to the bounding box of the object, not to its centre. A vehicle is
 * several metres long, and "2 m from a DUKE" is meant from its hull, not from the middle of it. Inside the box is 0.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Object, a jammer <OBJECT>
 *
 * Return Value:
 * Distance in m <NUMBER>
 *
 * Example:
 * [player, _vehicle] call ewc_rf_exposure_fnc_getDistance
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]], ["_object", objNull, [objNull]]];

private _box = boundingBoxReal _object;
private _min = _box select 0;
private _max = _box select 1;

// The unit in the model space of the object, then the point of the box that is closest to it
private _local = _object worldToModel (ASLToAGL getPosASL _unit);
private _closest = [
    ((_local select 0) max (_min select 0)) min (_max select 0),
    ((_local select 1) max (_min select 1)) min (_max select 1),
    ((_local select 2) max (_min select 2)) min (_max select 2)
];

_local distance _closest
