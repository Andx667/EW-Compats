#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// The crew switches the Hummel with the actions of ewc_common. The Hummel is marked in the config of its class
[
    SYSTEM_ID,
    QGVAR(toggle),
    QGVAR(on),
    LINKFUNC(canActivate),
    QUOTE(STR_ewc_compat_rnt_activate),
    QUOTE(STR_ewc_compat_rnt_deactivate),
    {getNumber (configOf (_this select 0) >> QGVAR(jammer)) == 1}
] call EFUNC(common,registerSwitch);

#include "initSettings.inc.sqf"

// Before the vehicles initialise, so editor-placed ones are not missed
[QEGVAR(common,vehicleInit), LINKFUNC(initVehicle)] call CBA_fnc_addEventHandler;

ADDON = true;
