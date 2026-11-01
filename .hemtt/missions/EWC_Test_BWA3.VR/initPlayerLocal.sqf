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



// Labels over IEDs and lane signs. Vehicle, jammer and jammed states come from the debug overlay (ewc_common_debug)
addMissionEventHandler ["Draw3D", {
    private _eye = positionCameraToWorld [0, 0, 0];

    {
        _x params ["_pos", "_text"];
        if (_eye distance _pos < 250) then {
            drawIcon3D ["", [1, 1, 1, 1], _pos vectorAdd [0, 0, 2.5], 0, 0, 0, _text, 2, 0.035, "PuristaMedium", "center"];
        };
    } forEach (missionNamespace getVariable ["ewc_test_labels", []]);

    {
        if (!isNull _x && {_eye distance _x < 250}) then {
            drawIcon3D ["", [1, 1, 1, 1], (getPosATL _x) vectorAdd [0, 0, 0.4], 0, 0, 0, _x getVariable ["ewc_test_title", "IED"], 2, 0.03, "PuristaMedium", "center"];
        };
    } forEach (missionNamespace getVariable ["ewc_test_mines", []]);
}];

hint parseText "<t size='1.2'>EWC Test: BWA3 Dingo 2 CG13</t><br/>Every Dingo 2 with a CG13 stands at the parking area (0,0). The debug overlay (setting <t color='#ffd966'>ewc_common_debug</t>, forced on in this mission) shows the states.<br/><br/>1. Get in a Dingo, start the engine, use <t color='#ffd966'>TurnOnCG13</t> (scroll wheel).<br/>2. Drive it onto the <t color='#ffd966'>JAM LANE</t> (150 m north). IEDs within 40 m turn red (jammed).<br/>3. Second player with ACRE stands at the radio signs west of the lane: effective jamming up to 40 m, falloff to 100 m.<br/>4. Switch the engine off: CG13 and radio jamming must stop.<br/>5. Crow's EW needs multiplayer: host this on LAN.";
