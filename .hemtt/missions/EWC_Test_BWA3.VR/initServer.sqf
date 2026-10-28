// EWC Test - BWA3 Dingo CG13
// Spawns every vehicle of the mod that the compat covers, a jam lane with IEDs and distance signs.
// Vehicles are found in the loaded configs, so the mission follows the mod version.
#include "common.hpp"

// Every Dingo 2 with a CG13, one per model so camouflage variants are not repeated
private _classes = [];
private _models = [];
{
    private _model = toLower getText (_x >> "model");
    if !(_model in _models) then {
        _models pushBack _model;
        _classes pushBack configName _x;
    };
} forEach ("getNumber (_x >> 'scope') == 2 && {getNumber (_x >> 'BWA3_hasECM') == 1}" configClasses (configFile >> "CfgVehicles"));


// Parking grid: one vehicle per model, rows run south
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

// Jam lane: park a vehicle on the spot. IEDs lie east of it, radio signs west of it
private _labels = [[LANE_SPOT, "JAM LANE: park vehicle here"]];
private _mines = [];
{
    private _mine = createMine ["IEDLandSmall_F", LANE_SPOT vectorAdd [_x, 0, 0], [], 0];
    _mine setVariable ["ewc_test_title", format ["IED %1 m", _x], true];
    _mines pushBack _mine;
} forEach LANE_IED_DISTANCES;
missionNamespace setVariable ["ewc_test_mines", _mines, true];

{
    private _pos = LANE_SPOT vectorAdd [-_x, 0, 0];
    private _sign = createVehicle ["Sign_Sphere100cm_F", _pos, [], 0, "CAN_COLLIDE"];
    _sign allowDamage false;
    _labels pushBack [_pos, format ["radio %1 m", _x]];
} forEach LANE_RADIO_DISTANCES;


missionNamespace setVariable ["ewc_test_labels", _labels, true];
