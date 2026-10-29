# Compat CUP Boomerang

Vehicles with a Boomerang shot finder get a switch for shot detection. A running Boomerang reports shots near the vehicle with a hint for the crew and a map marker for everybody friendly. CUP only models the antenna, so this addon provides the whole function. It builds on `compat_cup` and does **not** need Crow's Electronic Warfare.

## How it works

- `fnc_setState` keeps a list of the vehicles with a Boomerang that is on (`ewc_compat_cup_boomerang_vehicles`) and broadcasts it. A server side loop (`fnc_loop`) switches a Boomerang off when its vehicle is destroyed, its antenna is hidden, its engine stops or it is disabled.
- Every projectile of the mission would go through a handler, so there is none while no Boomerang is on. `fnc_updateListening` adds a `ProjectileCreated` mission event handler on each machine when the list of Boomerangs that are on gets its first vehicle, and removes it when the list is empty again. The server sends the list with the event `ewc_compat_cup_boomerang_listChanged`. A player who joins late asks for it with `ewc_compat_cup_boomerang_requestList`.
- The handler (`fnc_onFired`) only looks at local projectiles, so the shot is checked on the machine it comes from and never has to be sent to the server. The cheap checks come first, and the expensive ones only run for a shot that is really heard:
  - bullet or not, cached per ammo class
  - vehicle within 1000 m, bullet flying towards it, no report from the vehicle within the last second
  - a supersonic bullet (from 340 m/s) is heard if its path passes within the detection distance, a slower one only within 100 m
  - then the state of the vehicle (`fnc_isReady`) and the shooter (`getShotParents`): not from inside the vehicle, and not friendly if friendly fire reports are off
- A report has a random bearing error of up to 2.5° and range error of up to 10 %, the accuracy in the data sheet of the vehicle system, and is limited to one per second and vehicle. It goes to all machines (`ewc_compat_cup_boomerang_shotDetected`, `fnc_onShotDetected`): a silent hint for the crew and a local map marker for everybody friendly to the vehicle.
- A report close to the map marker of an earlier shot does not create one. `fnc_findNearMarker` looks for it in `ewc_compat_cup_boomerang_shotMarkers` (name, position, expiry time of every marker that is still there): within `BOOMERANG_MARKER_MERGE_DISTANCE` (50 m) or twice the range error of the report (`2 * BOOMERANG_RANGE_ERROR * range`, 20 % of the range), whichever is larger. The expiry time of that marker moves to a full lifetime from now. A marker is removed by `fnc_expireShotMarker` at its expiry time, which schedules itself again for the time that is left when it was moved. Every client decides the same, as every client gets the same reports.
- With cTab loaded, the sub-addon in the folder `ctab` also shows a detected shot as a red marker on cTab, see its [README](ctab/README.md). It adds the setting *Show shots on* (map, cTab or both), which `fnc_onShotDetected` reads to leave out the map marker when it is set to cTab only.
- The Boomerang listens (`fnc_isReady`) while it is on, not above 97 km/h, and not deafened. A Fired event handler on a vehicle with a Boomerang (`fnc_initVehicle`) tells the server (`fnc_handleVehicleFired`), which sets `ewc_compat_cup_boomerang_deafUntil` for the lockout time. Smoke launchers and flares do not count.
- A change of the state shows a hint to the people in the vehicle (`ewc_main_fnc_notifyState` in `fnc_setState`). A Boomerang the loop switches off passes the reason of `fnc_getBlockReason`.
- The DUKE and the Boomerang exclude each other, see `compat_cup`. The Boomerang listens to `ewc_compat_cup_systemOn` and switches off when the DUKE is switched on.

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_initVehicle` | every machine | Class event handler for vehicles with a Boomerang antenna: adds the actions and watches the weapons of the vehicle |
| `fnc_canActivate` | any | Can the Boomerang be switched on (setting, alive, antenna, engine) |
| `fnc_getBlockReason` | any | Why the Boomerang cannot be on (setting, destroyed, antenna, engine), or an empty text. `fnc_canActivate` is true when there is none |
| `fnc_handleToggle` | server | Checks a switch request and tells the DUKE to switch off |
| `fnc_setState` | server | Switches the Boomerang and keeps the list of active ones |
| `fnc_loop` | server | Once per second while a Boomerang is on: switches it off when it no longer works |
| `fnc_updateListening` | every machine | Adds or removes the projectile handler depending on that list |
| `fnc_handleVehicleFired` | server | Deafens the Boomerang after the vehicle's own fire |
| `fnc_isReady` | any | Is the Boomerang listening (on, not deaf, not too fast) |
| `fnc_onFired` | machine of the shooter | Checks a projectile against the listening Boomerangs |
| `fnc_onShotDetected` | clients | Shows the hint and the map marker of a report, or merges it into a marker that is still there |
| `fnc_findNearMarker` | clients | Index of the marker of an earlier shot a report is merged into, or -1 |
| `fnc_expireShotMarker` | clients | Removes a map marker at its expiry time, or waits for the time that is left |

## Settings

| Setting | Default | |
|---|---|---|
| Enable CUP Boomerang | on | Set by the server |
| Report friendly fire | on | Set by the server |
| Detection distance | 30 m | For supersonic bullets. Set by the server |
| Lockout after own fire | 5 s | Set by the server |
| Marker lifetime | 30 s | 0 turns the markers off. Per client for the map, cTab markers use the value of the server |
| Show shots on | Map and cTab | Map, cTab or both. Only there when cTab is loaded, by the sub-addon `ctab`. Set by the server |

The switch and the engine requirement are settings of `compat_cup`.

## Limitations

- The Boomerang hears small arms only, no shells or missiles. The 1000 m limit, the 100 m muzzle blast range and the 340 m/s speed of sound are estimates, as the real system's range is not public.
- The Boomerang is checked once per second, so a hidden antenna keeps working for up to a second.

## Dependencies

- `compat_cup` and [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- Optional: [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) for the sub-addon `ctab`

## Maintainer

- Andx
