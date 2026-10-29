#include "script_component.hpp"

SUBADDON = false;

#include "XEH_PREP.hpp"

#include "initSettings.inc.sqf"

// Before the vehicles initialise, so editor-placed ones are not missed
[QEGVAR(common,vehicleInit), LINKFUNC(duke_initVehicle)] call CBA_fnc_addEventHandler;

SUBADDON = true;
