#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Vehicle class -> animation sources of its DUKE antennas, per system
GVAR(sourceCache) = createHashMap;

#include "initSettings.inc.sqf"

ADDON = true;
