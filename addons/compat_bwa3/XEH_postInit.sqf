#include "script_component.hpp"

if (isServer) then {
    [QGVAR(ecmToggled), LINKFUNC(handleToggle)] call CBA_fnc_addEventHandler;
};
