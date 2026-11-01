#define COMPONENT common
#define COMPONENT_BEAUTIFIED Common

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

// How the crew switches a system: scroll wheel action, ACE self-interaction or both
#define ACTION_MODE_SCROLL 0
#define ACTION_MODE_ACE 1
#define ACTION_MODE_BOTH 2

// Debug overlay: distance (m) up to which vehicles, IEDs and units are labelled
#define DEBUG_DISTANCE 600
#define DEBUG_UNIT_DISTANCE 250
// Mines that a jammer disables, the same classes as the DUKE of compat_cup
#define DEBUG_MINE_CLASSES ["PipeBombBase", "CUP_IED_V1_Ammo"]
// Spacing of the lines of a label (m) and number of segments of a radius ring
#define DEBUG_LINE_HEIGHT 0.45
#define DEBUG_RING_SEGMENTS 48
