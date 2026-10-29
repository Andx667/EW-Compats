#include "script_component.hpp"

SUBADDON = false;

#include "XEH_PREP.hpp"

// Encryption key -> the cTab markers of detected shots that are still there, each [ID, position, expiry time]. Only the
// server has it. A new shot close to one is merged into it
GVAR(ctab_shotMarkers) = createHashMap;

// Raised on every machine by Boomerang for each shot a Boomerang detected. Only the server adds the marker, so cTab
// has one marker per shot. Registered in preInit, so no report is missed while the mission starts
[QGVAR(shotDetected), LINKFUNC(ctab_addMarker)] call CBA_fnc_addEventHandler;

SUBADDON = true;
