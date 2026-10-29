# BFT Jamming

Adds the editor module **Set as BFT Jammer**, which jams cTab's Blue Force Tracker (BFT). It works like Crow's Electronic Warfare's radio and drone jammers: a device, a radius, and it can be located with the Spectrum Device.

## Usage

Place the module in the editor and optionally synchronise it with the object that should be the jammer. Without a synchronised object a data terminal is spawned at the module's position.

Module attributes:

- **Jamming Type**: `Blackout`, `Drift` or `Mixed`. One jammer has exactly one type.
    - **Blackout**: units in the whole range (effective plus falloff radius) disappear from the BFT.
    - **Drift**: units stay visible but are shown at a wrong position. The error is largest inside the effective radius and falls to zero at the outer edge of the falloff radius. The wrong position moves slowly instead of jumping. Only affects group and vehicle icons, see the note below.
    - **Mixed**: Blackout inside the effective radius, Drift in the falloff band around it.
- **Effective Radius** / **Falloff Radius** (metres).
- **Frequency**: frequency in MHz under which the active jammer shows in the Spectrum Device. Must be inside the range of the experimental antenna (520 to 1090 MHz).
- **Active at Mission Start**: whether the jammer starts on, or is switched on later (for example by Zeus).

Zeus can switch the jammer on and off like any Crow's Electronic Warfare jammer and sees it on the map. The module can only be placed in the editor, not in Zeus. Unlike Crow's Electronic Warfare's own jammers it makes no sound.

> **Drift and Mixed need a mission setting.** Drift only has a visible effect when cTab updates BFT positions at fixed intervals instead of live: the mission has to set and force `ctab_core_bft_mode` to `2` ("atSync"). In mode `1` ("realTime", cTab's default) cTab reads the live position and ignores the value this addon changes. Blackout works in every mode.
> Even then, Drift only moves group and vehicle icons. cTab always draws dismounted members of the player's own group at their real position.

## How it works

The module registers the object as an ordinary jammer in Crow's Electronic Warfare through its public CBA event `crowsEW_main_addJammer`. Crow's Electronic Warfare does not know our capability tags (`BftJammerBlackout`, `BftJammerDrift`, `BftJammerMixed`) but passes them along unchanged. That gives Zeus markers, switching on and off by right-click and JIP sync for free, without touching its code.

Crow's Electronic Warfare registers its `addJammer` handler only in its own `postInit`, but module functions can run earlier, and a server event without a handler is dropped silently. `fnc_addBftJammer` therefore raises the event with `CBA_fnc_waitUntilAndExecute` once `CBA_missionTime > 0`. For the same reason our own event handlers are registered in `preInit`.

The jamming itself runs on each client: cTab rebuilds `cTabBFTmembers`, `cTabBFTgroups` and `cTabBFTvehicles` locally and then fires the local event `ctab_listsUpdated`. The addon hooks that event and changes the same arrays before cTab draws them. Jammers whose object is already deleted are skipped, because they stay in the jammer map until Crow's Electronic Warfare's cleanup loop and `getPosASL objNull` would jam around `[0,0,0]`.

The drift offset is smoothed per unit and jammer: the target offset is re-rolled every few pulses and interpolated in between, so the icon moves instead of jumping. Each offset is computed once per pulse, because a unit can be in two lists (the leader of the player's group is in both `cTabBFTmembers` and `cTabBFTgroups`) and would otherwise drift twice as fast.

An active BFT jammer shows in the Spectrum Device as signal type `sweep_bft` on the module's frequency, whatever the jamming type. `fnc_onUpdateJammersServer` compares the signal with the on/off state on every `crowsEW_main_updateJammers`, reading the actual state from `crowsEW_spectrum_beacons`.

There are deliberately no CBA settings: without a placed module nothing happens anyway, the frequency is a module attribute, and the drift tuning (`BFT_JAM_MAX_DRIFT_DISTANCE`, `BFT_JAM_DRIFT_UPDATE_INTERVAL` in `script_component.hpp`) is fixed so drift behaves the same on every server.

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_addBftJammer` | server | Registers the module object as a jammer in Crow's Electronic Warfare, once `CBA_missionTime > 0` |
| `fnc_onUpdateJammersServer` | server | Keeps the signal in the Spectrum Device in line with the on/off state of the jammers on every `crowsEW_main_updateJammers` |
| `fnc_onBftListsUpdated` | clients | Handler of `ctab_listsUpdated`: removes or drifts the entries of the cTab lists that are in range of a jammer |
| `fnc_applyBftJam` | clients | Applies the active jammers to one entry of a cTab list, shared by the three lists |
| `fnc_calcBftJamStrength` | any | Jamming strength 0 to 1 from the distance, the effective radius and the falloff radius |
| `fnc_getBftDriftOffset` | clients | Smoothed offset of a drifted entry, re-rolled every few pulses per unit and jammer |

## Coupling to other mods

The integration uses the public CBA events and global variables of Crow's Electronic Warfare and cTab, not a documented plugin API:

- `crowsEW_main_addJammer`, `crowsEW_main_updateJammers`, `crowsEW_main_jamMap`
- `crowsEW_spectrum_addBeacon`, `crowsEW_spectrum_removeBeacon`, `crowsEW_spectrum_beacons`
- `ctab_listsUpdated`, `cTabBFTmembers` / `cTabBFTgroups` / `cTabBFTvehicles`

A future update of either mod could change these names or array formats and silently break the addon. Test after version bumps of both.

## Dependencies

- [Crow's Electronic Warfare](https://github.com/Crowdedlight/Crows-Electronic-Warfare) (`crowsEW_main`, `crowsEW_spectrum`)
- [cTab](https://github.com/jetelain/cTab) (`cTab_core`, `cTab_main`)

## Maintainer

- Andx
