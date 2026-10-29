# Compat CUP DUKE

Vehicles with a shown DUKE antenna get a DUKE switch. A running DUKE jams ACRE radios and IEDs around the vehicle. CUP only models the antenna, so this addon provides the whole function. It builds on `compat_cup`.

## How it works

- The M1240 family has two antennas, `hide_Duke_antenna` and `hide_crew_duke`: all shown gives the full range, only one shown 60 % of it (like RHS with a destroyed antenna), none shown switches the DUKE off (`fnc_getRangeScale`, `fnc_getRadius`).
- Every DUKE vehicle (`fnc_initVehicle`) is registered once by the server as a disabled radio jammer (`VoiceCommsJammer`) in Crow's Electronic Warfare (`ewc_main_fnc_addJammer`, called by `fnc_registerJammer`), only once `CBA_missionTime > 0`, because editor-placed vehicles initialise before Crow's Electronic Warfare has registered its handlers. Switching the DUKE toggles that jammer (`fnc_handleToggle`, `fnc_setJammer`).
- While at least one DUKE is on, a server side loop (`fnc_jamLoop`, once per second) switches a DUKE off when its vehicle is destroyed, its antennas are hidden or its engine stops. It also keeps the IEDs in range disabled.
- IED jamming is the approach of the Dingo CG13: IEDs (`PipeBombBase` and the IEDs of CUP, `CUP_IED_V1_Ammo` to `V4`, which derive from `MineBase` instead) in range, found with `nearestMines` so the engine searches around the vehicle instead of going through every mine of the mission, get `enableSimulationGlobal false` and are enabled again when they leave the range or the DUKE stops (`fnc_updateMines`, `fnc_releaseMines`). The addon only frees mines it disabled itself.
- Crow's Electronic Warfare adds its own (de)activate actions to every jammer. They would change its state without the DUKE. `ewc_main_fnc_clearCrowsActions` removes only those, recognised by their coloured title, on every `crowsEW_main_updateJammers` (`fnc_removeCrowsActions` picks the vehicles with a DUKE).
- A changed radius, or an antenna hidden or shown again on a vehicle with two, replaces the Crow's Electronic Warfare jammer, because it cannot change the radii of a jammer.
- A change of the state shows a hint to the people in the vehicle (`ewc_main_fnc_notifyState` in `fnc_setJammer`). A DUKE the loop switches off passes the reason of `fnc_getBlockReason`.
- The DUKE and the Boomerang exclude each other, see `compat_cup_boomerang`, unless `ewc_compat_cup_allowBoth` of `compat_cup` is on. The DUKE listens to `ewc_compat_cup_systemOn` and switches off when the Boomerang is switched on.

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_initVehicle` | every machine | Class event handler for vehicles with a DUKE antenna: adds the actions and, on the server, registers the jammer |
| `fnc_canActivate` | any | Can the DUKE be switched on (setting, alive, antenna, engine) |
| `fnc_handleToggle` | server | Checks a switch request and tells the Boomerang to switch off (`ewc_compat_cup_systemOn`) |
| `fnc_registerJammer` | server | Registers the DUKE as a radio jammer in Crow's Electronic Warfare |
| `fnc_getBlockReason` | any | Why the DUKE cannot be on (setting, destroyed, antenna, engine), or an empty text. `fnc_canActivate` is true when there is none |
| `fnc_getRangeScale` | any | Share of the range from the antennas shown |
| `fnc_getRadius` | any | Full jamming radius: setting times range scale |
| `fnc_setJammer` | server | Switches the DUKE: state, radio jammer and mine jamming |
| `fnc_jamLoop` | server | Once per second while a DUKE is on: switches it off when it no longer works, keeps mines jammed |
| `fnc_updateMines` | server | Disables the IEDs in range and frees those that left |
| `fnc_releaseMines` | server | Enables mines a DUKE held again |
| `fnc_removeCrowsActions` | every machine | Calls `ewc_main_fnc_clearCrowsActions` for the DUKE vehicles on every `crowsEW_main_updateJammers` |

## Settings

| Setting | Default | |
|---|---|---|
| Enable CUP DUKE | on | Set by the server |
| Jamming radius | 50 m | Full jamming radius for radios and IEDs. The radio falloff band is 1.5 times that. Set by the server |
| Jam IEDs | on | Set by the server |

The switch is a setting of `compat_cup`.

## Limitations

- Everybody in range is jammed, including the own crew and allies. Crow's Electronic Warfare has no immunity apart from Zeus.
- Only IEDs are jammed, not other mines, including the anti-tank mines of CUP.
- Disabled IEDs are shared with the Dingo CG13 and the RHS DUKE. If both jam the same IED and one stops first, the IED is free for up to a second, until the other one disables it again.
- An IED that was triggered inside the range is expected to explode when it is freed, as with the Dingo CG13 and the RHS DUKE.
- The DUKE is checked once per second, so a hidden antenna keeps working for up to a second.
- Crow's Electronic Warfare only works in multiplayer.

## Dependencies

- `compat_cup` and [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728) (`crowsEW_main`)

## Maintainer

- Andx
