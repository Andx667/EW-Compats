# BFT Jamming

Adds the editor module and the Zeus module **Set as BFT Jammer**, which jams cTab's Blue Force Tracker (BFT). It works like Crow's Electronic Warfare's radio and drone jammers: a device, a radius, and it can be located with the Spectrum Device.

## Usage

Place the module in the editor and optionally synchronise it with the object that should be the jammer. Without a synchronised object a data terminal is spawned at the module's position. The module is in the **Crows Electronic Warfare** category.

| Attribute | Default | Purpose |
|---|---|---|
| Jamming Type | Blackout | `Blackout`, `Drift`, `Mixed` or `Spoof`. One jammer has exactly one type. |
| Effective Radius | 200 m | Full-strength zone around the jammer. |
| Falloff Radius | 400 m | Extra band *beyond* the effective radius in which the effect fades out. |
| Frequency | 805 MHz | Shown in the Spectrum Device. Must be inside the experimental antenna's range (520 to 1090 MHz). |
| Active at Mission Start | true | Starts on, or is switched on later (for example by Zeus). |

Zeus can switch the jammer on and off like any Crow's Electronic Warfare jammer and sees it on the map. Unlike Crow's Electronic Warfare's own jammers it makes no sound.

### Zeus

Zeus Enhanced has two modules in the same **Crows Electronic Warfare** category: **Set as BFT Jammer** and **Remove BFT Jammer**. Place **Set as BFT Jammer** on an object, or on the ground for a data terminal that is spawned there. The dialog has the attributes above, with *Active when placed* instead of *Active at Mission Start* and the frequency as a slider between 520 and 1090 MHz. **Remove BFT Jammer** removes the jammer from the object it is placed on, the Spectrum signal goes with it and the object stays. It only removes BFT jammers, the radio and drone jammers are removed with the module of Crow's Electronic Warfare.

## Jamming types

- **Blackout**: units in the whole range (effective plus falloff radius) disappear from the BFT.
- **Drift**: units stay visible but at a wrong position. The error is largest inside the effective radius (up to 250 m) and falls linearly to zero at the outer edge of the falloff band. The wrong position moves slowly instead of jumping.
- **Mixed**: Blackout inside the effective radius, Drift in the falloff band around it.
- **Spoof**: Drift for the real units in the whole range (like Drift), and ghosts on top of it inside the effective radius. Anyone whose own position is inside the effective radius sees ghosts on the BFT: copies of some of the groups and vehicles on their BFT, on a wrong position 150 to 400 m from the original, that move with it and have the callsign of the unit they copy, so the same callsign is on the BFT twice. In the falloff band there is only the drift. Nothing is spawned and nothing removes a ghost except the end of the jammer (switched off, destroyed, removed) or leaving the radius, a player has to go to the position to find out. Ghosts are made of groups and vehicles, never of the members of the player's own group.

## Who is jammed

!!! important "The jammer acts on the tracked unit, not on the viewer"
    A marker is jammed when **the unit it represents** is inside the jammer's range. Where the person looking at the map stands does not matter.

    - You are inside the range, others are outside: their markers are accurate.
    - Others are inside the range: their markers are jammed for **everyone** who looks at a cTab device.
    - Your own marker is drawn from your live position by cTab, so it is not shifted.

## Mission setting for Drift and Mixed

!!! warning "Drift needs `ctab_core_bft_mode = 2`"
    Drift only has a visible effect when cTab updates BFT positions at fixed intervals instead of live. The mission has to set and force `ctab_core_bft_mode` to `2` ("atSync"). In mode `1` ("realTime", cTab's default) cTab reads the live position and ignores the value this addon changes.

    **Blackout works in every mode.**

| Marker kind | Blackout | Drift / Mixed (mode 2) | Drift / Mixed (mode 1) |
|---|---|---|---|
| Groups | yes | yes | no |
| Vehicles | yes | yes | no |
| Dismounted members of the player's own group | yes | no, always drawn live | no |

## How it works

The module registers the object as an ordinary jammer in Crow's Electronic Warfare through its public CBA event `crowsEW_main_addJammer`. Crow's Electronic Warfare passes our capability tags (`BftJammerBlackout`, `BftJammerDrift`, `BftJammerMixed`, `BftJammerSpoof`) along unchanged. That gives Zeus markers, switching on and off and JIP sync for free, without touching its code.

The jamming itself runs on each client. cTab rebuilds `cTabBFTmembers`, `cTabBFTgroups` and `cTabBFTvehicles` locally and fires the local event `ctab_listsUpdated`. The addon hooks that event and changes the same arrays before cTab draws them.

An active BFT jammer shows in the Spectrum Device as signal type `sweep_bft` on the module's frequency, whatever the jamming type.

There are deliberately no CBA settings: the drift tuning is fixed so drift behaves the same on every server.

!!! note "Coupling to other mods"
    The integration uses public CBA events and global variables of Crow's Electronic Warfare and cTab, not a documented plugin API. An update of either mod could change them. Test after version bumps of both.

## Dependencies

- [Crow's Electronic Warfare](https://github.com/Crowdedlight/Crows-Electronic-Warfare)
- [cTab](https://github.com/jetelain/cTab)
