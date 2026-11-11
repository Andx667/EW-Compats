#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Everything is the business of the local player: every client works out its own exposure, nothing is synced
if (hasInterface) then {
    // 0 to 1, how far the headache has got. Readable in the debug console as ewc_rf_exposure_exposure
    GVAR(exposure) = 0;
    GVAR(loopHandle) = -1;
    GVAR(lastTime) = 0;

    // 0 none, 1 headache, 2 fatigue, see the event ewc_rf_exposure_API_stageChanged
    GVAR(stage) = 0;

    // Factor handed to ACE advanced fatigue, 1 while there is none
    GVAR(dutyFactor) = 1;

    // The player has been told about the headache and about the fatigue of this exposure
    GVAR(hintedHeadache) = false;
    GVAR(hintedFatigue) = false;

    // The jammers that are on, taken from the jamMap once per change instead of every second. Entries are
    // [object, is a vehicle, bounding radius]
    GVAR(jammers) = [];

    // A jammer that is switched on, off or removed. Registered in preInit like in the other addons, the broadcast of the
    // jammers can arrive before postInit. Crows' own handler runs after ours, so its global jamMap still holds the old
    // state here: only the map of the event is up to date
    [CROWS_EVENT_UPDATE_JAMMERS, {
        params [["_jamMap", createHashMap, [createHashMap]]];

        GVAR(jammers) = (values _jamMap) select {(_x select 3) && {!isNull (_x select 0)}} apply {
            private _jammer = _x select 0;
            [_jammer, VEHICLE_CLASSES findIf {_jammer isKindOf _x} != -1, (boundingBoxReal _jammer) select 2]
        };

        call FUNC(updateLoop);
    }] call CBA_fnc_addEventHandler;
};

// After the variables above: the callback of a setting can run as soon as the setting is added
#include "initSettings.inc.sqf"

ADDON = true;
