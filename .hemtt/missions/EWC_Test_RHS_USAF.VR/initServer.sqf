// EWC Test - RHS USAF DUKE and Boomerang
// Spawns every vehicle of the mod that the compat covers, a jam lane with IEDs and distance signs.
// Vehicles are found in the loaded configs, so the mission follows the mod version.
#include "common.hpp"

// Every vehicle with a DUKE or a Boomerang antenna, one per model so camouflage variants are not repeated.
// The Boomerang source is in the base class of a family, so the whole inheritance chain is read (like boomerang does)
private _hasBoomerang = {
    private _config = _this;
    private _found = false;

    while {!_found && {isClass _config}} do {
        _found = ("isClass _x" configClasses (_config >> "AnimationSources")) findIf {toLower configName _x == "hide_boomerang"} != -1;
        _config = inheritsFrom _config;
    };

    _found
};

private _classes = [];
private _models = [];
{
    private _model = toLower getText (_x >> "model");
    if (!(_model in _models) && {getText (_x >> "rhs_duke_type") != "" || {_x call _hasBoomerang}}) then {
        _models pushBack _model;
        _classes pushBack configName _x;
    };
} forEach ("getNumber (_x >> 'scope') == 2 && {configName _x isKindOf 'LandVehicle'}" configClasses (configFile >> "CfgVehicles"));


// Parking grid: one vehicle per model, rows run south
private _vehicles = [];
{
    private _row = floor (_forEachIndex / PARK_COLUMNS);
    private _col = _forEachIndex % PARK_COLUMNS;
    private _vehicle = createVehicle [_x, [_col * PARK_SPACING, -_row * PARK_SPACING, 0], [], 0, "CAN_COLLIDE"];
    _vehicle setFuel 1;
    // RHS hides the antenna of the shot finder by default
    if ((configFile >> "CfgVehicles" >> _x) call _hasBoomerang) then {
        _vehicle animateSource ["hide_boomerang", 0, true];
    };
    // The Stryker family starts some variants with the DUKE antenna hidden, which also removes the weapon
    if (isClass (configFile >> "CfgVehicles" >> _x >> "AnimationSources" >> "Hide_DUKE")) then {
        _vehicle animateSource ["Hide_DUKE", 0, true];
    };
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


// Boomerang range: park a Boomerang vehicle on the bait spot. A hostile shooter 400 m north and a friendly one
// 300 m west fire past it at decoys, so the bullets pass the vehicle at about 15 to 25 m
private _bait = [0, 320, 0];
private _hostilePos = [0, 720, 0];
private _friendlyPos = [-300, 320, 0];

_labels pushBack [_bait, "BOOMERANG BAIT: park vehicle here"];
_labels pushBack [_hostilePos, "hostile shooter (400 m)"];
_labels pushBack [_friendlyPos, "friendly shooter (300 m)"];

private _makeShooter = {
    params ["_side", "_type", "_pos", "_decoyPos"];

    private _group = createGroup _side;
    private _shooter = _group createUnit [_type, _pos, [], 0, "CAN_COLLIDE"];
    private _decoy = _group createUnit [_type, _decoyPos, [], 0, "CAN_COLLIDE"];

    {
        _x allowDamage false;
        _x disableAI "MOVE";
        _x disableAI "PATH";
        _x disableAI "AUTOTARGET";
    } forEach [_shooter, _decoy];
    _shooter setDir (_shooter getDir _decoy);

    [_shooter, _decoy]
};

private _hostile = [east, "O_Soldier_F", _hostilePos, _bait vectorAdd [16, 0, 0]] call _makeShooter;
private _friendly = [west, "B_Soldier_F", _friendlyPos, _bait vectorAdd [64, 24, 0]] call _makeShooter;

missionNamespace setVariable ["ewc_test_shooting", true, true];

[{
    params ["_args"];
    _args params ["_pairs"];

    if !(missionNamespace getVariable ["ewc_test_shooting", true]) exitWith {};

    {
        _x params ["_shooter", "_decoy"];
        _shooter setVehicleAmmo 1;
        _shooter doWatch _decoy;
        _shooter setDir (_shooter getDir _decoy);

        // A short burst of single shots
        [{
            params ["_shooter"];
            for "_i" from 1 to 3 do {
                _shooter forceWeaponFire [currentMuzzle _shooter, "Single"];
            };
        }, [_shooter], random 1.5] call CBA_fnc_waitAndExecute;
    } forEach _pairs;
}, 6, [[_hostile, _friendly]]] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["ewc_test_labels", _labels, true];
