#include "common.hpp"

waitUntil {!isNull player};

// Radios for the jam lane, UAV terminal for the drones, Spectrum Device for Crow's
{
    if (isClass (configFile >> "CfgWeapons" >> _x)) then { player addItem _x };
} forEach ["ACRE_PRC152", "ACRE_PRC343", "B_UavTerminal"];

if (isClass (configFile >> "CfgWeapons" >> "hgun_esd_01_F")) then {
    player addWeapon "hgun_esd_01_F";
    player addHandgunItem "muzzle_antenna_01_f";
};
player setPos [-20 + (random 2), 10, 0];



// Labels over vehicles, drones and lane signs
addMissionEventHandler ["Draw3D", {
    private _eye = positionCameraToWorld [0, 0, 0];

    {
        _x params ["_pos", "_text"];
        if (_eye distance _pos < 1400) then {
            drawIcon3D ["", [1, 1, 1, 1], _pos vectorAdd [0, 0, 2.5], 0, 0, 0, _text, 2, 0.035, "PuristaMedium", "center"];
        };
    } forEach (missionNamespace getVariable ["ewc_test_labels", []]);

    {
        if (!isNull _x && {_eye distance _x < 60}) then {
            private _state = [_x] call ewc_test_fnc_vehicleState;
            private _pos = (_x modelToWorld [0, 0, 0]) vectorAdd [0, 0, 3.5];
            drawIcon3D ["", [1, 1, 1, 1], _pos vectorAdd [0, 0, 0.5], 0, 0, 0, _x getVariable ["ewc_test_title", typeOf _x], 2, 0.03, "PuristaMedium", "center"];
            drawIcon3D ["", [[0.8, 0.8, 0.8, 1], [0.3, 1, 0.3, 1]] select (_state select 1), _pos, 0, 0, 0, _state select 0, 2, 0.03, "PuristaMedium", "center"];
        };
    } forEach (missionNamespace getVariable ["ewc_test_vehicles", []]);

    {
        if (!isNull _x && {_eye distance _x < 1400}) then {
            drawIcon3D ["", [1, 1, 1, 1], (getPosATL _x) vectorAdd [0, 0, 1.2], 0, 0, 0, _x getVariable ["ewc_test_title", "Drone"], 2, 0.03, "PuristaMedium", "center"];
        };
    } forEach (missionNamespace getVariable ["ewc_test_drones", []]);
}];

hint parseText "<t size='1.2'>EWC Test: RHS R-142N</t><br/>Every GAZ-66 (R-142N) stands at the parking area (0,0). Labels show the mast and the jammer.<br/><br/>1. Get in as driver and stand still. Select <t color='#ffd966'>Deploy Mast</t> (scroll wheel). The jammer turns on after about 5 s, <t color='#ffd966'>Fold Mast</t> turns it off.<br/>2. Drive the vehicle onto the <t color='#ffd966'>JAM LANE</t> (150 m north) and deploy the mast there.<br/>3. Second player with ACRE at the radio signs: effective 500 m, outer edge 1250 m.<br/>4. Connect to a Darter east of the lane with the UAV terminal: the link degrades the same way.<br/>5. Crow's EW needs multiplayer: host this on LAN.";
