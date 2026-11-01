#define COMPONENT compat_rhs_afrf
#define COMPONENT_BEAUTIFIED Compat RHS AFRF

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"


// RHS has no jammer in AFRF, so range and falloff are our own figures. The radius is a setting, this is its default
#define JAMMER_DEFAULT_RADIUS 500
#define JAMMER_FALLOFF_FACTOR 1.5

// Animation source (door) of the R-142N mast and the phase where it counts as deployed
#define MAST_SOURCE "mast_source"
#define MAST_DEPLOYED_PHASE 0.99
// RHS needs 5 s to deploy the mast, give up waiting for it after this many seconds
#define MAST_DEPLOY_TIMEOUT 15

// Variable of RHS with the names of functions that its mast script calls with [vehicle, phase, instant]
#define RHS_DEPLOY_HOOK_VAR "rhs_eh_gaz66_deploy"

// Shown in the hint when it is switched
#define SYSTEM_NAME "R-142N"
