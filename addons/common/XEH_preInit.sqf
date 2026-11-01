#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Vehicle class -> entry of CfgEWC >> Jammers that describes it. The registry is only searched once per class
GVAR(jammerConfigCache) = createHashMap;

// Systems the crew switches on and off, id -> [event, variable of the state, can be switched on, titles, has the system], see fnc_registerSwitch
GVAR(switches) = createHashMap;

// Extra lines of the debug overlay for a system, id -> [has the system, lines], see fnc_registerDebug
GVAR(debugProviders) = createHashMap;

// Handle of the Draw3D handler of the debug overlay, while it is on
GVAR(debugHandle) = -1;

GVAR(aceLoaded) = isClass (configFile >> "CfgPatches" >> "ace_interact_menu");

#include "initSettings.inc.sqf"

// Crows adds its own (de)activate actions to every jammer. They'd toggle Crows without the compat addon and desync the two
if (hasInterface) then {
    [CROWS_EVENT_UPDATE_JAMMERS, LINKFUNC(removeCrowsActions)] call CBA_fnc_addEventHandler;
};

// A system of a vehicle was switched on or off, see fnc_notifyState
if (hasInterface) then {
    [QGVAR(stateChanged), LINKFUNC(onStateChanged)] call CBA_fnc_addEventHandler;
};

ADDON = true;
