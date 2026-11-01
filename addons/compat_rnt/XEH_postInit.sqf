#include "script_component.hpp"

if (isServer) then {
    [QGVAR(toggle), LINKFUNC(handleToggle)] call CBA_fnc_addEventHandler;
    [QGVAR(syncJammer), LINKFUNC(syncJammer)] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [SYSTEM_ID] call EFUNC(common,addAceSwitchActions);
};
