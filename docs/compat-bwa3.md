# Compat BWA3

The Dingo 2 **CG13** also jams ACRE radios, in addition to the IED jammer. Both are controlled with the same switch.

!!! note "Gameplay values"
    The real CG13 is reported to offer reactive, active and combined jamming. This addon mimics the **active** mode: the jammer is either on or off and, while on, jams continuously in its whole radius.

## Controls

Switch the CG13 with its own actions, `TurnOnCG13` / `TurnOffCG13`. The radio jammer follows it.

## Range

| | Radius |
|---|---|
| Full jamming (effective) | **40 m** |
| Falloff band beyond that | **60 m** |
| Outer edge | **100 m** |

The 40 m is the IED jammer radius hardcoded in BWA3. The falloff band is 1.5 times that.

## Settings

| Setting | Default | |
|---|---|---|
| Enable BWA3 CG13 jamming | on | If off, the Dingos do not jam radios. Set by the server |

## Quirks

- **Engine off means jammer off.** BWA3 switches the CG13 off when the engine stops, without any event. The addon watches the `Engine` event and switches the radio jammer off as well. It has to be registered on every client, because the event only fires where the vehicle is local.
- **Use the CG13 actions, not Crow's.** Crow's own (de)activate actions would switch the jammer without the CG13 and desync the two, so they are removed from the Dingos. Use `TurnOnCG13` / `TurnOffCG13`.
- **A triggered IED explodes when it leaves the jamming range.** The jammer does not defuse an IED, it only holds it back. If an IED is triggered while it is inside the 40 m, it stays inert, but it explodes as soon as the jammer is out of range, for example when the Dingo drives on or the engine is stopped. This is BWA3's own behaviour, this addon does not change it. Keep the distance until the IED is cleared.
- **Everybody in range is jammed**, including the own crew and allies. Crow's Electronic Warfare has no immunity apart from Zeus.
- **Multiplayer only.** Crow's Electronic Warfare does not work in singleplayer.

## How it works

BWA3 switches the CG13 only through the variable `BWA3_Dingo2_ECM_on` and offers no event. The `statement` of both user actions is overridden: they still set the variable and additionally send `ewc_compat_bwa3_ecmToggled` to the server. The server registers every vehicle with `BWA3_hasECM = 1` as a disabled radio jammer (`VoiceCommsJammer`) once `CBA_missionTime > 0` and switches it with `crowsEW_main_toggleJammer`. The jamming itself (ACRE interference, Spectrum Device signal, cleanup on destruction) is done by Crow's Electronic Warfare.

## Dependencies

- [BWmod](https://steamcommunity.com/sharedfiles/filedetails/?id=1200127537)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728)
