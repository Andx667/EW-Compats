# Compat CUP Drones

The CUP **MQ-9 Reaper** and **Pchela-1T** can be jammed by the drone jammers of Crow's Electronic Warfare and appear on its spectrum device. Without this addon they are never jammed: Crow's Electronic Warfare gives a signal only to the drones it lists, and the CUP drones are not among them.

With a drone jammer such as the [RHS AFRF R-142N](compat-rhs-afrf.md) switched on, a CUP drone inside the radius loses its link: a player flying it is disconnected, and the AI of a drone without a pilot is switched off. Within the falloff band the video of a pilot is distorted.

## Settings

### `ewc_compat_cup_drones_enable`

- Name: Enable CUP drone signals
- Type: `CHECKBOX`
- Default: `true`
- Set by: the server
- Purpose: if off, the CUP drones get no signal and cannot be jammed. Applied to drones when they are created.

### `ewc_compat_cup_drones_range`

- Name: Drone signal range
- Type: `SLIDER`
- Range: `300` to `10000` m
- Default: `3000`
- Set by: the server
- Purpose: range of the spectrum signal of a CUP drone. 3000 m is the default of Crow's Electronic Warfare for its own drones. Applied to drones when they are created.

## Quirks

- **A drone keeps its signal** until the mission restarts, when a setting is changed during the mission.
- **The frequency is random**, in the drone band of the spectrum device.
- **Multiplayer only.** Crow's Electronic Warfare does not work in singleplayer.

## How it works

Crow's Electronic Warfare jams only the drones that have a spectrum signal of the type `drone`. Its default list of classes holds the vanilla drone bases, and the CUP drones derive from the plain `UAV` class. The addon adds the signal to both CUP drone bases when a drone is created, through the `crowsEW_spectrum_addBeacon` event. A drone that already has a signal, for example because the CUP classes were added to the Crow's Electronic Warfare setting, is left alone.

## Dependencies

- [Compat CUP](compat-cup.md) with [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728)
