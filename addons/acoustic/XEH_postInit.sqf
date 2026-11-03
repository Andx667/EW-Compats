#include "script_component.hpp"

if (isServer) then {
    // A sensor added on another machine (Zeus, a script of a client) is kept by the server
    [QGVAR(addSensor), LINKFUNC(addSensor)] call CBA_fnc_addEventHandler;
    [QGVAR(removeSensor), LINKFUNC(removeSensor)] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(trackUpdated), LINKFUNC(onTrackUpdated)] call CBA_fnc_addEventHandler;
    [QGVAR(trackLost), LINKFUNC(onTrackLost)] call CBA_fnc_addEventHandler;

    // The Zeus modules are made on the machines of the players
    call FUNC(zeusRegister);
};
