#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

#include "initSettings.inc.sqf"

// Before the vehicles initialise, so editor-placed ones are not missed
[QEGVAR(main,vehicleInit), LINKFUNC(initVehicle)] call CBA_fnc_addEventHandler;

ADDON = true;
