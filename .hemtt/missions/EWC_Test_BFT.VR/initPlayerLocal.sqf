#include "common.hpp"

waitUntil {!isNull player};

// cTab devices for the BFT: Android and MicroDAGR in the GPS slot or the inventory, the tablet in the inventory
player linkItem "ItemAndroid";

{
    if (isClass (configFile >> "CfgWeapons" >> _x)) then { player addItem _x };
} forEach ["ItemcTab", "ItemMicroDAGR"];

// Spectrum Device for Crow's, it shows the BFT jammers as beacons
if (isClass (configFile >> "CfgWeapons" >> "hgun_esd_01_F")) then {
    player addWeapon "hgun_esd_01_F";
    player addHandgunItem "muzzle_antenna_01_f";
};
player setPos (ORIGIN vectorAdd [-20 + (random 2), 10, 0]);

waitUntil {!isNil "ewc_test_stations"};

// Teleports, the stations are up to 1.2 km apart
player addAction ["<t color='#ffd966'>Teleport: parking (real units)</t>", { player setPosATL (ORIGIN vectorAdd [-20, 10, 0]) }, nil, -1, false, true];

{
    _x params ["_name", "_pos", "", "_terminal"];

    player addAction [
        format ["<t color='#ffd966'>Teleport: %1 station</t>", _name],
        { player setPosATL ((_this select 3) vectorAdd [8, 0, 0]) },
        _pos, -1, false, true
    ];

    // Switch the jammer like Zeus does
    _terminal addAction [
        format ["<t color='#ffd966'>Toggle %1 jammer</t>", _name],
        {
            params ["_terminal"];

            private _entry = (missionNamespace getVariable ["crowsEW_main_jamMap", createHashMap]) getOrDefault [netId _terminal, []];
            private _on = _entry param [3, false];

            ["crowsEW_main_toggleJammer", [netId _terminal, !_on]] call CBA_fnc_serverEvent;
            hint format ["Jammer %1", ["on", "off"] select _on];
        },
        nil, 6, false, true, "", "true", 15
    ];
} forEach ewc_test_stations;

// Labels over the stations and the real units. The jammers, the radii and the ghosts are drawn by the debug overlay
addMissionEventHandler ["Draw3D", {
    private _eye = positionCameraToWorld [0, 0, 0];

    {
        _x params ["_name", "_pos", "_type"];

        if (_eye distance _pos < 700) then {
            drawIcon3D ["", [1, 1, 1, 1], _pos vectorAdd [0, 0, 6], 0, 0, 0, format ["%1 STATION (effective %2 m, falloff to %3 m)", _name, STATION_EFFECTIVE_RADIUS, STATION_EFFECTIVE_RADIUS + STATION_FALLOFF_RADIUS], 2, 0.035, "PuristaMedium", "center"];
        };
    } forEach (missionNamespace getVariable ["ewc_test_stations", []]);

    // The callsign of the real unit. A ghost has the same callsign but no label
    {
        if (!isNull _x && {_eye distance _x < 300}) then {
            drawIcon3D ["", [0.3, 0.8, 1, 1], (ASLToAGL getPosASLVisual _x) vectorAdd [0, 0, [2.4, 4.5] select (_x isKindOf "AllVehicles" && {!(_x isKindOf "CAManBase")})], 0, 0, 0, format ["REAL %1", groupId group _x], 2, 0.03, "PuristaMedium", "center"];
        };
    } forEach (missionNamespace getVariable ["ewc_test_units", []]);
}];

hint parseText "<t size='1.2'>EWC Test: BFT Jamming</t><br/>Real units with cTab devices (blue labels) stand around the parking spot (center of the map), a few near the SPOOF station. One jammer of each type stands 1 to 1.2 km away (effective radius 200 m, falloff to 600 m). Open a cTab tablet, Android or MicroDAGR (also in a helicopter TAD). The debug overlay shows the jammers and the ghosts.<br/><br/><t color='#ffd966'>SPOOF</t> (north): stand within 200 m of the terminal. Ghosts of groups and vehicles appear on a wrong position 150 to 400 m from the original, with the same callsign as the original. The real units drift as well. Not in the falloff band: only the drift. At least one ghost is always there, about a third of the units otherwise. Go to a ghost: nothing is there. Switch the terminal off (scroll wheel): the ghosts are gone.<br/><t color='#ffd966'>BLACKOUT</t> (west): units disappear. <t color='#ffd966'>DRIFT</t> (east): positions are wrong. <t color='#ffd966'>MIXED</t> (south): blackout inside, drift outside.<br/>A second player is in another group and appears as a group on the BFT of the first one, so they can be ghosted too. The scroll wheel has teleports to the stations and the switch of each jammer.<br/>Crow's EW needs multiplayer: host this on LAN.";
