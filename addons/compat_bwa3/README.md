# Compat BWA3

The Dingo 2 CG13 also jams ACRE radios, in addition to the IED jammer. Both are controlled with the same switch.

## How it works

- BWA3 switches the CG13 only through the variable `BWA3_Dingo2_ECM_on` (user actions `TurnOnCG13` / `TurnOffCG13`) and offers no event or callback. The `statement` entries of both user actions are therefore overridden in `CfgVehicles.hpp`: they still set the variable and additionally send the event `ewc_compat_bwa3_ecmToggled` to the server.
- BWA3 switches the CG13 off when the engine stops (its `POWER_FAILURE` transition) without any event. An `Engine` event handler (`fnc_initVehicle`) therefore sends the same event with `false` when the engine stops. It has to be registered on every client, because `Engine` only fires where the vehicle is local. When the engine stops without a driver (he got out) while the CG13 is on, the handler starts it again, because getting out stops the engine and an eject does not.
- Every vehicle with `BWA3_hasECM = 1` is a jammer of the registry in `ewc_main` (`CfgEWC >> Jammers >> BWA3_CG13`). `ewc_main` registers it once on the server as a disabled radio jammer in Crow's Electronic Warfare, see the main addon.
- `fnc_handleToggle` switches the jammer with `crowsEW_main_toggleJammer`. The jamming itself (ACRE interference, Spectrum Device signal, cleanup on destruction) is done by Crow's Electronic Warfare.
- Crow's Electronic Warfare adds its own (de)activate actions to every jammer. They would change its state without the CG13 switch. `ewc_main` removes them from the Dingos, see the main addon.

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_initVehicle` | every machine | Class event handler for vehicles with `BWA3_hasECM`: watches the `Engine` event |
| `fnc_handleToggle` | server | Switches that jammer with the CG13 (`ewc_compat_bwa3_ecmToggled`, with the reason when the engine switched it off) and shows the hint of `ewc_main_fnc_notifyState` |

## Settings

| Setting | Default | |
|---|---|---|
| Enable BWA3 CG13 jamming | on | If off, the Dingos do not jam radios. Set by the server |

## Limitations

- Everybody in range is jammed, including the own crew and allies. Crow's Electronic Warfare has no immunity apart from Zeus.
- The full jamming radius is the radius of the IED jammer (40 m, hardcoded in BWA3, so `ECM_EFFECTIVE_RADIUS` has to be adjusted if BWA3 changes it). The falloff radius is 1.5 times that.
- A triggered IED explodes when it leaves the jamming range. This is BWA3's own behaviour.
- IEDs of CUP (`CUP_IED_V1_Ammo` to `V4`) are not jammed: BWA3 only jams `PipeBombBase`, and CUP's IEDs derive from `MineBase`. This is BWA3's own behaviour.
- Crow's Electronic Warfare only works in multiplayer.

## Dependencies

- [BWmod](https://steamcommunity.com/sharedfiles/filedetails/?id=1200127537) (`bwa3_dingo2`)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728) (`crowsEW_main`)

## Maintainer

- Andx
