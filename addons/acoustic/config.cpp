#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {
            QGVAR(moduleAddSensor)
        };
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"ewc_main", "cba_main", "A3_Modules_F"};
        author = AUTHOR;
        authors[] = {"Andx"};
        url = "https://github.com/Andx667/EW-Compats";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgEWC.hpp"
#include "CfgVehicles.hpp"
