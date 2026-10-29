#include "script_component.hpp"

if (isServer) then {
    [QGVAR(syncJammer), LINKFUNC(syncJammer)] call CBA_fnc_addEventHandler;
};
