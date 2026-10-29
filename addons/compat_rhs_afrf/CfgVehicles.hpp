class CfgVehicles {
    class rhs_gaz66_vmf;
    // All GAZ-66 (R-142N) variants inherit from this class. RHS has no marker of its own to find them with
    class rhs_gaz66_r142_base: rhs_gaz66_vmf {
        GVAR(jammer) = 1;
    };
};
