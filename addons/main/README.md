# Main

Shared code of the compat addons: a registry of jammer vehicles for Crow's Electronic Warfare.

## Registry

A compat addon lists its vehicles in `CfgEWC >> Jammers` and `ewc_main` does the rest, with no code in the addon:

```cpp
class CfgEWC {
    class Jammers {
        class MY_JAMMER {
            property = "my_jammer_type";            // config entry of the vehicle that marks it
            value = 1;                              // optional, the entry has to be this number. Without it, it has to be a non-empty text
            radius = 50;                            // full jamming radius in m
            falloffFactor = 1.5;                    // the effect has faded out at this times the radius
            capabilities[] = {"VoiceCommsJammer"};  // optional, Crow's capabilities, defaults to radio
            enableVariable = "my_addon_enable";     // optional, name of a (setting) variable. Vehicles are skipped while it is false
        };
    };
};
```

## How it works

- `fnc_initVehicle` is a class event handler on `LandVehicle`. `fnc_getJammerConfig` finds the entry of a vehicle (cached per vehicle class). Vehicles without one are ignored.
- On every machine it raises the local CBA event `ewc_main_vehicleInit` with `[vehicle, class name of the entry]`, for parts that have to exist everywhere (event handlers of the vehicle). An addon has to listen in `preInit`, so editor-placed vehicles are not missed.
- On the server, `fnc_addJammer` registers the vehicle as a disabled jammer through `crowsEW_main_addJammer`, only once `CBA_missionTime > 0`, because editor-placed vehicles initialise before Crow's Electronic Warfare has registered its handlers. It stores `[enabled, radius]` in the variable `ewc_main_jammerState`. Addons that follow a vehicle (RHS) replace the jammer by calling `fnc_addJammer` again with another radius.
- Crow's Electronic Warfare adds its own (de)activate actions to every jammer. They would change its state without the compat addon. `fnc_removeCrowsActions` removes them from the vehicles of the registry on every `crowsEW_main_updateJammers`. `fnc_clearCrowsActions` removes only those, recognised by their coloured title, so the switch of an addon stays. On a machine that is server and client at once, Crow's adds the actions *after* it broadcasts that update, so `fnc_addJammer` clears them directly as well.
- `ewc_compat_cup` does not use the entries, its radius depends on the settings and the shown antennas. It only calls `fnc_addJammer` and `fnc_clearCrowsActions`.
