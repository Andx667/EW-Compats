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

// Switch for the shooters of the Boomerang range
player addAction [
    "<t color='#ffd966'>Toggle test shooters</t>",
    {
        missionNamespace setVariable ["ewc_test_shooting", !(missionNamespace getVariable ["ewc_test_shooting", true]), true];
        hint format ["Shooters %1", ["off", "on"] select (missionNamespace getVariable ["ewc_test_shooting", true])];
    },
    nil, 0, false, true, "", "true", 5
];


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

hint parseText "<t size='1.2'>EWC Test: CUP DUKE and Boomerang</t><br/>Every CUP vehicle with a DUKE or Boomerang antenna stands at the parking area (0,0). Labels show both states.<br/><br/><t color='#ffd966'>DUKE</t>: get in, start the engine, scroll wheel / ACE self-interaction. Drive onto the JAM LANE (150 m north): IEDs within 50 m turn red, a second player with ACRE at the radio signs hears jamming. Hunter variants with one antenna: 60 % (30 m).<br/><t color='#ffd966'>Boomerang</t>: park on the BOOMERANG BAIT (320 m north), switch it on (this switches the DUKE off). A hostile shooter (400 m north) and a friendly one (300 m west) fire past you: hint with bearing/range, red map marker. Fire your own weapon: deaf for 5 s. Drive faster than 95 km/h: no reports.<br/>The scroll wheel action 'Toggle test shooters' stops and starts the shooters.<br/>Crow's EW needs multiplayer: host this on LAN.";
