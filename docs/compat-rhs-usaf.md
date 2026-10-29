# Compat RHS USAF

Vehicles with a **DUKE** (M1117, HMMWV family, MATV, M1A1/M1A2, Bradley and others) also jam ACRE radios, in addition to IEDs. The radio jammer follows the DUKE switch of RHS.

!!! note "Gameplay values"
    The real DUKE (AN/VLQ-12 CREW Duke) is a vehicle-mounted counter-RCIED jammer. Its frequency bands and jamming range are not publicly documented in detail, so the radii here are gameplay values. The jammer is modelled as simply on or off and jams continuously in its radius while on.

## Controls

Switch the DUKE with its weapon `rhsusf_weap_duke`, as in RHS. The radio jammer follows it.

Every change of state shows a silent hint to everybody in the vehicle, for example *DUKE on* or *DUKE off: antennas destroyed*. The reason is given when the DUKE switches itself off because both antennas were destroyed or the DUKE was disabled in the settings.

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

- **Select the DUKE first on vehicles with a smoke launcher.** The Bradley and the Abrams have the DUKE next to a smoke launcher in the same countermeasure slot, and the smoke launcher is listed first. Press **Ctrl+C** to cycle the countermeasure to *DUKE offline* / *DUKE online* before firing, otherwise the smoke launcher fires. Vehicles where the DUKE is the only countermeasure, like the M1117, HMMWV and MATV, need no selection.
- **A triggered IED explodes when it leaves the jamming range.** The DUKE does not defuse an IED, it only holds it back: `rhs_duke.sqf` switches the simulation of the IEDs in range off and on again when they leave the range or the DUKE stops. An IED that is triggered while it is inside the range stays inert, but it explodes as soon as the DUKE is out of range, for example when the vehicle drives on or the DUKE is switched off. This is RHS's own behaviour, this addon does not change it, and it is the same as the Dingo CG13 of [Compat BWA3](compat-bwa3.md). Keep the distance until the IED is cleared.
- **Operated through the weapon.** RHS toggles the DUKE with a pseudo weapon (`rhsusf_weap_duke`). The addon reads the result 0.5 s after the shot, because RHS only sets `RHS_DUKE_OP` in a spawned script.
- **A destroyed antenna changes the range.** Crow's Electronic Warfare cannot change the radii of a jammer, so the jammer is removed and registered again with the new range. Hits within the delay are merged into one sync.
- **Locality matters.** RHS only starts its jamming script if gunner and vehicle are local on the same machine, for example not for a gunner in the turret of someone else's vehicle. Then `RHS_DUKE_OP` does not change and the radio jammer stays off, like the IED jammer.
- **IEDs of CUP are not jammed.** `rhs_duke.sqf` only jams `PipeBombBase` IEDs, which are the vanilla and ACE IEDs. The IEDs of CUP (`CUP_IED_V1_Ammo` to `V4`) derive from `MineBase` and explode as normal, also with CUP and RHS loaded together. This is RHS's own behaviour, this addon does not change it. The CUP DUKE of [Compat CUP DUKE](compat-cup-duke.md) does jam them.
- **Everybody in range is jammed**, including the own crew and allies.
- **Multiplayer only.**

## How it works

RHS offers no event for the DUKE, so the addon adds a second `fired` handler to the DUKE weapon and reads `RHS_DUKE_OP` 0.5 s later. The server registers every vehicle with `rhs_duke_type` as a disabled radio jammer (`VoiceCommsJammer`) and keeps it in line with the DUKE state and the antenna damage. The jamming itself (ACRE interference, Spectrum Device signal, cleanup on destruction) is done by Crow's Electronic Warfare.

## Dependencies

- [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728)
