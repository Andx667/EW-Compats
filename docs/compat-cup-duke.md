# Compat CUP DUKE

Vehicles with a shown **DUKE** antenna (HMMWV, MATV, M1A1/M1A2 Abrams, RG-31 and other vehicles with the same antenna) get a DUKE switch. A running DUKE jams ACRE radios and IEDs around the vehicle. CUP only has the DUKE as a model without function, so this addon provides the jamming itself, unlike the RHS USAF DUKE and the Dingo CG13, which already jam IEDs.

!!! note "Gameplay values"
    The real DUKE (AN/VLQ-12 CREW Duke) is a vehicle-mounted counter-RCIED jammer. Its frequency bands and jamming range are not publicly documented in detail, so the radii here are gameplay values. The DUKE jammer is modelled as simply on or off and jams continuously in its radius while on.

## Controls

*Activate DUKE* / *Deactivate DUKE* with the scroll wheel or the ACE self-interaction, see [Compat CUP](compat-cup.md#controls). The DUKE switches off when the engine stops, the antenna is hidden or the vehicle is destroyed.

Every change of state shows a silent hint to everybody in the vehicle, for example *DUKE on* or *DUKE off: engine stopped*. The reason is *engine stopped*, *antenna hidden* or *disabled in the settings*.

## Range

| State | Radio effective | Radio falloff band | Radio outer edge | IEDs |
|---|---|---|---|---|
| All antennas shown | **50 m** | 75 m | **125 m** | within **50 m** |
| One of two antennas shown | **30 m** (60 %) | 45 m | **75 m** | within **30 m** |
| No antenna shown | off | off | off | off |

The radius is a setting, the values above use the default. 50 m is what the RHS DUKE uses, the Dingo CG13 uses 40 m. The falloff band of the radio jammer is 1.5 times the effective radius.

Most vehicles have one DUKE antenna and are either on full range or off. The M1240 family (Hunter, M1245 and others) has a DUKE and a CREW DUKE antenna. With only one shown it has 60 % of the range, as the RHS DUKE has with a destroyed antenna. The unarmed Hunter (`CUP_M1245_Unarmed_*`) and the ION M1240 start with the CREW DUKE hidden, so they start at 60 %. Show it in the vehicle appearance options for the full range.

## Settings

| Setting | Default | |
|---|---|---|
| Enable CUP DUKE | on | If off, no DUKE switch and running DUKEs switch off. Set by the server |
| Jamming radius | 50 m | For radios and IEDs. Set by the server |
| Jam IEDs | on | Set by the server |

The switch and the engine requirement are settings of `compat_cup`, see [Compat CUP](compat-cup.md#settings).

## Quirks

- **Crow's own actions are hidden** on DUKE vehicles. Its (de)activate actions would desync from the DUKE, so only the DUKE switch is offered.
- **Everybody in range is jammed**, including the own crew and allies.
- **Which IEDs are jammed.** The vanilla and ACE IEDs and the IEDs of CUP (`CUP_IED_V1_Ammo` to `V4`). Mines, including the anti-tank mines of CUP, are not jammed.
- **A jammed IED is held, not defused.** IEDs in range are frozen (their simulation is switched off) and released when they leave the range or the DUKE stops, the same way as the Dingo CG13 of [Compat BWA3](compat-bwa3.md). An IED that was triggered inside the range is expected to explode on release, as it does with the CG13 and the RHS DUKE. Keep the distance until the IED is cleared.
- **Several jammers can hold the same IED** when the DUKE is loaded together with the Dingo CG13 or the RHS DUKE. If two of them jam the same IED and one stops first, the IED is free for up to a second until the other one disables it again.
- **Up to a second of delay** when an antenna is hidden or the engine stops, because the DUKE is checked once per second.
- **Multiplayer only.** Crow's Electronic Warfare does not work in singleplayer.

## How it works

The server registers every DUKE vehicle as a disabled radio jammer (`VoiceCommsJammer`) in Crow's Electronic Warfare and switches it with the DUKE; the jamming itself (ACRE interference, Spectrum Device signal, cleanup on destruction) is done by Crow's Electronic Warfare. A changed radius, or an antenna hidden or shown again on a vehicle with two, replaces the jammer, because Crow's Electronic Warfare cannot change the radii of a jammer. IEDs are frozen by the addon, once per second while the DUKE is on.

## Dependencies

- [Compat CUP](compat-cup.md) with [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728)
