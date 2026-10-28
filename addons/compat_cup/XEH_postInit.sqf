#include "script_component.hpp"

if (isServer) then {
    [QGVAR(toggle), LINKFUNC(handleToggle)] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    // Crows adds its own (de)activate actions to every jammer. They'd toggle Crows without the DUKE and desync the two
    [CROWS_EVENT_UPDATE_JAMMERS, LINKFUNC(removeCrowsActions)] call CBA_fnc_addEventHandler;

    if (GVAR(aceLoaded)) then {
        call FUNC(addAceActions);
    };
};
