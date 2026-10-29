#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Vehicle class -> animation sources of its DUKE antennas, per system
GVAR(sourceCache) = createHashMap;

GVAR(aceLoaded) = isClass (configFile >> "CfgPatches" >> "ace_interact_menu");

#include "initSettings.inc.sqf"

ADDON = true;
