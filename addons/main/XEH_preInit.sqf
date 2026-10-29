#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Vehicle class -> entry of CfgEWC >> Jammers that describes it. The registry is only searched once per class
GVAR(jammerConfigCache) = createHashMap;

// Crows adds its own (de)activate actions to every jammer. They'd toggle Crows without the compat addon and desync the two
if (hasInterface) then {
    [CROWS_EVENT_UPDATE_JAMMERS, LINKFUNC(removeCrowsActions)] call CBA_fnc_addEventHandler;
};

// A system of a vehicle was switched on or off, see fnc_notifyState
if (hasInterface) then {
    [QGVAR(stateChanged), LINKFUNC(onStateChanged)] call CBA_fnc_addEventHandler;
};

ADDON = true;
