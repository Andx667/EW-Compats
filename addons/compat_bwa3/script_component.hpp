#define COMPONENT compat_bwa3
#define COMPONENT_BEAUTIFIED Compat BWA3

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"


// BWA3 hardcodes the mine jammer range (JAMMER_RANGE) in its own script_component.h, keep in sync
#define ECM_EFFECTIVE_RADIUS 40
#define ECM_FALLOFF_FACTOR 1.5

// Shown in the hint when it is switched
#define SYSTEM_NAME "CG13"
