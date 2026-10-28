# Compat CUP

CUP models two systems on some of its vehicles but gives them no function: the **DUKE** antenna and the **Boomerang** shot finder. This addon makes both work.

- **DUKE**: a running DUKE jams ACRE radios and IEDs around the vehicle.
- **Boomerang**: a running Boomerang detects shots near the vehicle and reports where they came from.

A vehicle can only run one of them. Switching one on switches the other off.

Both systems are switched on with the **scroll wheel**, the **ACE self-interaction** menu, or both. Choose in the CBA settings. They need a **shown antenna** and the **engine running**. CUP lets you hide the antennas in the vehicle appearance options, and then the system is not available.

## DUKE

Vehicles with a DUKE antenna (HMMWV, MATV, M1A1/M1A2 Abrams, RG-31 and other vehicles with the same antenna) get *Activate DUKE* / *Deactivate DUKE*. CUP only has the DUKE as a model without function, so unlike the RHS and BWmod addons this one provides the jamming itself.

The DUKE switches off when the engine stops, the antenna is hidden or the vehicle is destroyed.

### Range

| State | Radio effective | Radio falloff band | Radio outer edge | IEDs |
|---|---|---|---|---|
| All antennas shown | **50 m** | 75 m | **125 m** | within **50 m** |
| One of two antennas shown | **30 m** (60 %) | 45 m | **75 m** | within **30 m** |
| No antenna shown | off | off | off | off |

The radius is a setting, the values above use the default. 50 m is what the RHS DUKE uses, the Dingo CG13 uses 40 m. The falloff band of the radio jammer is 1.5 times the effective radius. IEDs in range are disabled and enabled again when they leave the range or the DUKE stops.

Most vehicles have one DUKE antenna and are either on full range or off. The M1240 family (Hunter, M1245 and others) has a DUKE and a CREW DUKE antenna. With only one shown it has 60 % of the range, as the RHS DUKE has with a destroyed antenna. The unarmed Hunter (`CUP_M1245_Unarmed_*`) and the ION M1240 start with the CREW DUKE hidden, so they start at 60 %. Show it in the vehicle appearance options for the full range.

## Boomerang

Vehicles with a Boomerang shot finder (HMMWV, MATV and RG-31 families) get *Activate Boomerang* / *Deactivate Boomerang*. The real system is a passive acoustic sensor that locates the shooter from the shockwave and muzzle blast of a shot. It is hidden by default on these vehicles.

An active Boomerang reports bullets that are fired nearby:

- The **crew** gets a hint with one line per information (shot detected, 3 o'clock, ~300 m, bearing 87°, level). It makes no sound.
- Everybody **friendly to the vehicle** gets a red map marker at the estimated position of the shooter. It disappears after 30 seconds. The marker is local, the enemy does not see it.
- Reports are not exact, like the real system: the bearing is off by up to 7.5° and the range by up to 20 %.
- A burst is reported once per second, not bullet by bullet.

### What it hears

- A **supersonic** bullet is heard if it passes within the detection distance of the vehicle (50 m by default), up to 1000 m from the shooter.
- A **slower** bullet is only heard as muzzle blast, within 100 m.
- Only small arms are heard, no shells or missiles.
- The shots of friendly units are reported too, like the real system does. A setting turns this off.
- Shots from inside the vehicle are not reported.

### Limitations

- It is **deaf for 5 seconds** after the weapons of its own vehicle were fired. Smoke launchers and flares do not count. The time is a setting.
- It **does not work above 95 km/h**, the speed the real system is specified for. It listens again when the vehicle is slower.
- It switches off when the engine stops, the antenna is hidden or the vehicle is destroyed.

## Settings

| Setting | Default | |
|---|---|---|
| DUKE switch | Scroll wheel | Scroll wheel, ACE self-interaction or both. Without ACE the scroll wheel is always used. Per player |
| Enable CUP DUKE | on | If off, no DUKE switch and running DUKEs switch off. Set by the server |
| Enable CUP Boomerang | on | If off, no Boomerang switch and active Boomerangs switch off. Set by the server |
| Jamming radius | 50 m | DUKE, for radios and IEDs. Set by the server |
| Jam IEDs | on | DUKE. Set by the server |
| Require running engine | on | For DUKE and Boomerang. Set by the server |
| Report friendly fire | on | Boomerang. Set by the server |
| Detection distance | 50 m | Boomerang, for supersonic bullets. Set by the server |
| Lockout after own fire | 5 s | Boomerang. Set by the server |
| Marker lifetime | 30 s | Boomerang. 0 turns the markers off. Per player |

## Quirks

- **Crow's own actions are hidden** on DUKE vehicles. Its (de)activate actions would desync from the DUKE, so only the DUKE switch is offered.
- **Everybody in range is jammed** by the DUKE, including the own crew and allies.
- **The DUKE only disables IEDs**, not every mine.
- **Up to a second of delay** when an antenna is hidden or the engine stops, because the systems are checked once per second.
- **Crow's Electronic Warfare is required** for the addon to load, Boomerang included. Only the DUKE needs multiplayer, as Crow's Electronic Warfare does. The Boomerang does not use it.

## Dependencies

- [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728)
- Optional: [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057)
