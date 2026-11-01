#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {
            "EWC_Redd_Tank_Fuchs_1A4_Hummel_Flecktarn",
            "EWC_Redd_Tank_Fuchs_1A4_Hummel_Tropentarn",
            "EWC_Redd_Tank_Fuchs_1A4_Hummel_Wintertarn"
        };
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"ewc_common", "Redd_Tank_Fuchs_1A4", "crowsEW_main"};
        author = AUTHOR;
        authors[] = {"Andx"};
        url = "https://github.com/Andx667/EW-Compats";
        VERSION_CONFIG;

        skipWhenMissingDependencies = 1;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgEWC.hpp"
#include "CfgVehicles.hpp"
