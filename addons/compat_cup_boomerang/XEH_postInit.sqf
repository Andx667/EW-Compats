#include "script_component.hpp"

if (isServer) then {
    // The Boomerang and the DUKE exclude each other. The DUKE listens to this event and switches off
    [QEGVAR(compat_boomerang,switchedOn), {
        params ["_vehicle"];

        [EVENT_SYSTEM_ON, [_vehicle, SYSTEM_BOOMERANG]] call CBA_fnc_localEvent;
    }] call CBA_fnc_addEventHandler;

    // ...and the other way round
    [EVENT_SYSTEM_ON, {
        params ["_vehicle", "_system"];

        if (_system != SYSTEM_BOOMERANG && {_vehicle getVariable [QEGVAR(compat_boomerang,on), false]}) then {
            [_vehicle, false] call EFUNC(compat_boomerang,setState);
        };
    }] call CBA_fnc_addEventHandler;
};
