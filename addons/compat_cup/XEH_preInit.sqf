#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Vehicle class -> animation sources of its DUKE and Boomerang antennas, per system
GVAR(sourceCache) = createHashMap;

// Vehicles with a Boomerang that is on. The server keeps the list and broadcasts it, so the machine of a
// shooter can check its shots without asking the server
GVAR(boomerangVehicles) = [];
GVAR(boomerangLoopHandle) = -1;
GVAR(markerCounter) = 0;

// Map markers of detected shots that are still there, each [name, position, expiry time]. A new shot close to one is merged into it
GVAR(shotMarkers) = [];

// Handle of the mission event handler that sees the projectiles, while a Boomerang is on
GVAR(projectileHandler) = -1;

// Ammo class -> is it a bullet. The inheritance of an ammo class is only walked once
GVAR(bulletCache) = createHashMap;

// Vehicle (net ID) -> mines it holds disabled. Only exists on the server
GVAR(active) = createHashMap;
GVAR(loopHandle) = -1;

GVAR(aceLoaded) = isClass (configFile >> "CfgPatches" >> "ace_interact_menu");

#include "initSettings.inc.sqf"

ADDON = true;
