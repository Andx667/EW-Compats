// RHS calls rhs_fnc_duke_vg when the DUKE antenna is hidden or shown, on every vehicle with a DUKE. It only takes the weapon
// of a DUKE that is off away: one that is on keeps its weapon and the jamming, and the weapon of the off state comes back
// when the crew switches it. This replaces the function by fnc_vg, which sees to both and tells the server
class CfgFunctions {
    class RHS {
        class functions {
            class duke_vg {
                file = QPATHTOF(compat_rhs_usaf_duke\functions\fnc_vg.sqf);
                description = "DUKE Virtual Garage action, replaced by EW Compats";
            };
        };
    };
};
