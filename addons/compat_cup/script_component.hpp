#define COMPONENT compat_cup
#define COMPONENT_BEAUTIFIED Compat CUP

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

#define CROWS_EVENT_ADD_JAMMER "crowsEW_main_addJammer"
#define CROWS_EVENT_REMOVE_JAMMER "crowsEW_main_removeJammer"
#define CROWS_EVENT_TOGGLE_JAMMER "crowsEW_main_toggleJammer"
#define CROWS_EVENT_UPDATE_JAMMERS "crowsEW_main_updateJammers"
#define CROWS_CAPABILITY_RADIO "VoiceCommsJammer"

// The two systems CUP only models. They exclude each other on a vehicle
#define SYSTEM_DUKE "duke"
#define SYSTEM_BOOMERANG "boomerang"

// Animation sources CUP uses for the antennas, lowercase. An antenna is shown at phase 0 and hidden at phase 1
#define DUKE_SOURCES ["hide_antenna_duke", "hide_duke_antenna", "hide_crew_duke", "hide_duke_antennas", "sys_crewduke"]
#define BOOMERANG_SOURCES ["hide_antenna_boomerang", "sys_boomerang"]
#define ANTENNA_SHOWN_BELOW 0.5

#define DUKE_FALLOFF_FACTOR 1.5
// Range with only some of the antennas shown, like RHS with one antenna destroyed
#define DUKE_SINGLE_ANTENNA_SCALE 0.6

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

// Seconds between two checks of an active jammer (antenna, engine, mines in range)
#define LOOP_INTERVAL 1

// Crows tags its own (de)activate actions with this colour
#define CROWS_ACTION_MARKER "#FFFF00"

#define ACTION_MODE_SCROLL 0
#define ACTION_MODE_ACE 1
#define ACTION_MODE_BOTH 2
