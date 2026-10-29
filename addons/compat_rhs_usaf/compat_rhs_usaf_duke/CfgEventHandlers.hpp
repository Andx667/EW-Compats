class Extended_PreStart_EventHandlers {
    class SUBADDON {
        init = QUOTE(call COMPILE_SCRIPT(compat_rhs_usaf_duke\XEH_preStart));
    };
};

class Extended_PreInit_EventHandlers {
    class SUBADDON {
        init = QUOTE(call COMPILE_SCRIPT(compat_rhs_usaf_duke\XEH_preInit));
    };
};

class Extended_PostInit_EventHandlers {
    class SUBADDON {
        init = QUOTE(call COMPILE_SCRIPT(compat_rhs_usaf_duke\XEH_postInit));
    };
};
