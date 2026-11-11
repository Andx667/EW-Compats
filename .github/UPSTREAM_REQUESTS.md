# Upstream requests

Changes we would like in the mods EW Compats builds on, and where each one stands. Each request names the workaround in this repo that it would let us remove. Out-of-development mods (RHS, CUP, BWmod) are left out on purpose.

Last updated: 2026-11-11.

## Filed

The first batch was filed on 2026-11-02. All five got an answer within two days. File the next batch once the open PRs are merged, see [Parked](#parked-not-filed-yet).

| Mod | Issue | Request | Status |
|---|---|---|---|
| Crow's EW | [#189](https://github.com/Crowdedlight/Crows-Electronic-Warfare/issues/189) | A ready signal (`crowsEW_main_ready`), so scripts know when the jammer events are handled | dropped: a maintainer said `CBA_missionTime > 0` is enough, PR [#193](https://github.com/Crowdedlight/Crows-Electronic-Warfare/pull/193) closed |
| Crow's EW | [#190](https://github.com/Crowdedlight/Crows-Electronic-Warfare/issues/190) | Events `jammerAdded`, `jammerRemoved` and `jammerToggled` | accepted, as local events without JIP replay. PR [#192](https://github.com/Crowdedlight/Crows-Electronic-Warfare/pull/192) open |
| Crow's EW | [#191](https://github.com/Crowdedlight/Crows-Electronic-Warfare/issues/191) | Option (`crowsEW_main_hideActions`) to hide the (de)activate actions of a jammer | accepted, as a variable checked in the action condition. PR [#195](https://github.com/Crowdedlight/Crows-Electronic-Warfare/pull/195) open |
| Advanced Equipment | [#444](https://github.com/y0014984/Advanced-Equipment/issues/444) | One `AE3_network_fnc_canConnect` check for every connection path, with conditions other mods can add | shipped in [2.1.0.5](https://github.com/y0014984/Advanced-Equipment/releases/tag/2.1.0.5) (`canConnect`, `addConnectCondition`), unchanged in [2.1.0.7](https://github.com/y0014984/Advanced-Equipment/releases/tag/2.1.0.7). Used by PR #73. Issue open: report back once PR #73 is tested in game |
| Advanced Equipment | [#445](https://github.com/y0014984/Advanced-Equipment/issues/445) | Public effective wireless range with modifiers, and documented getters for routers and clients | shipped in [2.1.0.5](https://github.com/y0014984/Advanced-Equipment/releases/tag/2.1.0.5) (`getWirelessRange`, `addRangeModifier`, `getRouters`, `getClients`), unchanged in [2.1.0.7](https://github.com/y0014984/Advanced-Equipment/releases/tag/2.1.0.7). Used by PR #73. Issue open: report back once PR #73 is tested in game |

All five offered a PR for whichever shape the maintainers prefer. Related Crow's issues: #130 (the compat idea behind this repo, closed), #133 (the early `addJammer` race), #168 (a generic EMP event, open and accepted in principle).

What we remove when they land:

- #189: nothing, it was dropped. The `CBA_missionTime > 0` waits in `bft_jamming` `fnc_registerBftJammer`, `ewc_common_fnc_setJammer`, the R-142N `fnc_initVehicle` and the wait for the Spectrum signals in `compat_cup_drones` stay.
- #190: the full scans in `bft_jamming` `fnc_onUpdateJammersServer` and `ewc_common_fnc_removeCrowsActions`.
- #191: `ewc_common_fnc_clearCrowsActions`, `fnc_removeCrowsActions` and the direct clean-up for hosted servers in `fnc_addJammer`.
- #444 and #445: done in `wifi_jamming` (PR #73). It uses the connect condition API instead of its own polling loop, and `AE3_network_fnc_getRouters` / `getClients` instead of the private variables `AE3_cap_isRouter` and `AE3_network_parent`. `addRangeModifier` is not used: AE3 checks the range before the connect conditions, so a jammed laptop would show "Out of range" instead of "Jammed" and `connectionJammed` would lose its hook. Close both issues upstream after the in-game test.

## Parked (not filed yet)

File these after the first batch has had a reaction: if the maintainers answer and merge, the next ones are worth the effort, and the answers show which shape they like.

### Crow's Electronic Warfare

1. **Change the radii or capabilities of a jammer in place.**
    - Today: `ewc_common_fnc_setJammer` removes and adds the jammer again. That is two broadcasts of the whole map, new actions and new Spectrum signals, for every DUKE, Hummel, R-142N and USAF DUKE whose range changes.
    - Request: an event `crowsEW_main_updateJammer` with `[netId, falloff radius, effective radius, capabilities]`.
2. **Spectrum signals for custom capabilities.**
    - Today: `toggleJammerServer` only re-adds signals for the radio (30 MHz) and drone (433 MHz) capabilities, so `bft_jamming` `fnc_onUpdateJammersServer` (and `wifi_jamming`) reconcile their own signal on every update.
    - Request: a frequency and signal type per capability, in the `addJammer` payload or a registry.
3. **Public jam strength.**
    - Today: the same two-radius falloff is written again in `bft_jamming` `fnc_calcBftJamStrength`, `wifi_jamming` `fnc_calcJamStrength` and `ewc_common_fnc_debugDraw`.
    - Request: a public function `[unit, capability] → strength`, and optionally an event when the jam state of a unit changes.

### Advanced Equipment

1. **Connect and disconnect events with a reason.**
    - Today: only internal commands (`ae3_network_connectDevice`, `ae3_network_disconnectDevice`) and the payload-less UI refresh `ae3_desktop_sysChanged`. `wifi_jamming` raises its own `connectionJammed`.
    - Request: `ae3_network_connected` and `ae3_network_disconnected` with `[device, router, reason]`, reasons such as range, router off, user.
2. **A power state event.**
    - Today: since 2.1.0.5 there is the getter `AE3_power_fnc_isPoweredOn`, but no event, so a change can only be polled.
    - Request: `[device, old state, new state]`. That would allow a jammer that only runs while powered, without polling.

### cTab

1. **A draw-time override for BFT positions.**
    - Today: in `bft_mode` 1 (realtime, the default) `drawBftMarkers` reads `getPosASL` live and ignores the entry, so the drift and blackout of `bft_jamming` only work when a mission forces mode 2.
    - Request: a variable on the object, or a filter function, that is honoured at draw time in every mode.
2. **Virtual contacts.**
    - Today: list entries need an object at index 0, so Spoof inserts invisible `Sign_Sphere10cm_F` objects as ghosts.
    - Request: entries that are a position only, or `cTab_fnc_addVirtualContact`.
3. Background: Crow's #184 (jammable BFT) is where this started. Crow's cannot override the GPS, which is why `bft_jamming` works on the cTab lists.

### ACE3

1. **Make the advanced fatigue duty factor functions public.**
    - Today: `ace_advanced_fatigue_fnc_addDutyFactor` and `removeDutyFactor` are marked "Public: No" and `rf_exposure` (PR #74) depends on them.
    - Request: mark them public and document them.
2. **A public pain getter.**
    - Today: `rf_exposure` reads the variable `ace_medical_pain`, because only `adjustPainLevel` is public.
    - Request: `ace_medical_fnc_getPain`.

## How we file

- Describe the problem first, name the workaround we have now, then the smallest proposal that is backwards compatible.
- One topic per issue, and use the repo's own template where there is one (AE3 has one, Crow's does not).
- Offer a PR. Do not file until the earlier batch has been answered or a few weeks have passed.
