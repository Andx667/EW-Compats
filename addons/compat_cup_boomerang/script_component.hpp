#define COMPONENT compat_cup_boomerang
#define COMPONENT_BEAUTIFIED Compat CUP Boomerang

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

// Switching one of the two systems on switches the other one off, see compat_cup_duke
#define SYSTEM_BOOMERANG "boomerang"
#define EVENT_SYSTEM_ON QEGVAR(compat_cup,systemOn)

// Boomerang works up to this speed (km/h), 60 mph according to the data sheet of Raytheon BBN
#define BOOMERANG_MAX_SPEED 97
// Shots are only considered up to this distance (m) between shooter and vehicle
#define BOOMERANG_MAX_RANGE 1000
// Bullets at or above this speed (m/s) have a shockwave. Slower ones are only heard as muzzle blast, on short range (m)
#define BOOMERANG_SONIC_SPEED 340
#define BOOMERANG_SUBSONIC_RANGE 100
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

// Where the Boomerang shows the position of a shooter (the setting is in the cTab sub-addon, folder ctab)
#define MARKER_TARGET_MAP 0
#define MARKER_TARGET_CTAB 1
#define MARKER_TARGET_BOTH 2

// Seconds between two checks of an active Boomerang (antenna, engine, vehicle)
#define LOOP_INTERVAL 1
