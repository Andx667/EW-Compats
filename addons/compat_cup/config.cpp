#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"ewc_main", "crowsEW_main", "CUP_WheeledVehicles_M1151", "CUP_WheeledVehicles_M1240", "CUP_WheeledVehicles_RG31", "CUP_TrackedVehicles_M1Abrams"};
        author = AUTHOR;
        authors[] = {"Andx"};
        url = "https://github.com/Andx667/EW-Compats";
        VERSION_CONFIG;

        skipWhenMissingDependencies = 1;
    };
};

#include "CfgEventHandlers.hpp"
