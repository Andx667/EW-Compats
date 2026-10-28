#include "common.hpp"

waitUntil {!isNull player};

// Radios for the jam lane, Spectrum Device for Crow's
{
    if (isClass (configFile >> "CfgWeapons" >> _x)) then { player addItem _x };
} forEach ["ACRE_PRC152", "ACRE_PRC343"];

if (isClass (configFile >> "CfgWeapons" >> "hgun_esd_01_F")) then {
    player addWeapon "hgun_esd_01_F";
    player addHandgunItem "muzzle_antenna_01_f";
};
player setPos [-20 + (random 2), 10, 0];



// Labels over vehicles, IEDs and lane signs
addMissionEventHandler ["Draw3D", {
    private _eye = positionCameraToWorld [0, 0, 0];

    {
        _x params ["_pos", "_text"];
        if (_eye distance _pos < 250) then {
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
        if (!isNull _x && {_eye distance _x < 250}) then {
            private _enabled = simulationEnabled _x;
            drawIcon3D ["", [[1, 0.2, 0.2, 1], [1, 0.8, 0.2, 1]] select _enabled, (getPosATL _x) vectorAdd [0, 0, 1.2], 0, 0, 0, format ["%1: %2", _x getVariable ["ewc_test_title", "IED"], ["JAMMED (simulation off)", "armed (simulation on)"] select _enabled], 2, 0.03, "PuristaMedium", "center"];
        };
    } forEach (missionNamespace getVariable ["ewc_test_mines", []]);
}];

hint parseText "<t size='1.2'>EWC Test: RHS DUKE</t><br/>Every RHS vehicle with a DUKE stands at the parking area (0,0). Labels show the DUKE state.<br/><br/>1. Get in as gunner/commander, start the engine and switch the DUKE with its weapon (select <t color='#ffd966'>DUKE</t>, fire).<br/>2. Drive onto the <t color='#ffd966'>JAM LANE</t> (150 m north). IEDs within 50 m turn red.<br/>3. Second player with ACRE at the radio signs: effective 50 m, outer edge 125 m.<br/>4. Shoot one DUKE antenna off (60 % range: 30 m) and both (off).<br/>5. Crow's EW needs multiplayer: host this on LAN.";
