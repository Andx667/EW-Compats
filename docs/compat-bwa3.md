# Compat BWA3

The Dingo 2 **CG13** also jams ACRE radios, in addition to the IED jammer. Both are controlled with the same switch.

## Range

| | Radius |
|---|---|
| Full jamming (effective) | **40 m** |
| Falloff band beyond that | **60 m** |
| Outer edge | **100 m** |

The 40 m is the IED jammer radius hardcoded in BWA3. The falloff band is 1.5 times that.

## Quirks

- **Engine off means jammer off.** BWA3 switches the CG13 off when the engine stops, without any event. The addon watches the `Engine` event and switches the radio jammer off as well. It has to be registered on every client, because the event only fires where the vehicle is local.
- **Use the CG13 actions, not Crow's.** Crow's own (de)activate actions would switch the jammer without the CG13 and desync the two, so they are removed from the Dingos. Use `TurnOnCG13` / `TurnOffCG13`.
- **Everybody in range is jammed**, including the own crew and allies. Crow's Electronic Warfare has no immunity apart from Zeus.
- **Multiplayer only.** Crow's Electronic Warfare does not work in singleplayer.

## How it works

BWA3 switches the CG13 only through the variable `BWA3_Dingo2_ECM_on` and offers no event. The `statement` of both user actions is overridden: they still set the variable and additionally send `ewc_compat_bwa3_ecmToggled` to the server. The server registers every vehicle with `BWA3_hasECM = 1` as a disabled radio jammer (`VoiceCommsJammer`) once `CBA_missionTime > 0` and switches it with `crowsEW_main_toggleJammer`. The jamming itself (ACRE interference, Spectrum Device signal, cleanup on destruction) is done by Crow's Electronic Warfare.

## Dependencies

- [BWmod](https://steamcommunity.com/sharedfiles/filedetails/?id=1200127537)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728)
