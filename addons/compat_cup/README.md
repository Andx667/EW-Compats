# Compat CUP

CUP models two systems on some of its vehicles and gives them no function: the **DUKE** antenna and the **Boomerang** shot finder. This addon makes both work. A running DUKE jams ACRE radios and IEDs around the vehicle, a running Boomerang reports shots near the vehicle. A vehicle runs only one of them.

## How it works

### Shared

- CUP only models both systems. The antennas are animation sources that can be hidden, and there is nothing behind them, so this addon provides the whole function.
- A vehicle counts as equipped if its `AnimationSources` contain one of these (`fnc_getSources`):

  | System | Sources |
  |---|---|
  | DUKE | `hide_antenna_duke` (M1151), `hide_Duke_antenna` and `hide_crew_duke` (M1240), `hide_duke_antennas` (Abrams), `SYS_crewduke` (RG-31) |
  | Boomerang | `hide_antenna_boomerang` (M1151, M1240), `SYS_boomerang` (RG-31) |

  Classes inherited from a parent are not listed as children, so every class up the inheritance chain is read. The result is cached per class, so no class list has to be kept.
- An antenna is shown at phase 0 and hidden at phase 1 (`animationSourcePhase`). A system only works while one of its antennas is shown (`fnc_canActivate`, `fnc_isShown`).
- Crew can switch a system with a scroll wheel action, an ACE self-interaction or both (CBA setting `ewc_compat_cup_actionMode`). The request goes to the server (`ewc_compat_cup_toggle`, with the system), which checks it again (`fnc_handleToggle`). The states are the public variables `ewc_compat_cup_dukeOn` and `ewc_compat_cup_boomerangOn`.
- The systems exclude each other. Switching one on switches the other one off in `fnc_handleToggle`.
- Both can be disabled in the settings (`ewc_compat_cup_enableDuke`, `ewc_compat_cup_enableBoomerang`). They are part of `fnc_canActivate`, so a running system switches off.

### DUKE

- The M1240 family has two antennas, `hide_Duke_antenna` and `hide_crew_duke`: all shown gives the full range, only one shown 60 % of it (like RHS with a destroyed antenna), none shown switches the DUKE off (`fnc_getRangeScale`, `fnc_getRadius`).
- Every DUKE vehicle is registered once by the server as a disabled radio jammer (`VoiceCommsJammer`) in Crow's Electronic Warfare (`crowsEW_main_addJammer`), only once `CBA_missionTime > 0`, because editor-placed vehicles initialise before Crow's Electronic Warfare has registered its handlers. Switching the DUKE toggles that jammer (`fnc_setJammer`).
- While at least one DUKE is on, a server side loop (`fnc_jamLoop`, once per second) switches a DUKE off when its vehicle is destroyed, its antennas are hidden or, if required, its engine stops. It also keeps the IEDs in range disabled.
- IED jamming is the approach of the Dingo CG13: IEDs (`PipeBombBase`) in range, found with `nearestMines` so the engine searches around the vehicle instead of going through every mine of the mission, get `enableSimulationGlobal false` and are enabled again when they leave the range or the DUKE stops (`fnc_updateMines`, `fnc_releaseMines`). The addon only frees mines it disabled itself.
- Crow's Electronic Warfare adds its own (de)activate actions to every jammer. They would change its state without the DUKE. `fnc_clearCrowsActions` removes only those, recognised by their coloured title, on every `crowsEW_main_updateJammers`. The other addons use `removeAllActions`, which would also remove the DUKE switch here.

### Boomerang

- The Boomerang does not use Crow's Electronic Warfare itself, but the addon is only loaded together with it. `fnc_setBoomerang` keeps a list of the vehicles with a Boomerang that is on (`ewc_compat_cup_boomerangVehicles`) and broadcasts it. A server side loop (`fnc_boomerangLoop`) switches a Boomerang off when its vehicle is destroyed, its antenna is hidden, its engine stops or it is disabled.
- Every projectile of the mission would go through a handler, so there is none while no Boomerang is on. `fnc_updateListening` adds a `ProjectileCreated` mission event handler on each machine when the list of Boomerangs that are on gets its first vehicle, and removes it when the list is empty again. The server sends the list with the event `ewc_compat_cup_listChanged`. A player who joins late asks for it with `ewc_compat_cup_requestList`.
- The handler (`fnc_onFired`) only looks at local projectiles, so the shot is checked on the machine it comes from and never has to be sent to the server. The cheap checks come first, and the expensive ones only run for a shot that is really heard:
  - bullet or not, cached per ammo class
  - vehicle within 1000 m, bullet flying towards it, no report from the vehicle within the last second
  - a supersonic bullet (from 340 m/s) is heard if its path passes within the detection distance, a slower one only within 100 m
  - then the state of the vehicle (`fnc_isBoomerangReady`) and the shooter (`getShotParents`): not from inside the vehicle, and not friendly if friendly fire reports are off
