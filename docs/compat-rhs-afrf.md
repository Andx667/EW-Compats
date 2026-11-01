# Compat RHS AFRF

The **GAZ-66 (R-142N)** radio vehicle jams ACRE radios and the control link of drones while its mast is deployed. RHS AFRF has no jammer of its own, so this addon defines the whole behaviour. The USAF DUKE is covered by [Compat RHS USAF](compat-rhs-usaf.md).

!!! note "Gameplay values"
    The real R-142N is a command and staff radio vehicle, not a jammer. Making it a broad spectrum jammer is a gameplay choice. The radius is a setting, there is no data sheet value behind it. The jammer is modelled as simply on or off and jams continuously in its radius while the mast is up.

## Controls

Operate the mast as in RHS: with the actions *Deploy Mast* and *Fold Mast* (driver, vehicle standing) or the editor attribute *Deploy Mast*. The jammer follows the mast.

It starts when the mast is up, after about 5 s, and stops as soon as the mast is folded. Every change of state shows a silent hint to everybody in the vehicle, for example *R-142N on* or *R-142N off*. A reason is only given when the setting keeps a deployed mast silent.

RHS sets the fuel of the vehicle to 0 while the mast is deployed, so the engine cannot run.

## Range

| | Radius |
|---|---|
| Full jamming (effective) | **500 m** |
| Falloff band beyond that | **750 m** |
| Outer edge | **1250 m** |

The effective radius is the setting *R-142N jamming radius*, the falloff band is 1.5 times that. The falloff only applies to radios: Crow's Electronic Warfare jams drones within the effective radius only, with no falloff band.

## Settings

### `ewc_compat_rhs_afrf_enable`

- Name: Enable R-142N jamming
- Type: `CHECKBOX`
- Default: `true`
- Set by: the server
- Purpose: if off, the R-142N does not jam. Applied the next time the mast is deployed or folded.

### `ewc_compat_rhs_afrf_radius`

- Name: R-142N jamming radius (m)
- Type: `SLIDER`
- Range: `100` to `2000` m
- Default: `500`
- Set by: the server
- Purpose: full jamming radius. Applied the next time the mast is deployed.

### `ewc_compat_rhs_afrf_jamRadio`

- Name: Jam radios
- Type: `CHECKBOX`
- Default: `true`
- Set by: the server
- Purpose: jam radios. Applied the next time the mast is deployed.

### `ewc_compat_rhs_afrf_jamDrones`

- Name: Jam drones
- Type: `CHECKBOX`
- Default: `true`
- Set by: the server
- Purpose: jam drones. Applied the next time the mast is deployed.

### Complete example

``` cpp
// cba_settings.sqf
force ewc_compat_rhs_afrf_enable = false; // default: true
force ewc_compat_rhs_afrf_radius = 1000; // default: 500
force ewc_compat_rhs_afrf_jamRadio = true; // default: true
force ewc_compat_rhs_afrf_jamDrones = false; // default: true
```

With both Jam radios and Jam drones off, the R-142N does not jam.

## Quirks

- **Everybody in range is jammed**, including the own crew and allies. Crow's Electronic Warfare has no immunity apart from Zeus.
- **No jamming of IEDs.** The R-142N only jams radios and drones.
- **The mast has no damage of its own.** Only the destruction of the vehicle stops the jammer.
- **Use the mast, not Crow's actions.** Crow's own (de)activate actions are removed from the R-142N, because they would desync the two.
- **Multiplayer only.** Crow's Electronic Warfare does not work in singleplayer.

## How it works

RHS calls the functions in the vehicle variable `rhs_eh_gaz66_deploy` at the end of its mast script, whichever way the mast is deployed. The addon adds a function there that tells the server. The server waits until the mast is up (door phase `mast_source` at 0.99) and switches the jammer, registered with the capabilities radio and drone (by the registry of `ewc_common`) when the mast is first deployed. A changed radius or choice of signals replaces the Crow's Electronic Warfare jammer, because it cannot change them.

## Dependencies

- [RHS AFRF](https://steamcommunity.com/sharedfiles/filedetails/?id=843425103)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728)
