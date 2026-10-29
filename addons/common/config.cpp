#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        url = "https://github.com/Andx667/EW-Compats";
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"ewc_main", "cba_main"};
        units[] = {};
        weapons[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgEWC.hpp"
