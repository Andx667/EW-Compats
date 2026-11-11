#include "script_component.hpp"

if (hasInterface) then {
    // A new unit (respawn, Zeus remote control) starts without exposure and without our fatigue factor
    // Runs at once for the current unit too (retroactive), which also starts the loop
    ["unit", LINKFUNC(onPlayerChanged), true] call CBA_fnc_addPlayerEventHandler;
};
