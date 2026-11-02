# Compat RHS AFRF

The **GAZ-66 (R-142N)** radio vehicle of RHS AFRF becomes a broad spectrum jammer: with its mast deployed it jams ACRE radios and the control link of drones. RHS AFRF has no jammer of its own, so range and behaviour are defined by this addon. The USAF DUKE is in `compat_rhs_usaf`.

## How it works

- The mast is operated like in RHS: the actions *Deploy Mast* / *Fold Mast* (driver, vehicle standing), the animation source `mast_handler` or the editor attribute *Deploy Mast*. All of them end in `rhs_fnc_gaz66_radioDeploy`, which calls the functions listed in the vehicle variable `rhs_eh_gaz66_deploy` at the end. That is the only hook RHS offers.
- Every vehicle derived from `rhs_gaz66_r142_base` carries `ewc_compat_rhs_afrf_jammer = 1` (`CfgVehicles.hpp`) and so is a jammer of the registry in `ewc_common` (`CfgEWC >> Jammers >> RHS_R142N`). `ewc_common_fnc_setJammer` registers it on the server as a jammer in Crow's Electronic Warfare when the mast is first deployed, with the capabilities `VoiceCommsJammer` (radios) and `DroneJammer` (drones). `fnc_initVehicle` only adds our function `fnc_onDeploy` to the RHS hook list, on every machine, because the mast script runs on one machine only and the list is not public.
- `fnc_onDeploy` sends the CBA event `ewc_compat_rhs_afrf_mastToggled` to the server (`fnc_handleDeploy`). It remembers whether the mast is wanted up and waits until the door phase `mast_source` has reached 0.99 (RHS needs 5 s) or the mast is folded again, 15 s at most. Folding stops the jammer at once.
- `fnc_syncJammer` (server) matches Crow's Electronic Warfare to the mast and the settings: on with the mast up, off with the mast down, the vehicle destroyed or the settings turning it off. If the radius or the jammed signals of the settings differ from what is registered, the jammer is removed (`crowsEW_main_removeJammer`) and registered again by `ewc_common_fnc_addJammer`, because Crow's Electronic Warfare cannot change radii or capabilities of a jammer. Changes of the state show a hint to the crew (`ewc_common_fnc_notifyState`).
- A mast deployed in the editor is picked up once the server has registered its handlers (`fnc_initVehicle`, `CBA_missionTime > 0`).
- RHS sets the fuel of a vehicle with a deployed mast to 0, so the engine cannot run. There is no engine condition.
- Crow's Electronic Warfare adds its own (de)activate actions to every jammer. They would change its state without the mast. `ewc_common` removes them from the R-142N. The jammer is operated with the mast only.

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_initVehicle` | every machine | Class event handler for vehicles with the marker: adds `fnc_onDeploy` to the RHS hook list and, on the server, picks up a mast deployed in the editor |
| `fnc_onDeploy` | machine of the mast script | RHS hook: tells the server that the mast is deployed or folded |
| `fnc_handleDeploy` | server | Remembers the wanted mast state and waits for the mast to be up before syncing |
| `fnc_syncJammer` | server | Matches the jammer to the mast and settings: state, radius and jammed signals. Shows the hint of `ewc_common_fnc_notifyState` when the state changed |

## Settings

| Setting | Default | |
|---|---|---|
| Enable R-142N jamming | on | If off, the R-142N does not jam. Set by the server, applied the next time the mast is deployed or folded |
| R-142N jamming radius (m) | 500 | Radius with full jamming strength, 100 to 2000 m. The falloff band beyond it is 1.5 times the radius. Applied the next time the mast is deployed |
| Jam radios | on | Applied the next time the mast is deployed |
| Jam drones | on | Applied the next time the mast is deployed |

With both Jam radios and Jam drones off, the R-142N does not jam.

## Limitations

- Drones are jammed within the full radius only, Crow's Electronic Warfare has no falloff band for them. Radios fade out over the falloff band.
- The radius, falloff and the choice of a radio and drone jammer are not taken from RHS or a data sheet, they are a gameplay choice. The real R-142N is a command and staff radio vehicle.
- Everybody in range is jammed, including the own crew and allies. Crow's Electronic Warfare has no immunity apart from Zeus.
- The mast has no damage of its own, only the destruction of the vehicle stops the jammer.
- Crow's Electronic Warfare only works in multiplayer.
- The USAF DUKE (`compat_rhs_usaf`) and the other jammer vehicles are not affected.

## Dependencies

- [RHS AFRF](https://steamcommunity.com/sharedfiles/filedetails/?id=843425103) (`rhs_c_trucks`)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728) (`crowsEW_main`)

## Maintainer

- Andx
