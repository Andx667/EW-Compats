#include "..\script_component.hpp"
/*
 * Author: Andx
 * Finds the entry of CfgEWC >> Jammers that describes a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Entry, configNull if the vehicle is no registered jammer <CONFIG>
 *
 * Example:
 * [_vehicle] call ewc_main_fnc_getJammerConfig
 *
 * Public: Yes
 */

params [["_vehicle", objNull, [objNull]]];

private _vehicleConfig = configOf _vehicle;
private _class = configName _vehicleConfig;
private _config = GVAR(jammerConfigCache) get _class;

if (isNil "_config") then {
    private _entries = configProperties [configFile >> "CfgEWC" >> "Jammers", "isClass _x"];
    private _index = _entries findIf {
        private _marker = _vehicleConfig >> getText (_x >> "property");

        if (isNumber (_x >> "value")) then {
            isNumber _marker && {getNumber _marker == getNumber (_x >> "value")}
        } else {
            isText _marker && {getText _marker isNotEqualTo ""}
        }
    };

    _config = [configNull, _entries select _index] select (_index != -1);
    GVAR(jammerConfigCache) set [_class, _config];
};

_config
