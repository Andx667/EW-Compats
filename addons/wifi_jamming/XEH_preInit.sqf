#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Handle of the loop that checks the connections, -1 while no Wi-Fi jammer is on, see fnc_onUpdateJammersServer
GVAR(loopHandle) = -1;

/*
 * Registered in preInit, not postInit: the module function may raise Crows' addJammer as early as mission init, and a
 * crowsEW_main_updateJammers broadcast that arrives before our handler exists would leave that jammer without its
 * Spectrum signal (and the loop without its start) until the next jammer change.
 */
if (isServer) then {
    [CROWSEW_UPDATE_JAMMERS_EVENT, FUNC(onUpdateJammersServer)] call CBA_fnc_addEventHandler;
};

ADDON = true;
