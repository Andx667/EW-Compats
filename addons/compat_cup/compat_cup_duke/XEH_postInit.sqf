#include "script_component.hpp"

if (isServer) then {
    [QGVAR(duke_toggle), LINKFUNC(duke_handleToggle)] call CBA_fnc_addEventHandler;

    // The Boomerang and the DUKE exclude each other, unless the setting allows both
    [EVENT_SYSTEM_ON, {
        params ["_vehicle", "_system"];

        if (GVAR(allowBoth)) exitWith {};

        if (_system != SYSTEM_DUKE && {_vehicle getVariable [QGVAR(duke_on), false]}) then {
            [_vehicle, false] call FUNC(duke_setJammer);
        };
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {

    [SYSTEM_DUKE] call EFUNC(common,addAceSwitchActions);
};
