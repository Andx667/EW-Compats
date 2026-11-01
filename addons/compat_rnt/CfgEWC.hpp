class CfgEWC {
    class Jammers {
        class RNT_HUMMEL {
            property = QGVAR(jammer);
            value = 1;
            radius = JAMMER_DEFAULT_RADIUS;
            falloffFactor = JAMMER_FALLOFF_FACTOR;
            // Like the real Hummel, which jams radio in VHF and UHF, no drones
            capabilities[] = {CROWS_CAPABILITY_RADIO};
        };
    };
};
