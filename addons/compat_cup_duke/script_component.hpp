#define COMPONENT compat_cup_duke
#define COMPONENT_BEAUTIFIED Compat CUP DUKE

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

// Switching one of the two systems on switches the other one off, see compat_cup_boomerang
#define SYSTEM_DUKE "duke"
#define EVENT_SYSTEM_ON QEGVAR(compat_cup,systemOn)

#define DUKE_FALLOFF_FACTOR 1.5
// Range with only some of the antennas shown, like RHS with one antenna destroyed
#define DUKE_SINGLE_ANTENNA_SCALE 0.6

// Seconds between two checks of an active jammer (antenna, engine, mines in range)
#define LOOP_INTERVAL 1
