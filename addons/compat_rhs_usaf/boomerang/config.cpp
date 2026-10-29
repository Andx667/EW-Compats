#include "script_component.hpp"

// A config.cpp in a folder of a PBO is an addon of its own for the game. This one is skipped alone when Compat Boomerang
// or the M1245 SOCOM is not loaded, the rest of Compat RHS USAF is not affected
class CfgPatches {
    class SUBADDON {
        addonRootClass = QUOTE(ADDON);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {QUOTE(ADDON), "ewc_compat_boomerang", "rhsusf_c_MATV"};

        skipWhenMissingDependencies = 1;
    };
};

#include "CfgEWC.hpp"
