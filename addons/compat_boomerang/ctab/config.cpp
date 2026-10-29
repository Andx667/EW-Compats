#include "script_component.hpp"

// A config.cpp in a folder of a PBO is an addon of its own for the game. This one is skipped alone when cTab is not
// loaded, the rest of Compat Boomerang is not affected
class CfgPatches {
    class SUBADDON {
        name = COMPONENT_NAME;
        addonRootClass = QUOTE(ADDON);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {QUOTE(ADDON), "cTab_core", "cTab_main"};

        skipWhenMissingDependencies = 1;
        author = AUTHOR;
        authors[] = {\"Andx\"};
        url = \"https://github.com/Andx667/EW-Compats\";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
