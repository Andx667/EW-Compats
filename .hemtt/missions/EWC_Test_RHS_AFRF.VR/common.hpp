// Layout of the test area, in metres on the VR map. Vehicles park around [0,0], the lane and range lie north of them
#define PARK_COLUMNS 8
#define PARK_SPACING 12
#define LANE_SPOT [0, 150, 0]
// The R-142N jams radios and drones, not IEDs. Signs west of the lane spot, effective radius 500 m, outer edge 1250 m
#define LANE_RADIO_DISTANCES [100, 300, 500, 800, 1000, 1250]
// Drone parked east of the lane spot, in the same way
#define LANE_DRONE_DISTANCES [100, 300, 500, 800, 1000, 1250]
