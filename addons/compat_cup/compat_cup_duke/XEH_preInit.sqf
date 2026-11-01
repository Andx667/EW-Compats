#include "script_component.hpp"

SUBADDON = false;

#include "XEH_PREP.hpp"

// Vehicle (net ID) -> mines it holds disabled. Only exists on the server
GVAR(duke_active) = createHashMap;
GVAR(duke_loopHandle) = -1;

// The crew switches the DUKE with the actions of ewc_common
[
    SYSTEM_DUKE,
    QGVAR(duke_toggle),
    QGVAR(duke_on),
    LINKFUNC(duke_canActivate),
    "STR_ewc_compat_cup_duke_activate",
    "STR_ewc_compat_cup_duke_deactivate",
    {([_this select 0, SYSTEM_DUKE] call FUNC(getSources)) isNotEqualTo []}
] call EFUNC(common,registerSwitch);

#include "initSettings.inc.sqf"

SUBADDON = true;
