# Compat CUP Drones

The CUP **MQ-9 Reaper** and **Pchela-1T** get the spectrum signal that Crow's Electronic Warfare gives its own drones. Only a drone with this signal can be jammed by a drone jammer (`DroneJammer`), such as the R-142N of `compat_rhs_afrf`, and shows up on the spectrum device. It is a sub-addon of `compat_cup` (folder `compat_cup_drones`, with a `config.cpp` of its own, only loaded with Crow's Electronic Warfare and the CUP drones). Its function is named `ewc_compat_cup_fnc_drones_initVehicle`.

## How it works

- Crow's Electronic Warfare lists the classes that get a signal in the setting `crowsEW_spectrum_defaultClassForJammingSignal`: the vanilla drone bases (`UAV_01_base_F` to `UAV_06_base_F`, `UGV_01_base_F`, `UGV_02_Base_F` and others) and some drone mods. The two CUP drones derive from the plain `UAV` class (`CUP_MQ9_Base`, `CUP_Pchela1T_Base`), so they are not in it. The Pchela-1T of RHS AFRF derives from `UAV_02_base_F` and needs nothing.
- The jamming of Crow's Electronic Warfare looks for the beacons of the type `drone` only: the server loop that jams drones without a pilot (`fnc_jammerServerLoop`) and the check for the drone a player is connected to (`fnc_jammerPlayerLocal`). A drone without a beacon is not jammed at all.
- A class event handler on both bases (`Extended_InitPost_EventHandlers`, with inheritance, so the variants such as the dynamic loadout MQ-9 are included) calls `fnc_initVehicle` on the server. It waits for `CBA_missionTime > 0`, because editor-placed drones initialise before Crow's Electronic Warfare has registered its handlers. Then it raises the server event `crowsEW_spectrum_addBeacon` with a random frequency in the drone band (starting at 433 MHz, like Crow's Electronic Warfare does), the range of the setting and the type `drone`.
- A drone that has a signal already is left alone, for example when the CUP classes were added to the Crow's Electronic Warfare setting by hand. The order does not matter, `crowsEW_spectrum_fnc_initDroneSignals` skips a drone with a beacon as well.

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_initVehicle` | server | Class event handler of the CUP drones: adds the spectrum signal of a jammable drone once Crow's Electronic Warfare is ready |

## Settings

| Setting | Default | |
|---|---|---|
| Enable CUP drone signals | on | If off, the CUP drones get no signal. Set by the server, applied to drones when they are created |
| Drone signal range (m) | 3000 | Range of the signal, 300 to 10000 m. The default of Crow's Electronic Warfare for its own drones is 3000 m. Applied to drones when they are created |

## Limitations

- The settings apply to drones created afterwards. A drone that already has its signal keeps it until the mission restarts.
- The frequency is random and not coordinated with other signals, as in Crow's Electronic Warfare.
- Only the two drones above are covered. I did not check CUP for other drones.
- Crow's Electronic Warfare only works in multiplayer.

## Dependencies

- [Compat CUP](../README.md) with [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371) (`CUP_AirVehicles_MQ9`, `CUP_AirVehicles_Pchela1T`)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728) (`crowsEW_spectrum`)

## Maintainer

- Andx
