# Compat Boomerang

Vehicles with a Boomerang shot finder get a switch for shot detection. A running Boomerang reports shots near the vehicle with a hint for the crew and a map marker for everybody friendly. Mods only model the antenna of the shot finder, so this addon provides the whole function for them. It is the common core of `compat_cup_boomerang` and `compat_rhs_usaf_boomerang`, which only register their vehicles, and does **not** need Crow's Electronic Warfare.

## How it works

- A vehicle counts as equipped if its `AnimationSources` contain one of the sources of the registry `CfgEWC >> Boomerangs` (`fnc_getSources`). A compat addon adds a class with `sources[]` (see `CfgEWC.hpp`) and its vehicles get the Boomerang without any code. The names are read once in `preInit`. Classes inherited from a parent are not listed as children, so every class up the inheritance chain is read and the result is cached per class. The antenna is shown at phase 0 and hidden at phase 1, mods hide it by default (`fnc_isShown`), so it has to be shown in the vehicle appearance options.
- Crew can switch the Boomerang with a scroll wheel action (`fnc_addActions`), an ACE self-interaction (`fnc_addAceActions`) or both (CBA setting `ewc_compat_boomerang_actionMode`). `fnc_canOperate` limits them to driver, commander and gunners, and `fnc_canToggle` adds the state of the system.
- `fnc_handleToggle` (server) checks a switch request and raises the local CBA event `ewc_compat_boomerang_switchedOn` with the vehicle before it switches, so a compat addon can switch off a system that excludes the Boomerang, like the DUKE of CUP (see `compat_cup_boomerang`).
- `fnc_setState` keeps a list of the vehicles with a Boomerang that is on (`ewc_compat_boomerang_vehicles`) and broadcasts it. A server side loop (`fnc_loop`) switches a Boomerang off when its vehicle is destroyed, its antenna is hidden, its engine stops or it is disabled.
- Every projectile of the mission would go through a handler, so there is none while no Boomerang is on. `fnc_updateListening` adds a `ProjectileCreated` mission event handler on each machine when the list of Boomerangs that are on gets its first vehicle, and removes it when the list is empty again. The server sends the list with the event `ewc_compat_boomerang_listChanged`. A player who joins late asks for it with `ewc_compat_boomerang_requestList`.
- The handler (`fnc_onFired`) only looks at local projectiles, so the shot is checked on the machine it comes from and never has to be sent to the server. The cheap checks come first, and the expensive ones only run for a shot that is really heard:
  - bullet or not, cached per ammo class
  - vehicle within 1000 m, bullet flying towards it, no report from the vehicle within the last second
  - a supersonic bullet (from 340 m/s) is heard if its path passes within `BOOMERANG_MISS_DISTANCE` (30 m), a slower one only within 100 m
  - then the state of the vehicle (`fnc_isReady`) and the shooter (`getShotParents`): not from inside the vehicle, and not friendly if friendly fire reports are off
- A report has a random bearing error of up to 2.5° and range error of up to 10 %, the accuracy in the data sheet of the vehicle system, and is limited to one per second and vehicle. It goes to all machines (`ewc_compat_boomerang_shotDetected`, `fnc_onShotDetected`): a silent hint for the crew and a local map marker for everybody friendly to the vehicle.
- A report close to the map marker of an earlier shot does not create one. `fnc_findNearMarker` looks for it in `ewc_compat_boomerang_shotMarkers` (name, position, expiry time of every marker that is still there): within `BOOMERANG_MARKER_MERGE_DISTANCE` (50 m) or twice the range error of the report (`2 * BOOMERANG_RANGE_ERROR * range`, 20 % of the range), whichever is larger. The expiry time of that marker moves to a full lifetime from now. A marker is removed by `fnc_expireShotMarker` at its expiry time, which schedules itself again for the time that is left when it was moved. Every client decides the same, as every client gets the same reports.
- With cTab loaded, the sub-addon in the folder `ctab` also shows a detected shot as a red marker on cTab, see its [README](ctab/README.md). The setting *Show shots* (nothing, map or cTab, the last only when cTab is loaded) is in this addon, `fnc_onShotDetected` adds the map marker when it is set to map and the sub-addon the cTab marker when it is set to cTab.
- The Boomerang listens (`fnc_isReady`) while it is on, not above 97 km/h, and not deafened. A Fired event handler on a vehicle with a Boomerang (`fnc_initVehicle`) tells the server (`fnc_handleVehicleFired`), which sets `ewc_compat_boomerang_deafUntil` for `BOOMERANG_LOCKOUT` (5 s). Smoke launchers and flares do not count. The first shot of a stretch of fire raises `ewc_compat_boomerang_deafChanged` (deaf), the end of the lockout raises it again (listening); bursts that only move the end do not.
- A change of the state shows a hint to the people in the vehicle (`ewc_main_fnc_notifyState` in `fnc_setState`). A Boomerang the loop switches off passes the reason of `fnc_getBlockReason`.

