#include "script_component.hpp"

if (isServer) then {
    [QGVAR(syncJammer), LINKFUNC(duke_syncJammer)] call CBA_fnc_addEventHandler;
};
