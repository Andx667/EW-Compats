#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {
            QGVAR(moduleAddBftJammer)
        };
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"ewc_main", "A3_Modules_F", "crowsEW_main", "crowsEW_editormodules", "crowsEW_zeus", "crowsEW_spectrum", "zen_custom_modules", "zen_dialog", "cTab_core", "cTab_main"};
        author = AUTHOR;
        authors[] = {"Andx"};
        url = "https://github.com/Andx667/EW-Compats";
        VERSION_CONFIG;

        skipWhenMissingDependencies = 1;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
