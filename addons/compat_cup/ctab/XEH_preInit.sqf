#include "script_component.hpp"

SUBADDON = false;

#include "XEH_PREP.hpp"

#include "initSettings.inc.sqf"

// Raised on every machine by Compat CUP for each shot a Boomerang detected. Only the server adds the marker, so cTab
// has one marker per shot. Registered in preInit, so no report is missed while the mission starts
[QGVAR(shotDetected), LINKFUNC(ctab_addMarker)] call CBA_fnc_addEventHandler;

SUBADDON = true;
