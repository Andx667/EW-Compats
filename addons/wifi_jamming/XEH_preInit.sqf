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

// The connect condition runs for every wireless client in every sweep of AE3, so the Wi-Fi jammers that are on are taken
// from the jamMap once per change instead of on every call. Crows sends the jamMap to every machine with this event, a
// JIP client gets it on its request in the postInit of Crows
GVAR(jammers) = [];
[CROWSEW_UPDATE_JAMMERS_EVENT, {
    params [["_jamMap", createHashMap, [createHashMap]]];

    GVAR(jammers) = (values _jamMap) select {(_x select 3) && {WIFI_JAM_CAP in (_x select 4)}} apply {
        _x params ["_jammer", "_radFalloff", "_radEffective"];
        [_jammer, _radEffective, _radFalloff]
    };
}] call CBA_fnc_addEventHandler;

ADDON = true;
