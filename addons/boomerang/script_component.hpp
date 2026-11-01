#define COMPONENT boomerang
#define COMPONENT_BEAUTIFIED Boomerang

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

// Shown in the hint when it is switched
#define SYSTEM_NAME "Boomerang"

// An antenna is shown at phase 0 and hidden at phase 1 of its animation source
#define ANTENNA_SHOWN_BELOW 0.5

// Boomerang works up to this speed (km/h), 60 mph according to the data sheet of Raytheon BBN
#define BOOMERANG_MAX_SPEED 97
// Shots are only considered up to this distance (m) between shooter and vehicle
#define BOOMERANG_MAX_RANGE 1000
// Bullets at or above this speed (m/s) have a shockwave. Slower ones are only heard as muzzle blast, on short range (m)
#define BOOMERANG_SONIC_SPEED 340
#define BOOMERANG_SUBSONIC_RANGE 100
// Bullets that pass the vehicle closer than this (m) are heard, 30 m according to the data sheet of Raytheon BBN
#define BOOMERANG_MISS_DISTANCE 30
// Seconds the sensor is deaf after the weapons of its own vehicle were fired
#define BOOMERANG_LOCKOUT 5
// Accuracy of a report: bearing in degrees, range as fraction. Vehicle system according to the data sheet of Raytheon BBN
// (the 7.5 degrees and 20 percent are the ones of the dismounted Boomerang Warrior)
#define BOOMERANG_BEARING_ERROR 2.5
#define BOOMERANG_RANGE_ERROR 0.1
// Elevation (degrees) from which a shooter is reported above or below the vehicle
#define BOOMERANG_ELEVATION_LIMIT 10
// Seconds between two reports of the same vehicle, so a burst is not reported bullet by bullet
#define BOOMERANG_REPORT_INTERVAL 1

// A report closer than this (m) to the marker of an earlier shot is merged into it, see fnc_findNearMarker
#define BOOMERANG_MARKER_MERGE_DISTANCE 50
// Seconds a marker may outlive its expiry time before it is removed, so a timer that fires a hair early does not reschedule
#define MARKER_EXPIRY_TOLERANCE 0.1

// Where the Boomerang shows the position of a shooter. cTab is only offered when it is loaded, see the sub-addon in folder boomerang_ctab
#define MARKER_TARGET_NONE 0
#define MARKER_TARGET_MAP 1
#define MARKER_TARGET_CTAB 2

// Seconds between two checks of an active Boomerang (antenna, engine, vehicle)
#define LOOP_INTERVAL 1
