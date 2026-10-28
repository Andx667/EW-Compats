# Compat RHS

Vehicles with a DUKE (M1117, HMMWV family, MATV, M1A1/M1A2 and others) also jam ACRE radios, in addition to IEDs. The radio jammer follows the DUKE switch of RHS.

## How it works

- RHS switches the DUKE through a pseudo weapon (`rhsusf_weap_duke` / `rhsusf_weap_duke_on`). The `fired` event handler of the ammo `rhsusf_ammo_duke` starts or stops the jamming script `rhs_fnc_duke_jammer` and sets the public variable `RHS_DUKE_OP`. RHS offers no event or callback, and the script only handles TFAR (`tf_*DistanceMultiplicator`), so nothing happens for ACRE.
- Next to the RHS handler, `CfgAmmo.hpp` adds a second `fired` handler (`fnc_onFired`). It does not read the variable immediately, because RHS only sets it in a spawned script. After `DUKE_SYNC_DELAY` (0.5 s) it asks the server through the CBA event `ewc_compat_rhs_syncJammer` to sync the radio jammer.
- Every land vehicle with `rhs_duke_type` in its config (`fnc_initVehicle`, class event handler on `LandVehicle`) is registered once by the server as a disabled radio jammer (`VoiceCommsJammer`) in Crow's Electronic Warfare (`crowsEW_main_addJammer`), only once `CBA_missionTime > 0`, because editor-placed vehicles initialise before Crow's Electronic Warfare has registered its handlers.
- `fnc_syncJammer` (server) derives the wanted state from RHS and matches Crow's Electronic Warfare to it:
    - on or off from `RHS_DUKE_OP`
    - both antennas destroyed (`HitDuke1` / `HitDuke2` >= 0.99): off
    - one antenna destroyed (>= 1): 60 % range, as in `rhs_duke.sqf`
- Crow's Electronic Warfare cannot change the radii of a jammer, so a changed range removes the jammer (`crowsEW_main_removeJammer`) and registers it again.
- Antenna damage is reported by `fnc_onDammaged` through `Dammaged`. The handler only fires where the vehicle is local and is therefore registered on every client. It does nothing while the DUKE is off and merges hits within the delay into one sync.
- Destroyed vehicles are removed by the cleanup loop of Crow's Electronic Warfare. RHS lets its jamming script run on for dead vehicles, which has no effect on the radio jammer.
- Crow's Electronic Warfare adds its own (de)activate actions to every jammer. They would change its state without the DUKE. `fnc_removeCrowsActions` removes them from DUKE vehicles on every `crowsEW_main_updateJammers`. The DUKE is operated through its weapon, so no actions are lost. On a machine that is server and client at once, Crow's Electronic Warfare adds the actions *after* it broadcasts that update, so `fnc_registerJammer` removes them directly as well.

## Limitations

- Everybody in range is jammed, including the own crew and allies. Crow's Electronic Warfare has no immunity apart from Zeus.
- The full jamming radius is the radius of the DUKE's IED jamming (50 m, hardcoded in RHS, so `DUKE_EFFECTIVE_RADIUS` has to be adjusted if RHS changes it). The falloff radius is 1.5 times that.
- RHS only starts the jamming script if gunner and vehicle are local on the same machine (not for a gunner in the turret of someone else's vehicle, for example). In that case `RHS_DUKE_OP` does not change and the radio jammer stays off, like the IED jammer.
- Crow's Electronic Warfare only works in multiplayer.
- CUP vehicles only have a DUKE model without function and are not supported.

## Dependencies

- [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117) (`rhsusf_c_heavyweapons`)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728) (`crowsEW_main`)

## Maintainer

- Andx
