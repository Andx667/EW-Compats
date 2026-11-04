#include "script_component.hpp"

SUBADDON = false;

#include "XEH_PREP.hpp"

// Track ID -> [encryption key, cTab marker ID, 2D position, time it was added]. Only the server has it
GVAR(ctab_markers) = createHashMap;

// Always raised on the server for every update and end of a track (on clients only for map markers). Only the server
// changes the markers, cTab sends them on to the clients. Registered in preInit, so no update is missed while the
// mission starts
[QGVAR(trackUpdated), LINKFUNC(ctab_updateMarker)] call CBA_fnc_addEventHandler;
[QGVAR(trackLost), LINKFUNC(ctab_removeMarker)] call CBA_fnc_addEventHandler;

SUBADDON = true;
