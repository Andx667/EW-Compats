# Compat CUP

CUP models two systems on some of its vehicles but gives them no function: the **DUKE** antenna and the **Boomerang** shot finder. This addon makes both work.

- **DUKE**: a running DUKE jams ACRE radios and IEDs around the vehicle.
- **Boomerang**: a running Boomerang detects shots near the vehicle and reports where they came from.

A vehicle can only run one of them. Switching one on switches the other off.

!!! note "Gameplay values"
    The real DUKE (AN/VLQ-12 CREW Duke) is a vehicle-mounted counter-RCIED jammer. Its frequency bands and jamming range are not publicly documented in detail, so the radii here are gameplay values. The DUKE jammer is modelled as simply on or off and jams continuously in its radius while on.

!!! note "Real system"
    The real Boomerang is the Raytheon BBN shooter detection system, a mast with a microphone array that uses the muzzle blast and the shockwave of supersonic bullets. Its data sheet gives a bearing error under 2.5°, a range error of ±10 %, detection of bullets that pass within about 30 m of the mast, operation up to 60 mph, and no alert for shots from the own vehicle. The addon uses these figures. The dismounted Boomerang Warrior is less accurate (7.5° and ±20 %), these are not used. The elevation threshold, the 1000 m limit and the 100 m for subsonic bullets are gameplay values, the sources do not give them.

## Controls

Both systems are switched on with the **scroll wheel**, the **ACE self-interaction** menu, or both. Choose in the CBA settings. Only the **driver, commander and gunners** get the switch, passengers do not. They need a **shown antenna** and the **engine running**. CUP lets you hide the antennas in the vehicle appearance options, and then the system is not available.

- **DUKE**: vehicles with a DUKE antenna (HMMWV, MATV, M1A1/M1A2 Abrams, RG-31 and other vehicles with the same antenna) get *Activate DUKE* / *Deactivate DUKE*. It switches off when the engine stops, the antenna is hidden or the vehicle is destroyed.
- **Boomerang**: vehicles with a Boomerang shot finder (HMMWV, MATV and RG-31 families) get *Activate Boomerang* / *Deactivate Boomerang*. It is hidden by default on these vehicles and switches off for the same reasons.

## Range

### DUKE

| State | Radio effective | Radio falloff band | Radio outer edge | IEDs |
|---|---|---|---|---|
| All antennas shown | **50 m** | 75 m | **125 m** | within **50 m** |
| One of two antennas shown | **30 m** (60 %) | 45 m | **75 m** | within **30 m** |
| No antenna shown | off | off | off | off |

The radius is a setting, the values above use the default. 50 m is what the RHS DUKE uses, the Dingo CG13 uses 40 m. The falloff band of the radio jammer is 1.5 times the effective radius.

Most vehicles have one DUKE antenna and are either on full range or off. The M1240 family (Hunter, M1245 and others) has a DUKE and a CREW DUKE antenna. With only one shown it has 60 % of the range, as the RHS DUKE has with a destroyed antenna. The unarmed Hunter (`CUP_M1245_Unarmed_*`) and the ION M1240 start with the CREW DUKE hidden, so they start at 60 %. Show it in the vehicle appearance options for the full range.

### Boomerang

| Shot | Heard |
|---|---|
| Supersonic bullet | Within the detection distance of the vehicle (**30 m** by default), up to **1000 m** from the shooter |
| Slower bullet | Only as muzzle blast, within **100 m** |
| Shells, missiles | Not heard, only small arms |
| Shots from inside the vehicle | Not reported |

The shots of friendly units are reported too, like the real system does. A setting turns this off.

An active Boomerang reports a heard bullet:

- The **crew** gets a hint with one line per information (shot detected, 3 o'clock, ~300 m, bearing 87°, level). It makes no sound.
- Everybody **friendly to the vehicle** gets a red marker at the estimated position of the shooter, on the map, on cTab or both (setting *Show shots on*). It disappears after 30 seconds. The map marker is local, the enemy does not see it. On cTab it is a red enemy marker of the side of the vehicle, so everybody with that side's cTab sees it, with the usual cTab notification. This needs [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217), without it the map is used.
- Reports are not exact, like the real system: the bearing is off by up to 2.5° and the range by up to 10 %.
- A burst is reported once per second, not bullet by bullet.

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
| Detection distance | 30 m | Boomerang, for supersonic bullets. Set by the server |
| Lockout after own fire | 5 s | Boomerang. Set by the server |
| Marker lifetime | 30 s | Boomerang. 0 turns the markers off. Per player for the map, cTab markers use the value of the server |
| Show shots on | Map and cTab | Boomerang. Map, cTab or both. Only there when cTab is loaded. Set by the server |

## Quirks

- **Crow's own actions are hidden** on DUKE vehicles. Its (de)activate actions would desync from the DUKE, so only the DUKE switch is offered.
- **Everybody in range is jammed** by the DUKE, including the own crew and allies.
- **The DUKE only disables IEDs**, not every mine.
- **A jammed IED is held, not defused.** IEDs in range are frozen (their simulation is switched off) and released when they leave the range or the DUKE stops, the same way as the Dingo CG13 of [Compat BWA3](compat-bwa3.md). An IED that was triggered inside the range is expected to explode on release, as it does with the CG13. Keep the distance until the IED is cleared.
- **Boomerang is deaf for 5 seconds** after the weapons of its own vehicle were fired. Smoke launchers and flares do not count. The time is a setting.
- **Boomerang does not work above 97 km/h** (60 mph), the speed the real system is specified for. It listens again when the vehicle is slower.
- **Up to a second of delay** when an antenna is hidden or the engine stops, because the systems are checked once per second.
- **Crow's Electronic Warfare is required** for the addon to load, Boomerang included. Only the DUKE needs multiplayer, as Crow's Electronic Warfare does. The Boomerang does not use it.

## How it works

CUP only models the antennas as animation sources, so this addon provides the whole function. A vehicle counts as equipped if it has one of these sources. The server registers every DUKE vehicle as a disabled radio jammer (`VoiceCommsJammer`) in Crow's Electronic Warfare and switches it with the DUKE; the jamming itself is done by Crow's Electronic Warfare. IEDs are frozen by the addon. The Boomerang does not use Crow's Electronic Warfare. Each machine checks the bullets it fires against the active Boomerangs and sends a report only for a shot that is heard.

## Dependencies

- [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728)
- Optional: [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057)