## Compat addons

| Addon | Mod | Vehicles and animation sources |
|---|---|---|
| [`compat_cup_boomerang`](../compat_cup_boomerang/README.md) | CUP Vehicles | HMMWV (M1151, M1240) and RG-31: `hide_antenna_boomerang`, `SYS_boomerang`. Also switches the DUKE off |
| [`compat_rhs_usaf_boomerang`](../compat_rhs_usaf_boomerang/README.md) | RHS USAF | M1245 SOCOM: `hide_boomerang` |

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_initVehicle` | every machine | Class event handler for vehicles with a Boomerang antenna: adds the actions and watches the weapons of the vehicle |
| `fnc_getSources` | any | Animation sources of a vehicle that belong to the shot finder |
| `fnc_isShown` | any | Is at least one antenna shown |
| `fnc_canOperate` | clients | May a unit operate the Boomerang: crew only, in the chosen interaction style |
| `fnc_canToggle` | clients | Condition of the switch actions: `fnc_canOperate` and the state of the system |
| `fnc_addActions` | clients | Adds the scroll wheel actions to a vehicle |
| `fnc_addAceActions` | clients | Adds the ACE self-interaction actions to land vehicles |
| `fnc_canActivate` | any | Can the Boomerang be switched on (setting, alive, antenna, engine) |
| `fnc_getBlockReason` | any | Why the Boomerang cannot be on (setting, destroyed, antenna, engine), or an empty text. `fnc_canActivate` is true when there is none |
| `fnc_handleToggle` | server | Checks a switch request and raises `ewc_compat_boomerang_switchedOn` |
| `fnc_setState` | server | Switches the Boomerang and keeps the list of active ones |
| `fnc_loop` | server | Once per second while a Boomerang is on: switches it off when it no longer works |
| `fnc_updateListening` | every machine | Adds or removes the projectile handler depending on that list |
| `fnc_handleVehicleFired` | server | Deafens the Boomerang after the vehicle's own fire and, for a Boomerang that is on, raises `ewc_compat_boomerang_deafChanged` when it goes deaf and when it listens again |
| `fnc_onDeafChanged` | clients | Shows the silent hint of that event to the crew |
| `fnc_isReady` | any | Is the Boomerang listening (on, not deaf, not too fast) |
| `fnc_onFired` | machine of the shooter | Checks a projectile against the listening Boomerangs |
| `fnc_onShotDetected` | clients | Shows the hint and the map marker of a report, or merges it into a marker that is still there |
| `fnc_findNearMarker` | clients | Index of the marker of an earlier shot a report is merged into, or -1 |
| `fnc_expireShotMarker` | clients | Removes a map marker at its expiry time, or waits for the time that is left |

## Settings

| Setting | Default | |
|---|---|---|
| Enable Boomerang | on | Set by the server |
| Report friendly fire | on | Set by the server |
| Marker lifetime | 30 s | 0 turns the markers off. Per client for the map, cTab markers use the value of the server |
| Show shots | Map | Nothing, map or cTab. cTab is only offered when it is loaded. Set by the server |
| Boomerang switch | Scroll wheel | Scroll wheel, ACE self-interaction or both. Per client. Without ACE the scroll wheel is always used |

## Limitations

- The detection distance (30 m, from the data sheet) and the lockout after own fire (5 s) are fixed values, not settings.
- The Boomerang hears small arms only, no shells or missiles. The 1000 m limit, the 100 m muzzle blast range and the 340 m/s speed of sound are estimates, as the real system's range is not public.
- The Boomerang is checked once per second, so a hidden antenna keeps working for up to a second.

## Dependencies

- None besides `ewc_main`. The vehicles come from the compat addons `compat_cup_boomerang` and `compat_rhs_usaf_boomerang`.
- Optional: [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) for the sub-addon `ctab`

## Maintainer

- Andx
