#define COMPONENT compat_cup
#define COMPONENT_BEAUTIFIED Compat CUP

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

// The two systems CUP only models. Each one is its own addon (compat_cup_duke, compat_cup_boomerang)
#define SYSTEM_DUKE "duke"
#define SYSTEM_BOOMERANG "boomerang"

// Animation sources CUP uses for the antennas, lowercase. An antenna is shown at phase 0 and hidden at phase 1
#define DUKE_SOURCES ["hide_antenna_duke", "hide_duke_antenna", "hide_crew_duke", "hide_duke_antennas", "sys_crewduke"]
#define BOOMERANG_SOURCES ["hide_antenna_boomerang", "sys_boomerang"]
#define ANTENNA_SHOWN_BELOW 0.5

#define ACTION_MODE_SCROLL 0
#define ACTION_MODE_ACE 1
#define ACTION_MODE_BOTH 2
