# Compat CUP

Vehicles with a **DUKE antenna** (HMMWV, MATV, M1A1/M1A2 Abrams, RG-31 and other vehicles with the same antenna) get a DUKE switch. A running DUKE jams ACRE radios and IEDs around the vehicle.

CUP only has the DUKE as a model without function, so unlike the RHS and BWmod addons this one provides the jamming itself.

## Using it

- The vehicle needs a **shown DUKE antenna**. CUP lets you hide it in the vehicle appearance options, and then the DUKE is not available.
- Crew switch the DUKE with the **scroll wheel** (*Activate DUKE* / *Deactivate DUKE*), the **ACE self-interaction** menu, or both. Choose in the CBA settings.
- The DUKE needs the **engine running** and switches off when the engine stops, the antenna is hidden or the vehicle is destroyed.

## Range

| | Effective | Falloff band | Outer edge |
|---|---|---|---|
| Radio jammer | **50 m** | 75 m | **125 m** |
| IED jamming | **50 m** | none | **50 m** |

The radius is a setting. 50 m is what the RHS DUKE uses, the Dingo CG13 uses 40 m. The falloff band of the radio jammer is 1.5 times the effective radius. IEDs in range are disabled and enabled again when they leave the range or the DUKE stops.

## Settings

| Setting | Default | |
|---|---|---|
| DUKE switch | Scroll wheel | Scroll wheel, ACE self-interaction or both. Without ACE the scroll wheel is always used |
| Jamming radius | 50 m | For radios and IEDs. Set by the server |
| Jam IEDs | on | Set by the server |
| Require running engine | on | Set by the server |

## Quirks

- **Crow's own actions are hidden.** Its (de)activate actions would desync from the DUKE, so only the DUKE switch is offered.
- **Everybody in range is jammed**, including the own crew and allies.
- **Only IEDs are disabled**, not every mine.
- **Up to a second of delay** when the antenna is hidden or the engine stops, because the DUKE is checked once per second.
- **Multiplayer only.**

## Dependencies

- [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728)
- Optional: [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057)
