# Compat BWA3

The Dingo 2 CG13 also jams ACRE radios, in addition to the IED jammer. Both are controlled with the same switch.

## How it works

- BWA3 switches the CG13 only through the variable `BWA3_Dingo2_ECM_on` (user actions `TurnOnCG13` / `TurnOffCG13`) and offers no event or callback. The `statement` entries of both user actions are therefore overridden in `CfgVehicles.hpp`: they still set the variable and additionally send the event `ewc_compat_bwa3_ecmToggled` to the server.
- BWA3 switches the CG13 off when the engine stops (its `POWER_FAILURE` transition) without any event. An `Engine` event handler (`fnc_initVehicle`) therefore sends the same event with `false` when the engine stops. It has to be registered on every client, because `Engine` only fires where the vehicle is local.
- The server registers every vehicle with `BWA3_hasECM = 1` once (`fnc_registerJammer`) as a disabled radio jammer (`VoiceCommsJammer`) in Crow's Electronic Warfare through `crowsEW_main_addJammer`. The event is sent only once `CBA_missionTime > 0`, because editor-placed vehicles initialise before Crow's Electronic Warfare has registered its handlers.
- `fnc_handleToggle` switches the jammer with `crowsEW_main_toggleJammer`. The jamming itself (ACRE interference, Spectrum Device signal, cleanup on destruction) is done by Crow's Electronic Warfare.
- Crow's Electronic Warfare adds its own (de)activate actions to every jammer. They would change its state without the CG13 switch. `fnc_removeCrowsActions` removes them from the Dingos on every `crowsEW_main_updateJammers` (`removeAllActions`; the Dingo only uses config user actions). On a machine that is server and client at once, Crow's Electronic Warfare adds the actions *after* it broadcasts that update, so `fnc_registerJammer` removes them directly as well.

## Limitations

- Everybody in range is jammed, including the own crew and allies. Crow's Electronic Warfare has no immunity apart from Zeus.
- The full jamming radius is the radius of the IED jammer (40 m, hardcoded in BWA3, so `ECM_EFFECTIVE_RADIUS` has to be adjusted if BWA3 changes it). The falloff radius is 1.5 times that.
- Crow's Electronic Warfare only works in multiplayer.

## Dependencies

- [BWmod](https://steamcommunity.com/sharedfiles/filedetails/?id=1200127537) (`bwa3_dingo2`)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728) (`crowsEW_main`)

## Maintainer

- Andx
