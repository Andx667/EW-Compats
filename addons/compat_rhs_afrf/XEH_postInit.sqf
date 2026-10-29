#include "script_component.hpp"

if (isServer) then {
    [QGVAR(mastToggled), LINKFUNC(handleDeploy)] call CBA_fnc_addEventHandler;
    [QGVAR(syncJammer), LINKFUNC(syncJammer)] call CBA_fnc_addEventHandler;
};
