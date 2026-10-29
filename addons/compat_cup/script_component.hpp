#define COMPONENT compat_cup
#define COMPONENT_BEAUTIFIED Compat CUP

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

// The system CUP only models and this addon switches. Its function is in the sub-addon duke (the Boomerang of CUP is in boomerang)
#define SYSTEM_DUKE "duke"

// Raised when one of the two systems is switched on, the other one switches off. Used by both sub-addons
#define EVENT_SYSTEM_ON QGVAR(systemOn)

// Animation sources CUP uses for the antennas, lowercase. An antenna is shown at phase 0 and hidden at phase 1
#define DUKE_SOURCES ["hide_antenna_duke", "hide_duke_antenna", "hide_crew_duke", "hide_duke_antennas", "sys_crewduke"]
#define ANTENNA_SHOWN_BELOW 0.5

#define ACTION_MODE_SCROLL 0
#define ACTION_MODE_ACE 1
#define ACTION_MODE_BOTH 2
