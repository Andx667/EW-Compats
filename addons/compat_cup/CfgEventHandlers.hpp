class Extended_PreStart_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_SCRIPT(XEH_preStart));
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_SCRIPT(XEH_preInit));
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_SCRIPT(XEH_postInit));
    };
};

// Runs for every unit and vehicle, but leaves at once while no Boomerang is on
class Extended_Fired_EventHandlers {
    class AllVehicles {
        class ADDON {
            fired = QUOTE(call FUNC(onFired));
        };
    };
};

class Extended_InitPost_EventHandlers {
    class LandVehicle {
        class ADDON {
            init = QUOTE(call FUNC(initVehicle));
        };
    };
};
