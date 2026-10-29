# Compat RHS USAF

Vehicles with a **DUKE** (M1117, HMMWV family, MATV, M1A1/M1A2 and others) also jam ACRE radios, in addition to IEDs. The radio jammer follows the DUKE switch of RHS.

!!! note "Gameplay values"
    The real DUKE (AN/VLQ-12 CREW Duke) is a vehicle-mounted counter-RCIED jammer. Its frequency bands and jamming range are not publicly documented in detail, so the radii here are gameplay values. The jammer is modelled as simply on or off and jams continuously in its radius while on.

## Controls

Switch the DUKE with its weapon `rhsusf_weap_duke`, as in RHS. The radio jammer follows it.

Every change of state shows a silent hint to everybody in the vehicle, for example *DUKE on* or *DUKE off: engine stopped*. The reason is given when the DUKE switches itself off because both antennas were destroyed or the DUKE was disabled in the settings.

## Range

| State | Effective | Falloff band | Outer edge |
|---|---|---|---|
| Both antennas intact | **50 m** | 75 m | **125 m** |
| One antenna destroyed | **30 m** (60 %) | 45 m | **75 m** |
| Both antennas destroyed | off | off | off |
| DUKE switched off | off | off | off |

The 50 m is the IED jammer radius hardcoded in RHS. The falloff band is 1.5 times the effective radius. The 60 % for one antenna matches `rhs_duke.sqf`.

## Settings

| Setting | Default | |
|---|---|---|
| Enable RHS DUKE jamming | on | If off, the DUKEs do not jam radios. Set by the server |

## Quirks

- **Operated through the weapon.** RHS toggles the DUKE with a pseudo weapon (`rhsusf_weap_duke`). The addon reads the result 0.5 s after the shot, because RHS only sets `RHS_DUKE_OP` in a spawned script.
- **A destroyed antenna changes the range.** Crow's Electronic Warfare cannot change the radii of a jammer, so the jammer is removed and registered again with the new range. Hits within the delay are merged into one sync.
- **Locality matters.** RHS only starts its jamming script if gunner and vehicle are local on the same machine, for example not for a gunner in the turret of someone else's vehicle. Then `RHS_DUKE_OP` does not change and the radio jammer stays off, like the IED jammer.
- **Everybody in range is jammed**, including the own crew and allies.
- **Multiplayer only.**

## How it works

RHS offers no event for the DUKE, so the addon adds a second `fired` handler to the DUKE weapon and reads `RHS_DUKE_OP` 0.5 s later. The server registers every vehicle with `rhs_duke_type` as a disabled radio jammer (`VoiceCommsJammer`) and keeps it in line with the DUKE state and the antenna damage. The jamming itself (ACRE interference, Spectrum Device signal, cleanup on destruction) is done by Crow's Electronic Warfare.

## Dependencies

- [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728)
