#include "script_component.hpp"

// A config.cpp in a folder of a PBO is an addon of its own for the game. This one is skipped alone when RHS USAF or Crow's
// Electronic Warfare is not loaded, the rest of Compat RHS USAF is not affected
class CfgPatches {
    class SUBADDON {
        addonRootClass = QUOTE(ADDON);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {QUOTE(ADDON), "rhsusf_c_heavyweapons", "crowsEW_main"};

        skipWhenMissingDependencies = 1;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgEWC.hpp"
#include "CfgAmmo.hpp"
