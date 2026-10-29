# Compat CUP

CUP models two systems on some of its vehicles but gives them no function: the **DUKE** antenna and the **Boomerang** shot finder. This addon makes both work. The DUKE is built on the shared base `compat_cup`, the Boomerang is the common [Compat Boomerang](compat-boomerang.md) with the CUP vehicles registered by `compat_cup_boomerang`:

| Addon | What it does | Needs Crow's Electronic Warfare |
|---|---|---|
| [Compat CUP DUKE](compat-cup-duke.md) | A running DUKE jams ACRE radios and IEDs around the vehicle | yes |
| [Compat Boomerang](compat-boomerang.md) | A running Boomerang detects shots near the vehicle and reports where they came from | no |

The DUKE builds on the shared addon `compat_cup`, which finds the vehicles with an antenna and provides the switch and the settings below.

## Controls

The DUKE is switched on with the **scroll wheel**, the **ACE self-interaction** menu, or both. Choose in the CBA settings. The Boomerang has its own switch, see [Compat Boomerang](compat-boomerang.md#controls). Only the **driver, commander and gunners** get the switch, passengers do not. It needs a **shown antenna** and the **engine running**. CUP lets you hide the antennas in the vehicle appearance options, and then the system is not available.

By default a vehicle can only run the DUKE or the Boomerang. Switching one on switches the other off. The setting *Allow DUKE and Boomerang together* lifts that, and then both run independently.

## Settings

| Setting | Default | |
|---|---|---|
| DUKE switch | Scroll wheel | Scroll wheel, ACE self-interaction or both. Without ACE the scroll wheel is always used. Per player |
| Allow DUKE and Boomerang together | off | Set by the server. Off: switching one system on switches the other off |

The settings of the DUKE are on its page.

## Quirks

- **Up to a second of delay** when an antenna is hidden or the engine stops, because the systems are checked once per second.
- **The antennas are found by their animation sources**, so a vehicle without them has no switch.

## How it works

CUP only models the antennas as animation sources, so the addons provide the whole function. The shared addon reads the sources of a vehicle class once and keeps the result, adds the switch of the DUKE and checks who may use it. The DUKE reports its state in a public variable (`ewc_compat_cup_duke_on`), handles the switch request on the server, and tells the Boomerang to switch off when it is switched on. `compat_cup_boomerang` passes this on to [Compat Boomerang](compat-boomerang.md) and the other way round.

## Dependencies

- [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- Optional: [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057)
