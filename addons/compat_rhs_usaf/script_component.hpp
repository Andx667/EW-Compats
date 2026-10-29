#define COMPONENT compat_rhs_usaf
#define COMPONENT_BEAUTIFIED Compat RHS USAF

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"


// RHS hardcodes the mine jammer range in rhs_duke.sqf, keep in sync
#define DUKE_EFFECTIVE_RADIUS 50
#define DUKE_FALLOFF_FACTOR 1.5
// RHS shortens the range to 60 percent once one antenna is destroyed and stops the DUKE with both destroyed
#define DUKE_SINGLE_ANTENNA_SCALE 0.6
#define DUKE_ANTENNA_DESTROYED 1
#define DUKE_BOTH_ANTENNAS_DESTROYED 0.99

// RHS sets its public state variable in a spawned script after the fired event, give it time
#define DUKE_SYNC_DELAY 0.5

#define DUKE_STATE_VAR "RHS_DUKE_OP"

// Shown in the hint when it is switched
#define SYSTEM_NAME "DUKE"
