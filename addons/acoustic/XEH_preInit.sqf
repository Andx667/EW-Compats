#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Server: the objects that are acoustic sensors, and the handle of the scan while there is one
GVAR(sensors) = [];
GVAR(scanHandle) = -1;

// Server: tracks of the drones the sensors hear, "<side>:<drone ID>" -> track, see fnc_updateTrack. The drone ID is
// a number the scan gives every drone (variable ewc_acoustic_droneId)
GVAR(tracks) = createHashMap;
GVAR(trackCounter) = 0;
GVAR(droneCounter) = 0;

// Drone class -> [source level, frequency, kind], see fnc_getSignature. The inheritance is only walked once per class
GVAR(signatureCache) = createHashMap;

// Client: track ID -> [icon marker, path marker]
GVAR(trackMarkers) = createHashMap;

#include "initSettings.inc.sqf"

ADDON = true;
