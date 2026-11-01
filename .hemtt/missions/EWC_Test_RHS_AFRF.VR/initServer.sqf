// EWC Test - RHS R-142N
// Spawns one vehicle of the mod that the compat covers, a jam lane with radio signs and drones.
// Vehicles are found in the loaded configs, so the mission follows the mod version.
#include "common.hpp"

// One GAZ-66 (R-142N), the models only differ in camouflage
private _classes = ("getNumber (_x >> 'scope') == 2 && {getNumber (_x >> 'ewc_compat_rhs_afrf_jammer') == 1} && {configName _x isKindOf 'LandVehicle'}" configClasses (configFile >> "CfgVehicles")) apply {configName _x};
_classes = _classes select [0, 1];


// Parking grid: rows run south
private _vehicles = [];
{
    private _row = floor (_forEachIndex / PARK_COLUMNS);
    private _col = _forEachIndex % PARK_COLUMNS;
    private _vehicle = createVehicle [_x, [_col * PARK_SPACING, -_row * PARK_SPACING, 0], [], 0, "CAN_COLLIDE"];
    _vehicle setFuel 1;
    _vehicle setVariable ["ewc_test_title", format ["%1 (%2)", getText (configFile >> "CfgVehicles" >> _x >> "displayName"), _x], true];
    _vehicles pushBack _vehicle;
} forEach _classes;
missionNamespace setVariable ["ewc_test_vehicles", _vehicles, true];
diag_log format ["[EWC test] %1 vehicles spawned", count _vehicles];

// Jam lane: park a vehicle on the spot. Radio signs lie west of it, drones east of it
private _labels = [[LANE_SPOT, "JAM LANE: park vehicle here"]];

{
    private _pos = LANE_SPOT vectorAdd [-_x, 0, 0];
    private _sign = createVehicle ["Sign_Sphere100cm_F", _pos, [], 0, "CAN_COLLIDE"];
    _sign allowDamage false;
    _labels pushBack [_pos, format ["radio %1 m", _x]];
} forEach LANE_RADIO_DISTANCES;


// Drones in range. Pilot them from the UAV terminal to see the link degrade
private _drones = [];
{
    private _drone = createVehicle ["B_UAV_01_F", LANE_SPOT vectorAdd [_x, 0, 0], [], 0, "CAN_COLLIDE"];
    _drone setVariable ["ewc_test_title", format ["Darter %1 m", _x], true];
    createVehicleCrew _drone;
    _drones pushBack _drone;
} forEach LANE_DRONE_DISTANCES;
missionNamespace setVariable ["ewc_test_drones", _drones, true];

missionNamespace setVariable ["ewc_test_labels", _labels, true];
