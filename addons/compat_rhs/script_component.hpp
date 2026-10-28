#define COMPONENT compat_rhs
#define COMPONENT_BEAUTIFIED Compat RHS

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

#define CROWS_EVENT_ADD_JAMMER "crowsEW_main_addJammer"
#define CROWS_EVENT_REMOVE_JAMMER "crowsEW_main_removeJammer"
#define CROWS_EVENT_TOGGLE_JAMMER "crowsEW_main_toggleJammer"
#define CROWS_EVENT_UPDATE_JAMMERS "crowsEW_main_updateJammers"
#define CROWS_CAPABILITY_RADIO "VoiceCommsJammer"

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
