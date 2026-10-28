#include "..\script_component.hpp"
/*
 * Author: Andx
 * Returns the animation sources of a vehicle that belong to a CUP DUKE antenna.
 * CUP's DUKE only exists as a model, so this is what marks a vehicle as DUKE equipped.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Animation sources, empty if the vehicle has no DUKE <ARRAY>
 *
 * Example:
 * [_vehicle] call ewc_compat_cup_fnc_getDukeSources
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

private _class = typeOf _vehicle;
private _sources = GVAR(sourceCache) get _class;

if (!isNil "_sources") exitWith {_sources};

_sources = [];

private _config = configFile >> "CfgVehicles" >> _class;

// Classes inherited from a parent are not listed as children, so every class up the chain has to be read.
// The DUKE sources are usually defined in the base class of a vehicle family
while {isClass _config} do {
    {
        private _name = configName _x;

        if (toLower _name in DUKE_SOURCES) then {
            _sources pushBackUnique _name;
        };
    } forEach ("isClass _x" configClasses (_config >> "AnimationSources"));

    _config = inheritsFrom _config;
};

GVAR(sourceCache) set [_class, _sources];

_sources
