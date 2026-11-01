class CfgVehicles {
    // The Fuchs 1A4 of Redd'n'Tank has no EloKa variant and no jammer antenna, so the Hummel is its Jaeger with a new
    // name. It has the model, the textures and the crew of the Jaeger and carries the marker that makes it a jammer
    // in the registry of ewc_common (CfgEWC >> Jammers >> REDD_HUMMEL)
    class Redd_Tank_Fuchs_1A4_Jg_Flecktarn;
    class Redd_Tank_Fuchs_1A4_Jg_Tropentarn;
    class Redd_Tank_Fuchs_1A4_Jg_Wintertarn;

    class EWC_Redd_Tank_Fuchs_1A4_Hummel_Flecktarn: Redd_Tank_Fuchs_1A4_Jg_Flecktarn {
        displayName = CSTRING(hummel_flecktarn);
        author = AUTHOR;
        GVAR(jammer) = 1;
    };

    class EWC_Redd_Tank_Fuchs_1A4_Hummel_Tropentarn: Redd_Tank_Fuchs_1A4_Jg_Tropentarn {
        displayName = CSTRING(hummel_tropentarn);
        author = AUTHOR;
        GVAR(jammer) = 1;
    };

    class EWC_Redd_Tank_Fuchs_1A4_Hummel_Wintertarn: Redd_Tank_Fuchs_1A4_Jg_Wintertarn {
        displayName = CSTRING(hummel_wintertarn);
        author = AUTHOR;
        GVAR(jammer) = 1;
    };
};
