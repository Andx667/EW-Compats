#define SUBCOMPONENT duke
#define SUBCOMPONENT_BEAUTIFIED DUKE

#include "..\script_component.hpp"

// Switching one of the two systems on switches the other one off, see the sub-addon boomerang
// Shown in the hint when it is switched
#define SYSTEM_NAME "DUKE"

#define DUKE_FALLOFF_FACTOR 1.5
// Range with only some of the antennas shown, like RHS with one antenna destroyed
#define DUKE_SINGLE_ANTENNA_SCALE 0.6

// The IEDs the DUKE jams. Those of CUP (V1 to V4) are no PipeBombBase, they derive from CUP_Mine_Ammo (MineBase).
// Their anti-tank mines are not included
#define JAMMED_MINE_CLASSES ["PipeBombBase", "CUP_IED_V1_Ammo"]

// Seconds between two checks of an active jammer (antenna, engine, mines in range)
#define LOOP_INTERVAL 1
