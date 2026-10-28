# Compat CUP

Vehicles with a **DUKE antenna** (CUP HMMWV, MATV, M1A1/M1A2 Abrams, RG-31 and other vehicles with the same antenna) get a DUKE switch. A running DUKE jams ACRE radios and IEDs around the vehicle.

## How it works

- CUP only models the DUKE. The antenna is an animation source that can be hidden, and there is no jammer behind it, so this addon provides the whole function.
- A vehicle counts as DUKE equipped if its `AnimationSources` contain one of `hide_antenna_duke` (M1151), `hide_Duke_antenna` and `hide_crew_duke` (M1240), `hide_duke_antennas` (Abrams) or `SYS_crewduke` (RG-31). `fnc_getDukeSources` collects them per class, reading every class up the inheritance chain because inherited subclasses are not listed as children, and caches the result, so no class list has to be kept.
- The antenna is shown at phase 0 and hidden at phase 1. A vehicle only has a working DUKE while at least one of its antennas is shown. The M1240 family (Hunter, M1245 and others) has two, `hide_Duke_antenna` and `hide_crew_duke`: all shown gives the full range, only one shown 60 % of it (like RHS with a destroyed antenna), none shown switches the DUKE off (`fnc_getRangeScale`, `fnc_getRadius`).
- Crew can switch the DUKE with a scroll wheel action, an ACE self-interaction or both (CBA setting `ewc_compat_cup_actionMode`). The request goes to the server (`ewc_compat_cup_toggle`), which checks it again (`fnc_handleToggle`) and then switches the DUKE (`fnc_setJammer`). The state is the public variable `ewc_compat_cup_dukeOn`.
- Every DUKE vehicle is registered once by the server as a disabled radio jammer (`VoiceCommsJammer`) in Crow's Electronic Warfare (`crowsEW_main_addJammer`), only once `CBA_missionTime > 0`, because editor-placed vehicles initialise before Crow's Electronic Warfare has registered its handlers. Switching the DUKE toggles that jammer.
- While at least one DUKE is on, a server side loop (`fnc_jamLoop`, once per second) switches a DUKE off when its vehicle is destroyed, its antenna is hidden or, if required, its engine stops. It also keeps the IEDs in range disabled.
- IED jamming is the approach of the Dingo CG13: IEDs (`PipeBombBase`) in range get `enableSimulationGlobal false` and are enabled again when they leave the range or the DUKE stops (`fnc_updateMines`, `fnc_releaseMines`). The addon only frees mines it disabled itself.
- Crow's Electronic Warfare adds its own (de)activate actions to every jammer. They would change its state without the DUKE. `fnc_clearCrowsActions` removes only those, recognised by their coloured title, on every `crowsEW_main_updateJammers`. The other addons use `removeAllActions`, which would also remove the DUKE switch here.

## Settings

| Setting | Default | |
|---|---|---|
| DUKE switch | Scroll wheel | Scroll wheel, ACE self-interaction or both. Per client. Without ACE the scroll wheel is always used |
| Jamming radius | 50 m | Full jamming radius for radios and IEDs. The radio falloff band is 1.5 times that. Set by the server |
| Jam IEDs | on | Set by the server |
| Require running engine | on | Set by the server |

A changed radius, or an antenna hidden or shown again on a vehicle with two, replaces the Crow's Electronic Warfare jammer, because it cannot change the radii of a jammer.

## Limitations

- Everybody in range is jammed, including the own crew and allies. Crow's Electronic Warfare has no immunity apart from Zeus.
- Only IEDs are disabled, not every mine.
- Disabled IEDs are shared with the Dingo CG13. If both jam the same IED and one stops first, the IED is free for up to a second, until the other one disables it again.
- The check of the antennas runs once per second, so a hidden antenna keeps jamming for up to a second at the old range.
- Which animation phase is shown was derived from the CUP configs and still has to be confirmed in game for every vehicle type.
- Crow's Electronic Warfare only works in multiplayer.

## Dependencies

- [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728) (`crowsEW_main`)
- Optional: [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057) for the self-interaction

## Maintainer

- Andx
