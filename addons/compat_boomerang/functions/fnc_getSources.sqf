#include "..\script_component.hpp"
/*
 * Author: Andx
 * Returns the animation sources of a vehicle that belong to the shot finder (Boomerang).
 * The sources are the ones of the registry (CfgEWC >> Boomerangs). Mods only model the antenna as a source that
 * can be hidden, so this is what marks a vehicle as equipped.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Animation sources, empty if the vehicle does not have a Boomerang <ARRAY>
 *
 * Example:
 * [_vehicle] call ewc_compat_boomerang_fnc_getSources
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

private _class = typeOf _vehicle;
private _sources = GVAR(sourceCache) get _class;

if (isNil "_sources") then {
    _sources = [];
    private _config = configFile >> "CfgVehicles" >> _class;

    // Classes inherited from a parent are not listed as children, so every class up the chain has to be read.
    // The source is defined in the base class of a vehicle family
    while {isClass _config} do {
        {
            private _name = configName _x;

            if (toLower _name in GVAR(sourceNames)) then {
                _sources pushBackUnique _name;
            };
        } forEach ("isClass _x" configClasses (_config >> "AnimationSources"));

        _config = inheritsFrom _config;
    };

    GVAR(sourceCache) set [_class, _sources];
};

_sources
