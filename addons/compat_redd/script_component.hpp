#define COMPONENT compat_redd
#define COMPONENT_BEAUTIFIED Compat Redd Vehicles

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

// The Hummel is no vehicle of Redd'n'Tank, so range and falloff are our own figures. The radius is a setting, this is its default
#define JAMMER_DEFAULT_RADIUS 500
#define JAMMER_FALLOFF_FACTOR 1.5

// Id of the switch in ewc_common, and shown in the hint when it is switched
#define SYSTEM_ID "hummel"
#define SYSTEM_NAME "Hummel"
