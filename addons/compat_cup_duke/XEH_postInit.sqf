#include "script_component.hpp"

if (isServer) then {
    [QGVAR(toggle), LINKFUNC(handleToggle)] call CBA_fnc_addEventHandler;

    // The Boomerang and the DUKE exclude each other
    [EVENT_SYSTEM_ON, {
        params ["_vehicle", "_system"];

        if (_system != SYSTEM_DUKE && {_vehicle getVariable [QGVAR(on), false]}) then {
            [_vehicle, false] call FUNC(setJammer);
        };
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    // Crows adds its own (de)activate actions to every jammer. They'd toggle Crows without the DUKE and desync the two
    [CROWS_EVENT_UPDATE_JAMMERS, LINKFUNC(removeCrowsActions)] call CBA_fnc_addEventHandler;

    if (EGVAR(compat_cup,aceLoaded)) then {
        [SYSTEM_DUKE] call EFUNC(compat_cup,addAceActions);
    };
};
