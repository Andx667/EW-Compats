// EWC Test - BFT Jamming
// Real units with cTab devices stand around the parking spot (the center of the map) and near the Spoof station, one jammer station of each
// type lies far away from them. Spoof ghosts are copies of these units, so there are groups, vehicles and a patrol.
#include "common.hpp"

private _units = [];

// A group of soldiers with a cTab Android, standing still
private _makeGroup = {
    params ["_name", "_pos", "_size"];

    _pos = ORIGIN vectorAdd _pos;

    private _group = createGroup west;

    for "_i" from 0 to _size - 1 do {
        private _unit = _group createUnit ["B_Soldier_F", _pos vectorAdd [_i * 2, 0, 0], [], 0, "CAN_COLLIDE"];
        _unit linkItem "ItemAndroid";
        _unit addItem "ItemcTab";
        _unit allowDamage false;
        _unit disableAI "PATH";
    };

    _group setGroupIdGlobal [_name];
    _group setBehaviour "CARELESS";

    leader _group
};

// A vehicle with its crew. cTab only lists vehicles that are not empty
private _makeVehicle = {
    params ["_name", "_class", "_pos", "_dir", ["_standStill", true]];

    _pos = ORIGIN vectorAdd _pos;

    private _vehicle = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
    _vehicle setDir _dir;
    _vehicle allowDamage false;

    private _group = createVehicleCrew _vehicle;

    {
        _x allowDamage false;
        _x linkItem "ItemAndroid";

        if (_standStill) then {
            _x disableAI "PATH";
        };
    } forEach crew _vehicle;

    _group setGroupIdGlobal [_name];
    _group setBehaviour "CARELESS";

    [_vehicle, _group]
};

// Around the parking spot, the positions are relative to ORIGIN
_units pushBack (["Alpha 1-1", [-60, 0, 0], 3] call _makeGroup);
_units pushBack (["Alpha 1-2", [-60, -25, 0], 2] call _makeGroup);
_units pushBack (["Bravo 2-1", [-110, -60, 0], 4] call _makeGroup);
_units pushBack (["Bravo 2-2", [-60, -60, 0], 2] call _makeGroup);
_units pushBack (["Charlie 3-1", [-110, 50, 0], 3] call _makeGroup);

{
    _x params ["_name", "_class", "_pos", "_dir"];

    _units pushBack (([_name, _class, _pos, _dir] call _makeVehicle) select 0);
} forEach [
    ["Echo 5-1", "B_MRAP_01_F", [20, 40, 0], 90],
    ["Echo 5-2", "B_Truck_01_transport_F", [20, 10, 0], 90],
    ["Foxtrot 6-1", "B_APC_Wheeled_01_cannon_F", [20, -20, 0], 90],
    ["Foxtrot 6-2", "B_MBT_01_cannon_F", [20, -55, 0], 90],
    ["Hotel 8-1", "B_Heli_Light_01_F", [50, 90, 0], 0]
];

// One vehicle that drives, so the ghost of a moving unit can be seen following it
(["Golf 7-1", "B_MRAP_01_F", [80, 0, 0], 0, false] call _makeVehicle) params ["_patrol", "_patrolGroup"];

{
    private _waypoint = _patrolGroup addWaypoint [ORIGIN vectorAdd _x, 0];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointSpeed "LIMITED";
} forEach [[260, 0, 0], [260, -160, 0], [80, -160, 0], [80, 0, 0]];

(_patrolGroup addWaypoint [ORIGIN vectorAdd [80, 0, 0], 0]) setWaypointType "CYCLE";
_units pushBack _patrol;

// Near the Spoof station, so a ghost lies close to the viewer
_units pushBack (["Delta 4-1", [80, 900, 0], 3] call _makeGroup);
_units pushBack (["Delta 4-2", [-90, 950, 0], 2] call _makeGroup);
_units pushBack ((["Delta 4-3", "B_Truck_01_transport_F", [0, 850, 0], 0] call _makeVehicle) select 0);

missionNamespace setVariable ["ewc_test_units", _units, true];
diag_log format ["[EWC test] %1 real units spawned", count _units];

// One jammer station of each type, switched on. Anyone with the right tablet is in range of one of them
private _stations = [];

{
    _x params ["_name", "_pos", "_type", "_frequency"];

    private _terminal = createVehicle ["Crows_dataterminal", _pos, [], 0, "NONE"];
    _terminal allowDamage false;

    [_terminal, _type, STATION_EFFECTIVE_RADIUS, STATION_FALLOFF_RADIUS, _frequency, true] call ewc_bft_jamming_fnc_registerBftJammer;

    _stations pushBack [_name, _pos, _type, _terminal];
} forEach [
    ["SPOOF", STATION_SPOOF, JAM_TYPE_SPOOF, 805],
    ["BLACKOUT", STATION_BLACKOUT, JAM_TYPE_BLACKOUT, 820],
    ["DRIFT", STATION_DRIFT, JAM_TYPE_DRIFT, 835],
    ["MIXED", STATION_MIXED, JAM_TYPE_MIXED, 850]
];

missionNamespace setVariable ["ewc_test_stations", _stations, true];
