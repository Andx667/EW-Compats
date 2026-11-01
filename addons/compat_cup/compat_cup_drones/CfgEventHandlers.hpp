class Extended_PreStart_EventHandlers {
    class SUBADDON {
        init = QUOTE(call COMPILE_SCRIPT(compat_cup_drones\XEH_preStart));
    };
};

class Extended_PreInit_EventHandlers {
    class SUBADDON {
        init = QUOTE(call COMPILE_SCRIPT(compat_cup_drones\XEH_preInit));
    };
};

class Extended_InitPost_EventHandlers {
    class CUP_MQ9_Base {
        class SUBADDON {
            serverInit = QUOTE(call FUNC(drones_initVehicle));
        };
    };
    class CUP_Pchela1T_Base {
        class SUBADDON {
            serverInit = QUOTE(call FUNC(drones_initVehicle));
        };
    };
};
