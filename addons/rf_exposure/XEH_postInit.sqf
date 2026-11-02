#include "script_component.hpp"

if (hasInterface) then {
    // A new unit (respawn, Zeus remote control) starts without exposure and without our fatigue factor
    ["unit", LINKFUNC(onPlayerChanged), true] call CBA_fnc_addPlayerEventHandler;

    call FUNC(updateLoop);
};
