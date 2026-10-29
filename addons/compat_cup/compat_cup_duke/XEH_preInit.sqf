#include "script_component.hpp"

SUBADDON = false;

#include "XEH_PREP.hpp"

// Vehicle (net ID) -> mines it holds disabled. Only exists on the server
GVAR(duke_active) = createHashMap;
GVAR(duke_loopHandle) = -1;

#include "initSettings.inc.sqf"

SUBADDON = true;
