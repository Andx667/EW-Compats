#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        url = "https://github.com/Andx667/EW-Compats";
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main"};
        units[] = {};
        weapons[] = {};
        VERSION_CONFIG;
    };
};

class CfgMods {
    class PREFIX {
        dir = "@EW_Compats";
        name = CSTRING(displayName);
        picture = "A3\Ui_f\data\Logos\arma3_expansion_alpha_ca.paa";
        hidePicture = "true";
        hideName = "true";
        actionName = "Website";
        action = "https://github.com/Andx667/EW-Compats";
        description = "Electronic warfare compatibility: BFT jamming for cTab, Dingo CG13 and RHS DUKE radio jammers via Crow's Electronic Warfare.";
    };
};
