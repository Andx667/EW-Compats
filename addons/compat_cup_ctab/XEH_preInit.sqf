#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Raised on every machine by ewc_compat_cup for each shot a Boomerang detected. Only the server adds the marker, so cTab
// has one marker per shot. Registered in preInit, so no report is missed while the mission starts
[QEGVAR(compat_cup,shotDetected), LINKFUNC(addMarker)] call CBA_fnc_addEventHandler;

ADDON = true;
