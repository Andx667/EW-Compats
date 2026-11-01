// Layout of the test area, in metres on the VR map. The map is 8192 m wide, the test area is around its center. The real units
// stand around the parking spot ORIGIN, the jammer stations are far enough from it (and from each other) that the 200 m effective
// and 400 m falloff radius do not overlap
#define ORIGIN [4096, 4096, 0]
#define STATION_SPOOF (ORIGIN vectorAdd [0, 1000, 0])
#define STATION_BLACKOUT (ORIGIN vectorAdd [-1200, 0, 0])
#define STATION_DRIFT (ORIGIN vectorAdd [1200, 0, 0])
#define STATION_MIXED (ORIGIN vectorAdd [0, -1200, 0])
#define STATION_EFFECTIVE_RADIUS 200
#define STATION_FALLOFF_RADIUS 400
// Jamming types of bft_jamming
#define JAM_TYPE_BLACKOUT 0
#define JAM_TYPE_DRIFT 1
#define JAM_TYPE_MIXED 2
#define JAM_TYPE_SPOOF 3