- A report has a random bearing error of up to 2.5° and range error of up to 10 %, the accuracy in the data sheet of the vehicle system, and is limited to one per second and vehicle. It goes to all machines (`ewc_compat_cup_shotDetected`, `fnc_onShotDetected`): a silent hint for the crew and a local map marker for everybody friendly to the vehicle.
- The Boomerang listens (`fnc_isBoomerangReady`) while it is on, not above 97 km/h, and not deafened. A Fired event handler on a vehicle with a Boomerang tells the server (`fnc_handleVehicleFired`), which sets `ewc_compat_cup_deafUntil` for the lockout time. Smoke launchers and flares do not count.

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_initVehicle` | every machine | Class event handler for vehicles with an antenna: adds the actions, and on the server the jammer and the weapon watch |
| `fnc_getSources` | any | Animation sources of a vehicle that belong to a system |
| `fnc_isShown` | any | Is at least one antenna of a system shown |
| `fnc_canActivate` | any | Can a system be switched on (setting, alive, antenna, engine) |
| `fnc_canToggle` | clients | Condition of the switch actions: crew only, in the chosen interaction style |
| `fnc_addActions` | clients | Adds the scroll wheel actions |
| `fnc_addAceActions` | clients | Adds the ACE self-interaction actions |
| `fnc_handleToggle` | server | Checks a switch request and keeps DUKE and Boomerang exclusive |
| `fnc_registerJammer` | server | Registers the DUKE as a radio jammer in Crow's Electronic Warfare |
| `fnc_getRangeScale` | any | Share of the range from the antennas shown |
| `fnc_getRadius` | any | Full jamming radius: setting times range scale |
| `fnc_setJammer` | server | Switches the DUKE: state, radio jammer and mine jamming |
| `fnc_jamLoop` | server | Once per second while a DUKE is on: switches it off when it no longer works, keeps mines jammed |
| `fnc_updateMines` | server | Disables the IEDs in range and frees those that left |
| `fnc_releaseMines` | server | Enables mines a DUKE held again |
| `fnc_clearCrowsActions` | every machine | Removes only Crow's (de)activate actions from a jammer |
| `fnc_removeCrowsActions` | every machine | Calls `fnc_clearCrowsActions` for the DUKE vehicles on every `crowsEW_main_updateJammers` |
| `fnc_setBoomerang` | server | Switches the Boomerang and keeps the list of active ones |
| `fnc_boomerangLoop` | server | Once per second while a Boomerang is on: switches it off when it no longer works |
| `fnc_updateListening` | every machine | Adds or removes the projectile handler depending on that list |
| `fnc_handleVehicleFired` | server | Deafens the Boomerang after the vehicle's own fire |
| `fnc_isBoomerangReady` | any | Is the Boomerang listening (on, not deaf, not too fast) |
| `fnc_onFired` | machine of the shooter | Checks a projectile against the listening Boomerangs |
| `fnc_onShotDetected` | clients | Shows the hint and the map marker of a report |

## Settings

| Setting | Default | |
|---|---|---|
| DUKE switch | Scroll wheel | Scroll wheel, ACE self-interaction or both. Per client. Without ACE the scroll wheel is always used |
| Enable CUP DUKE | on | Set by the server |
| Enable CUP Boomerang | on | Set by the server |
| Jamming radius | 50 m | DUKE. Full jamming radius for radios and IEDs. The radio falloff band is 1.5 times that. Set by the server |
| Jam IEDs | on | DUKE. Set by the server |
| Require running engine | on | DUKE and Boomerang. Set by the server |
| Report friendly fire | on | Boomerang. Set by the server |
| Detection distance | 30 m | Boomerang, for supersonic bullets. Set by the server |
| Lockout after own fire | 5 s | Boomerang. Set by the server |
| Marker lifetime | 30 s | Boomerang. 0 turns the markers off. Per client |

A changed radius, or an antenna hidden or shown again on a vehicle with two, replaces the Crow's Electronic Warfare jammer, because it cannot change the radii of a jammer.

## Limitations

- The DUKE jams everybody in range, including the own crew and allies. Crow's Electronic Warfare has no immunity apart from Zeus.
- The DUKE only disables IEDs, not every mine.
- An IED that was triggered inside the range is expected to explode when it is freed, as with the Dingo CG13.
- Disabled IEDs are shared with the Dingo CG13. If both jam the same IED and one stops first, the IED is free for up to a second, until the other one disables it again.
- The systems are checked once per second, so a hidden antenna keeps working for up to a second.
- The Boomerang hears small arms only, no shells or missiles. The 1000 m limit, the 100 m muzzle blast range and the 340 m/s speed of sound are estimates, as the real system's range is not public.
- The DUKE needs Crow's Electronic Warfare, which only works in multiplayer.

## Dependencies

- [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728) (`crowsEW_main`)
- Optional: [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057) for the self-interaction

## Maintainer

- Andx
