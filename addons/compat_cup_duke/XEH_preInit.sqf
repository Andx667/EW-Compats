#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Vehicle (net ID) -> mines it holds disabled. Only exists on the server
GVAR(active) = createHashMap;
GVAR(loopHandle) = -1;

#include "initSettings.inc.sqf"

ADDON = true;
