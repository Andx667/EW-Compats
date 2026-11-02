# RF Exposure

An optional feature, **off by default**: staying close to an active jammer on foot gives a mild headache (pain of ACE medical), and fatigue (ACE advanced fatigue) once the headache is bad enough. Somebody inside a vehicle is safe.

!!! note "Gameplay, not medicine"
    Military guidance says that operators of vehicle jammers (DUKE and similar) are safe outside the stand-off distances of the antenna, that the exposure falls quickly with the distance, and that headaches and tiredness are reported around them but are also put down to heat, stress, noise and other causes. The values here are made up for gameplay.

## Settings

All settings are global (CBA addon options, `ewc_rf_exposure_*`), so the server decides. Nothing runs while the feature is off.

| Setting | Default | Purpose |
|---|---|---|
| Enable RF exposure | off | The feature. |
| Jammers that count | All jammers | All active jammers (including static ones like the data terminal), or only those mounted on a vehicle. |
| Near radius | 2 m | Within this distance of the hull of a jammer a full exposure takes the near time. |
| Far radius | 5 m | At this distance a full exposure takes the far time. Beyond it there is no exposure. |
| Time at the near radius | 900 s | 15 minutes. |
| Time at the far radius | 1800 s | 30 minutes. |
| Recovery time | 300 s | A full exposure is gone after this time away from the jammers, or in a vehicle. |
| Maximum pain | 0.25 | Pain of a full exposure. Limited to half of the ACE setting for the pain that can make a unit unconscious. |
| Pain for fatigue | 0.15 | Pain of the jammer from which the fatigue starts. |
| Fatigue factor | 0.5 | Extra effort of every movement at full fatigue (+50 %). 0 turns the fatigue off. |

## What happens

Each client works out the exposure of its own player, a number from 0 to 1. The distance is measured to the hull of the jammer (its bounding box), so 2 m is two metres from the side of a vehicle.

- **Time adds up.** Within the near radius a full exposure takes 15 minutes, at the far radius 30 minutes, in between the time grows linearly, and beyond the far radius there is none. Leaving does not reset it, it falls over the recovery time. The strongest jammer counts, jammers do not add up.
- **Vehicles are safe.** Anybody inside of a vehicle (driver, passenger, gunner) has no exposure, whatever jammer is near, and recovers. That includes the crew of the jammer.
- **Headache.** The pain of ACE medical rises towards `exposure * maximum pain`. It is only topped up to that value and never above, so it does not add to the pain of wounds, and ACE fades it by itself afterwards. ACE medical has one pain value and none for the head, and it shows its own effects for pain (blur, flashes). The player gets a hint when the headache starts.
- **Fatigue.** When the pain of the jammer reaches the threshold, every movement costs more effort: half of the fatigue factor at first, all of it at the maximum pain. Without ACE advanced fatigue the vanilla fatigue rises slowly instead, if the stamina is on. The player gets a hint when it starts.
- A new unit (respawn, Zeus remote control) starts without exposure.

The maximum pain is limited to half of `ace_medical_painUnconsciousThreshold`, so the jammer never brings anybody near the pain at which ACE can make a unit unconscious.

## Events

`ewc_rf_exposure_stageChanged` is raised on the client of the player (local event) when the stage of the exposure changes, with `[unit, stage]`. The stage is `0` none, `1` headache (from an exposure of 0.25, until it is nearly gone) and `2` fatigue. A mission can use it for extra effects, a medic task or a log. A respawn or a new unit sets it back to `0`.

``` cpp
["ewc_rf_exposure_stageChanged", {
    params ["_unit", "_stage"];
    systemChat format ["RF exposure stage: %1", _stage];
}] call CBA_fnc_addEventHandler;
```

## Which jammers

The jammers are read from the jammer map of Crow's Electronic Warfare, so every jammer counts that is registered there: the vehicles of the compat addons (DUKE, CG13, R-142N, Hummel), the [BFT](bft-jamming.md) jammer, and Crow's own radio and drone jammers. With *Vehicle-mounted only* the static ones are left out.

!!! note "Coupling to other mods"
    The integration uses public CBA events and global variables of Crow's Electronic Warfare and ACE, and the duty factor functions of ACE advanced fatigue, which ACE does not mark as public. An update of either mod could change them. Test after version bumps.

## Dependencies

- [Crow's Electronic Warfare](https://github.com/Crowdedlight/Crows-Electronic-Warfare)
- [ACE3](https://github.com/acemod/ACE3). The headache needs ACE medical and the fatigue ACE advanced fatigue for the full effect, each is skipped when it is missing or off
