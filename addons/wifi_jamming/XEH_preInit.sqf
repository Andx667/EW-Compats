#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

/*
 * Registered in preInit, not postInit: the module function may raise Crows' addJammer as early as mission init, and a
 * crowsEW_main_updateJammers broadcast that arrives before our handler exists would leave that jammer without its
 * Spectrum signal until the next jammer change.
 */
if (isServer) then {
    [CROWSEW_UPDATE_JAMMERS_EVENT, FUNC(onUpdateJammersServer)] call CBA_fnc_addEventHandler;
};

ADDON = true;
