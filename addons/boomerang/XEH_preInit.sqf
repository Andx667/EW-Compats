#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Animation sources of the registry (CfgEWC >> Boomerangs) that mark a vehicle with a shot finder, lowercase
GVAR(sourceNames) = [];

{
    GVAR(sourceNames) append (getArray (_x >> "sources") apply {toLower _x});
} forEach configProperties [configFile >> "CfgEWC" >> "Boomerangs", "isClass _x"];

// Vehicle class -> animation sources of its shot finder
GVAR(sourceCache) = createHashMap;

// The crew switches the Boomerang with the actions of ewc_common
[
    "boomerang",
    QGVAR(toggle),
    QGVAR(on),
    LINKFUNC(canActivate),
    "STR_ewc_boomerang_activate",
    "STR_ewc_boomerang_deactivate",
    {([_this select 0] call FUNC(getSources)) isNotEqualTo []}
] call EFUNC(common,registerSwitch);

// Extra lines for the debug overlay of ewc_common
[
    "boomerang",
    {([_this select 0] call FUNC(getSources)) isNotEqualTo []},
    {_this call FUNC(debugLines)}
] call EFUNC(common,registerDebug);

// Vehicles with a Boomerang that is on. The server keeps the list and broadcasts it, so the machine of a
// shooter can check its shots without asking the server
GVAR(vehicles) = [];
GVAR(loopHandle) = -1;
GVAR(markerCounter) = 0;

// Map markers of detected shots that are still there, each [name, position, expiry time]. A new shot close to one is merged into it
GVAR(shotMarkers) = [];

// Handle of the mission event handler that sees the projectiles, while a Boomerang is on
GVAR(projectileHandler) = -1;

// Ammo class -> is it a bullet. The inheritance of an ammo class is only walked once
GVAR(bulletCache) = createHashMap;

#include "initSettings.inc.sqf"

ADDON = true;
