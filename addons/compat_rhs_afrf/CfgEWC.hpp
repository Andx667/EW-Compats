class CfgEWC {
    class Jammers {
        class RHS_R142N {
            property = QGVAR(jammer);
            value = 1;
            radius = JAMMER_DEFAULT_RADIUS;
            falloffFactor = JAMMER_FALLOFF_FACTOR;
            capabilities[] = {CROWS_CAPABILITY_RADIO, CROWS_CAPABILITY_DRONE};
            enableVariable = QGVAR(enable);
        };
    };
};
