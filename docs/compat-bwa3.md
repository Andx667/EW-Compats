# Compat BWA3

The Dingo 2 **CG13** also jams ACRE radios, in addition to the IED jammer. Both are controlled with the same switch.

!!! note "Gameplay values"
    The real CG13 is reported to offer reactive, active and combined jamming. This addon mimics the **active** mode: the jammer is either on or off and, while on, jams continuously in its whole radius.

## Controls

Switch the CG13 with its own actions, `TurnOnCG13` / `TurnOffCG13`. The radio jammer follows it.

Every change of state shows a silent hint to everybody in the vehicle, for example *CG13 on* or *CG13 off: engine stopped*. The reason is only given when the engine stopped.

## Range

| | Radius |
|---|---|
| Full jamming (effective) | **40 m** |
| Falloff band beyond that | **60 m** |
| Outer edge | **100 m** |

The 40 m is the IED jammer radius hardcoded in BWA3. The falloff band is 1.5 times that.

## Settings

### `ewc_compat_bwa3_enableCG13`

- Name: Enable BWA3 CG13 jamming
- Type: `CHECKBOX`
- Default: `true`
- Set by: the server
- Purpose: if off, the CG13 switch does nothing: the Dingos jam neither radios nor IEDs.

### Complete example

``` cpp
// cba_settings.sqf
force ewc_compat_bwa3_enableCG13 = false; // default: true
```

## Quirks

- **The driver getting out does not stop a running CG13.** Arma stops the engine when the driver gets out, which would switch the CG13 off, but not when he ejects. The addon starts the engine again when it stops without a driver while the CG13 is on, so both ways of leaving behave the same. The engine keeps running until somebody stops it.
- **Engine off means jammer off.** BWA3 switches the CG13 off when the engine stops, without any event. The addon watches the `Engine` event and switches the radio jammer off as well. It has to be registered on every client, because the event only fires where the vehicle is local.
- **A triggered IED explodes when it leaves the jamming range.** The jammer does not defuse an IED, it only holds it back. If an IED is triggered while it is inside the 40 m, it stays inert, but it explodes as soon as the jammer is out of range, for example when the Dingo drives on or the engine is stopped. This is BWA3's own behaviour, this addon does not change it. Keep the distance until the IED is cleared.
- **IEDs of CUP are not jammed.** BWA3 only jams `PipeBombBase` IEDs, which are the vanilla and ACE IEDs. The IEDs of CUP (`CUP_IED_V1_Ammo` to `V4`) derive from `MineBase` and explode as normal, also with CUP and BWmod loaded together. This is BWA3's own behaviour, this addon does not change it. The CUP DUKE of [Compat CUP DUKE](compat-cup-duke.md) does jam them.
- **Everybody in range is jammed**, including the own crew and allies. Crow's Electronic Warfare has no immunity apart from Zeus.
- **Multiplayer only.** Crow's Electronic Warfare does not work in singleplayer.

## How it works

BWA3 switches the CG13 only through the variable `BWA3_Dingo2_ECM_on` and offers no event. The `statement` of both user actions is overridden: they still set the variable and additionally send `ewc_compat_bwa3_ecmToggled` to the server. The server registers every vehicle with `BWA3_hasECM = 1` as a disabled radio jammer (`VoiceCommsJammer`) once `CBA_missionTime > 0` and switches it with `crowsEW_main_toggleJammer`. The jamming itself (ACRE interference, Spectrum Device signal, cleanup on destruction) is done by Crow's Electronic Warfare.

## Dependencies

- [BWmod](https://steamcommunity.com/sharedfiles/filedetails/?id=1200127537)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728)
