#include "..\script_component.hpp"
/*
 * Author: Andx
 * Returns the animation sources of a vehicle that belong to the antennas of a CUP system.
 * CUP's DUKE only exists as a model, so this is what marks a vehicle as equipped.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: System, "duke" <STRING> (default: "duke")
 *
 * Return Value:
 * Animation sources, empty if the vehicle does not have the system <ARRAY>
 *
 * Example:
 * [_vehicle, "duke"] call ewc_compat_cup_fnc_getSources
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_system", SYSTEM_DUKE, [""]]];

private _class = typeOf _vehicle;
private _systems = GVAR(sourceCache) get _class;

if (isNil "_systems") then {
    private _duke = [];
    private _config = configFile >> "CfgVehicles" >> _class;

    // Classes inherited from a parent are not listed as children, so every class up the chain has to be read.
    // The sources are usually defined in the base class of a vehicle family
    while {isClass _config} do {
        {
            private _name = configName _x;
            private _lower = toLower _name;

            if (_lower in DUKE_SOURCES) then {
                _duke pushBackUnique _name;
            };
        } forEach ("isClass _x" configClasses (_config >> "AnimationSources"));

        _config = inheritsFrom _config;
    };

    _systems = createHashMapFromArray [[SYSTEM_DUKE, _duke]];
    GVAR(sourceCache) set [_class, _systems];
};

_systems getOrDefault [_system, []]
