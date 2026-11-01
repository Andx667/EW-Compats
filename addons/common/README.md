# Common

Shared code of the compat addons: a registry of jammer vehicles for Crow's Electronic Warfare, and the hint that tells a crew about the state of a system. The structure (mod entry, macros, version) is in `ewc_main`.

## Registry

A compat addon lists its vehicles in `CfgEWC >> Jammers` and `ewc_common` does the rest, with no code in the addon:

```cpp
class CfgEWC {
    class Jammers {
        class MY_JAMMER {
            property = "my_jammer_type";            // config entry of the vehicle that marks it
            value = 1;                              // optional, the entry has to be this number. Without it, it has to be a non-empty text
            radius = 50;                            // full jamming radius in m
            falloffFactor = 1.5;                    // the effect has faded out at this times the radius
            capabilities[] = {"VoiceCommsJammer"};  // optional, Crow's capabilities, defaults to radio
        };
    };
};
```

## How it works

- `fnc_initVehicle` is a class event handler on `LandVehicle`. `fnc_getJammerConfig` finds the entry of a vehicle (cached per vehicle class). Vehicles without one are ignored.
- On every machine it raises the local CBA event `ewc_common_vehicleInit` with `[vehicle, class name of the entry]`, for parts that have to exist everywhere (event handlers of the vehicle). An addon has to listen in `preInit`, so editor-placed vehicles are not missed.
- On the server, `fnc_addJammer` registers the vehicle as a disabled jammer through `crowsEW_main_addJammer`, only once `CBA_missionTime > 0`, because editor-placed vehicles initialise before Crow's Electronic Warfare has registered its handlers. It stores `[enabled, radius]` in the variable `ewc_common_jammerState`. Addons that follow a vehicle (RHS USAF, RHS AFRF) replace the jammer by calling `fnc_addJammer` again with another radius. The R-142N of RHS AFRF also passes other capabilities (fifth argument), which replace those of the entry.
- Crow's Electronic Warfare adds its own (de)activate actions to every jammer. They would change its state without the compat addon. `fnc_removeCrowsActions` removes them from every jammer registered by `fnc_addJammer` (marked with the public variable `ewc_common_isJammer`) on `crowsEW_main_updateJammers`, one frame later, and only from jammers it has not cleaned yet, so a switch does not walk the actions of all jammers: Crow's adds the actions of a new jammer in its own handler of the same event, which runs after ours (ours is registered in `preInit`, Crow's in `postInit`), so they would stay until the next update. `fnc_clearCrowsActions` removes only those, recognised by their coloured title, so the switch of an addon stays. On a machine that is server and client at once, Crow's adds the actions *after* it broadcasts that update, so `fnc_addJammer` clears them directly as well.
- `ewc_compat_cup_duke` does not use the entries, its radius depends on the settings and the shown antennas. It only calls `fnc_addJammer`.

## Switch actions

A system that the crew switches on and off (the CUP DUKE, the Boomerang, the Hummel of `compat_rnt`) shares the actions of `ewc_common`:

- `fnc_registerSwitch` (in preInit, on every machine) registers the system under an id: the server event the actions raise with `[vehicle, switch on]`, the public variable that holds its state, the code that says whether it can be switched on, the stringtable keys of the two titles and, for ACE, the code that says whether a vehicle has the system.
- `fnc_addSwitchActions` adds the scroll wheel actions to a vehicle (call it where the vehicle initialises). `fnc_addAceSwitchActions` adds the ACE self-interactions to all land vehicles once, and the registered code limits them to the vehicles with the system.
- `fnc_canToggle` is the condition of both: `fnc_canOperate` (driver, commander or gunner, in the style of the setting `ewc_common_actionMode`) and the state of the system.

## Setting a jammer

`fnc_setJammer` brings the jammer of a registered vehicle in line with a wanted state on the server: it switches it on or off, and when the radius or the capabilities differ from what is registered it removes the jammer (`crowsEW_main_removeJammer`) and registers it again with `fnc_addJammer`, because Crow's Electronic Warfare cannot change them. A negative radius or empty capabilities keep what is registered. The DUKEs, the R-142N and the Hummel use it. `fnc_addJammer` stores what it registered in the variables `ewc_common_jammerState` (`[enabled, radius]`) and `ewc_common_jammerCapabilities`.

## State hint

`fnc_notifyState` tells the people in a vehicle that one of its systems was switched on or off. A compat addon calls it on the server where the state changes, with the name of the system and, for a system that switched itself off, a reason. It raises the CBA event `ewc_common_stateChanged`, and `fnc_onStateChanged` shows a `hintSilent` on the machines of the vehicle's occupants, for example `DUKE off: engine stopped`. The reasons are the strings `ewc_common_reason_<reason>`, a reason without one is left out.
