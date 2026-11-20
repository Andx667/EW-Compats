#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

#include "initSettings.inc.sqf"

// Ghosts of Spoof jammers on this machine, key -> [stand-in object, unit it copies, offset], see fnc_updateGhosts
GVAR(ghosts) = createHashMap;
GVAR(ghostHandle) = -1;
GVAR(ghostStats) = [0, 0, 0];

/*
 * Registered in preInit, not postInit: the module function may raise CrowsEW's addJammer as early
 * as mission init, and a crowsEW_main_jammerAdded that is raised before our handler exists
 * would leave that jammer without its "sweep_bft" beacon until it is toggled.
 *
 * Server: keeps the "sweep_bft" spectrum beacon of a BFT-capable CrowsEW jammer in sync with
 * its enabled state when it is added or toggled. A removal strips all its beacons in CrowsEW.
 * Client: reacts to cTab rebuilding its BFT lists to apply blackout/drift to the display.
 */
if (isServer) then {
    [CROWSEW_JAMMER_ADDED_EVENT, FUNC(onJammerChangedServer)] call CBA_fnc_addEventHandler;
    [CROWSEW_JAMMER_TOGGLED_EVENT, {
        params ["_netId", "", "_entry"];
        [_netId, _entry] call FUNC(onJammerChangedServer);
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    GVAR(driftState) = createHashMap;

    [CTAB_LISTS_UPDATED_EVENT, FUNC(onBftListsUpdated)] call CBA_fnc_addEventHandler;
};

ADDON = true;
