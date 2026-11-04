#define SUBCOMPONENT ctab
#define SUBCOMPONENT_BEAUTIFIED cTab

#include "..\script_component.hpp"

// cTab marker data: icon 4 is the red NATO rotary wing symbol, 5 the fixed wing one. The octant of the movement is
// 1 (north) to 8 (north-west) in steps of 45 degrees, 0 draws no arrow
#define CTAB_MARKER_ICON_ROTARY 4
#define CTAB_MARKER_ICON_FIXED 5
#define CTAB_MARKER_SIZE_NONE 0
#define CTAB_MARKER_DIRECTION_NONE 0

// cTab cannot move a marker and notifies its side for every new one, so the marker of a track is only replaced when
// the drone moved this far (m) and the last one is this old (s)
#define CTAB_MOVE_DISTANCE 150
#define CTAB_UPDATE_INTERVAL 10
