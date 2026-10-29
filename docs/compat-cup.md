# Compat CUP

CUP models two systems on some of its vehicles but gives them no function: the **DUKE** antenna and the **Boomerang** shot finder. This addon makes both work. It is split in two parts that can be used alone:

| Addon | What it does | Needs Crow's Electronic Warfare |
|---|---|---|
| [Compat CUP DUKE](compat-cup-duke.md) | A running DUKE jams ACRE radios and IEDs around the vehicle | yes |
| [Compat CUP Boomerang](compat-cup-boomerang.md) | A running Boomerang detects shots near the vehicle and reports where they came from | no |

Both parts build on the shared addon `compat_cup`, which finds the vehicles with an antenna and provides the switches and the settings below. It is loaded with either part.

## Controls

Both systems are switched on with the **scroll wheel**, the **ACE self-interaction** menu, or both. Choose in the CBA settings. Only the **driver, commander and gunners** get the switch, passengers do not. They need a **shown antenna** and the **engine running**. CUP lets you hide the antennas in the vehicle appearance options, and then the system is not available.

A vehicle can only run one of them. Switching one on switches the other off.

## Settings

| Setting | Default | |
|---|---|---|
| DUKE switch | Scroll wheel | Scroll wheel, ACE self-interaction or both. Without ACE the scroll wheel is always used. Per player |
| Require running engine | on | For DUKE and Boomerang. Set by the server |

The settings of each system are on its page.

## Quirks

- **Up to a second of delay** when an antenna is hidden or the engine stops, because the systems are checked once per second.
- **The antennas are found by their animation sources**, so a vehicle without them has no switch.

## How it works

CUP only models the antennas as animation sources, so the addons provide the whole function. The shared addon reads the sources of a vehicle class once and keeps the result, adds the switches and checks who may use them. Each system addon reports its state in a public variable (`ewc_compat_cup_duke_on`, `ewc_compat_cup_boomerang_on`), handles the switch request on the server, and tells the other system to switch off when it is switched on.

## Dependencies

- [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- Optional: [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057)
