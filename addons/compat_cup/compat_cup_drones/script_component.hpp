#define SUBCOMPONENT drones
#define SUBCOMPONENT_BEAUTIFIED Drones

#include "..\script_component.hpp"

// Bases of the CUP drones. Both derive from the plain UAV class, not from one of the UAV_0x_base_F that Crows lists
// by default, so Crows gives them no signal (and so no jamming)
#define DRONE_BASES ["CUP_MQ9_Base", "CUP_Pchela1T_Base"]

// Seconds a drone may wait for Crows to be ready before the wait is given up
#define WAIT_CROWS_TIMEOUT 120
