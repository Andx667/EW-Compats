#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Everything is the business of the local player: every client works out its own exposure, nothing is synced
if (hasInterface) then {
    // 0 to 1, how far the headache has got. Readable in the debug console as ewc_rf_exposure_exposure
    GVAR(exposure) = 0;
    GVAR(loopHandle) = -1;
    GVAR(lastTime) = 0;

    // Factor handed to ACE advanced fatigue, 1 while there is none
    GVAR(dutyFactor) = 1;

    // The player has been told about the headache and about the fatigue of this exposure
    GVAR(hintedHeadache) = false;
    GVAR(hintedFatigue) = false;

    // A jammer that is switched on, off or removed. Registered in preInit like in the other addons, the broadcast of the
    // jammers can arrive before postInit
    [CROWSEW_UPDATE_JAMMERS_EVENT, FUNC(updateLoop)] call CBA_fnc_addEventHandler;
};

// After the variables above: the callback of a setting can run as soon as the setting is added
#include "initSettings.inc.sqf"

ADDON = true;
