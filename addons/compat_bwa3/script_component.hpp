#define COMPONENT compat_bwa3
#define COMPONENT_BEAUTIFIED Compat BWA3

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

#define CROWS_EVENT_ADD_JAMMER "crowsEW_main_addJammer"
#define CROWS_EVENT_TOGGLE_JAMMER "crowsEW_main_toggleJammer"
#define CROWS_EVENT_UPDATE_JAMMERS "crowsEW_main_updateJammers"
#define CROWS_CAPABILITY_RADIO "VoiceCommsJammer"

// BWA3 hardcodes the mine jammer range (JAMMER_RANGE) in its own script_component.h, keep in sync
#define ECM_EFFECTIVE_RADIUS 40
#define ECM_FALLOFF_RADIUS (1.5 * ECM_EFFECTIVE_RADIUS)
