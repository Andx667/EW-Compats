# RF Exposure

An optional feature, **off by default**: staying close to an active jammer on foot gives a mild headache (pain of ACE medical), and fatigue (ACE advanced fatigue) once the headache is bad enough. Somebody inside a vehicle is safe.

It is a gameplay feature, not a medical claim. Military guidance says that operators of vehicle jammers (DUKE and similar) are safe outside the stand-off distances of the antenna, that the exposure falls quickly with the distance, and that headaches and tiredness are reported around them but are also put down to heat, stress, noise and other causes. The values here are made up for gameplay.

## Setting up

Everything is a global setting (CBA addon options, `ewc_rf_exposure_*`), so the server decides. Nothing runs while the feature is off.

| Setting | Default | Purpose |
|---|---|---|
| `enable` | off | The feature. |
| `sources` | All jammers | Which active jammers count: all of them (including static ones like the data terminal), or only those mounted on a vehicle (land vehicles, aircraft and ships). |
| `nearRadius` | 2 m | Within this distance of the hull of a jammer a full exposure takes `nearTime`. |
| `farRadius` | 5 m | At this distance a full exposure takes `farTime`. Beyond it there is no exposure. |
| `nearTime` | 900 s | 15 minutes within the near radius. |
| `farTime` | 1800 s | 30 minutes at the far radius. |
| `recoveryTime` | 300 s | A full exposure is gone after this time away from the jammers, or in a vehicle. |
| `painMax` | 0.25 | Pain of a full exposure. Limited to half of the ACE setting `ace_medical_painUnconsciousThreshold`. |
| `fatigueThreshold` | 0.15 | Pain of the jammer from which the fatigue starts. |
| `fatigueFactor` | 0.5 | Extra effort of every movement at full fatigue (+50 %). 0 turns the fatigue off. |

## How it works

Each client works out the exposure of its own player, a number from 0 to 1. Nothing is synced and the server does nothing. The jammers are read from the jammer map of Crow's Electronic Warfare (`crowsEW_main_jamMap`), which every client has, so every jammer counts that is registered there: the vehicles of the compat addons, the BFT and Wi-Fi jammers, and Crow's own.

- **Distance** is measured to the bounding box of the jammer, so 2 m is two metres from the hull of a vehicle, not from its centre.
- **Rate**: within the near radius the exposure grows by `1 / nearTime` per second, at the far radius by `1 / farTime`, in between linearly, and beyond the far radius it does not grow. The strongest jammer counts, jammers do not add up. With the defaults that is 15 minutes within 2 m or 30 minutes at 5 m. The time adds up: leaving does not reset the exposure, it falls over `recoveryTime`.
- **Vehicles**: anybody inside of a vehicle (driver, passenger, gunner) has no exposure, whatever jammer is near, and recovers.
- **Headache**: the pain of ACE medical is raised towards `exposure * painMax` through `ace_medical_fnc_adjustPainLevel`. It is only topped up to that value and never above, so it does not add to the pain of wounds a player already has, and ACE fades it by itself afterwards. `painMax` is limited to half of `ace_medical_painUnconsciousThreshold`, so the jammer alone stays clear of it; a wound taken on top adds its pain as usual (`adjustPainLevel` adds) and can go over, which is intended. ACE medical has a single pain value and none for the head, and it shows its own effects for pain (blur, flashes). The player gets a hint when the headache starts.
- **Fatigue**: when the pain of the jammer (`exposure * painMax`) reaches `fatigueThreshold` the movement costs more effort, by half of `fatigueFactor` at first and by all of it at `painMax`. It is a duty factor (`ewc_rf_exposure`) of ACE advanced fatigue. Without ACE advanced fatigue the vanilla fatigue rises slowly instead, if the stamina is on. The player gets a hint when it starts.
- A new unit (respawn, Zeus remote control) starts without exposure. The `0` of the event goes with the old unit.
- **Jammers**: `XEH_preInit` takes the jammers that are on from the map of every `crowsEW_main_updateJammers` into `ewc_rf_exposure_jammers` (`[object, is a vehicle, bounding radius]`) and starts the loop from there. It reads the map of the event and not the global `crowsEW_main_jamMap`, because the handler of Crows that updates the global runs after ours. A destroyed jammer is skipped and does not keep the loop running.

The exposure is readable in the debug console as `ewc_rf_exposure_exposure`.

## Events

- `ewc_rf_exposure_API_stageChanged`: raised on the client of the player (local event) when the stage of the exposure changes, with `[unit, stage]`. The stage is `0` none, `1` headache (from an exposure of 0.25, until it is nearly gone) and `2` fatigue. A mission can use it for extra effects, a medic task or a log. Reset by a respawn or a new unit (stage `0`).

```sqf
["ewc_rf_exposure_API_stageChanged", {
    params ["_unit", "_stage"];
    systemChat format ["RF exposure stage: %1", _stage];
}] call CBA_fnc_addEventHandler;
```

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_updateLoop` | clients | Starts or stops the loop, when a setting changes or a jammer is switched. It only runs while a jammer is on or there is exposure left |
| `fnc_exposureLoop` | clients | Per frame handler: raises or lowers the exposure of the local player, then applies it |
| `fnc_getRate` | clients | Exposure per second from the strongest jammer that counts |
| `fnc_getDistance` | clients | Distance from a unit to the bounding box of an object |
| `fnc_applyEffects` | clients | The pain, the fatigue and the hints |
| `fnc_reset` | clients | Ends the exposure and takes the fatigue factor away |
| `fnc_onPlayerChanged` | clients | Handler of the CBA player event `unit`: a new unit starts clean |

## Coupling to other mods

The integration uses public CBA events and global variables of Crow's Electronic Warfare and ACE, and one function of ACE that is not marked as public (`ace_advanced_fatigue_fnc_addDutyFactor` and `removeDutyFactor`, which ACE uses itself and that are meant for such factors). A future update could change them and silently break the addon. Test after version bumps.

- `crowsEW_main_updateJammers`, `crowsEW_main_jamMap`
- `ace_medical_fnc_adjustPainLevel`, `ace_medical_pain`, `ace_medical_painUnconsciousThreshold`, `ace_medical_enabled`
- `ace_advanced_fatigue_enabled`, `ace_advanced_fatigue_fnc_addDutyFactor`, `ace_advanced_fatigue_fnc_removeDutyFactor`

## Dependencies

- [Crow's Electronic Warfare](https://github.com/Crowdedlight/Crows-Electronic-Warfare) (`crowsEW_main`)
- [ACE3](https://github.com/acemod/ACE3) (`ace_main`). The headache needs ACE medical and the fatigue ACE advanced fatigue for the full effect, each is skipped when it is missing or off

## Maintainer

- Andx
