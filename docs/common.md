# Common

Shared code of the compat addons. Most of it is code for the other addons, the one thing you can change is how the crew switches the systems of a vehicle on and off.

## Settings

### `ewc_common_actionMode`

- Name: System switch
- Type: `LIST`
- Values: `0` scroll wheel, `1` ACE self-interaction, `2` both
- Default: `0`
- Set by: each player (client setting)
- Purpose: how the crew switches the systems of a vehicle: the CUP DUKE, the Boomerang and the Redd'n'Tank Fuchs Hummel. Without ACE the scroll wheel is always used.

### Complete example

``` cpp
// cba_settings.sqf
ewc_common_actionMode = 2; // default: 0
```

!!! note "Renamed"
    This setting was `ewc_boomerang_actionMode` and `ewc_compat_cup_actionMode` before. Both are gone, set `ewc_common_actionMode` instead.

## How it works

`ewc_common` has a registry of jammer vehicles: an addon names the config entry that marks its vehicles, and the vehicle is registered once as a disabled jammer in Crow's Electronic Warfare. It also has the switch actions (scroll wheel and ACE self-interaction, limited to driver, commander and gunners) that the DUKE, the Boomerang and the Hummel share, the hint that tells a crew about the state of a system, and a function that brings a jammer in line with a wanted state, replacing it when the radius changes because Crow's Electronic Warfare cannot change radii.

## Dependencies

- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728) for the jammer functions
