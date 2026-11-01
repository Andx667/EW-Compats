// The Stryker family shows a DUKE antenna (animation source Hide_DUKE) but RHS gives it no DUKE. Add the RHS DUKE weapon
// as the HMMWV family has it: rhs_duke_type registers the vehicle as jammer, rhsusf_weap_duke is the switch of the driver.
// RHS has no hitpoints for the antenna of the Stryker, so it cannot be destroyed and always has the full range.
class CfgVehicles {
    class Wheeled_APC_F;
    class rhsusf_stryker_base: Wheeled_APC_F {
        class AnimationSources;
    };
    class rhsusf_stryker_m1126_base: rhsusf_stryker_base {
        weapons[] = {"TruckHorn3", "rhsusf_weap_duke"};
        magazines[] = {"rhsusf_mag_duke"};
        rhs_duke_type = "rhsusf_duke";

        class AnimationSources: AnimationSources {
            // Adds or removes the weapon with the antenna, RHS does the same for its other vehicles
            class Hide_DUKE {
                onPhaseChanged = "_this call rhs_fnc_duke_vg;";
            };
        };
    };

    class rhsusf_stryker_m1126_m2_base: rhsusf_stryker_m1126_base {};

    // The M1132 has no horn and carries the lane marker
    class rhsusf_stryker_m1132_m2_base: rhsusf_stryker_m1126_m2_base {
        weapons[] = {"rhsusf_weap_duke"};
        magazines[] = {"rhsusf_mag_laneMarkerSystem", "rhsusf_mag_duke"};
    };

    // These start with the antenna hidden. The weapon comes with the antenna, as onPhaseChanged does not run at the start
    class rhsusf_stryker_m1127_base: rhsusf_stryker_m1126_base {
        weapons[] = {"TruckHorn3"};
    };

    class rhsusf_stryker_m1134_base: rhsusf_stryker_m1126_m2_base {
        weapons[] = {"TruckHorn3"};
    };
};
