# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- TEMPLATE: `hemtt publish` looks up the entry whose heading exactly
matches the current project version (see .hemtt/project.toml's
[version] / addons/main/script_version.hpp) -- so before publishing,
rename "[Unreleased]" below to "[X.Y.Z] - YYYY-MM-DD" matching that
version, and start a fresh empty [Unreleased] section above it. -->

## [Unreleased]

### Added

- BFT Jamming - New jamming type **Spoof**: a viewer inside the effective radius sees ghosts on the BFT, copies of some of the groups and vehicles of their own list on a position 150 to 400 m from the original that move with it, with the callsign of a random existing group or vehicle. The real units drift in the whole range like with Drift, the ghosts are on top of that inside the effective radius. Ghosts are worked out on every client from the net IDs, so nothing is synced, and they only end with the jammer or when the viewer leaves the radius. The jammer shows in the Spectrum Device like the other types. Setting `ewc_bft_jamming_ghostRatio` (default 33 %). The debug overlay draws a line from a ghost to the unit it copies
- Common - Debug overlay, switched on by the client setting `ewc_common_debug` (default off). It draws the jammer and switch state over every supported vehicle with rings for the radii of an active jammer, the jammed state over IEDs within the full radius of an active jammer, and the jam strength per signal (radio, BFT, drone) over units and drones in range. Addons add lines with the new `ewc_common_fnc_registerDebug`, used by the Boomerang

### Changed

- Common, Compat CUP, Compat BWA3, Compat RHS AFRF, Compat RHS USAF, Compat RnT - A vehicle is registered as a jammer in Crow's Electronic Warfare when its jammer is switched on for the first time, not when the vehicle is created. Every registration makes Crow's send its whole jammer list to every machine and every client walked the actions of all jammers after it, so a mission with many DUKE, CG13, R-142N or Hummel vehicles stalled at the start. `ewc_common_fnc_setJammer` registers the vehicle and the compat addons no longer need a registered vehicle for their checks (`ewc_common_jammerState` is only set once registered). The CG13 uses `fnc_setJammer` instead of `crowsEW_main_toggleJammer`. `ewc_compat_cup_duke_fnc_registerJammer` is gone. A vehicle that was never switched on is not in the jammer list of Crow's Electronic Warfare (Zeus markers, the debug rings)
- Common, Compat CUP - Removing the (de)activate actions of Crow's Electronic Warfare only looks at the jammers that are new to a machine, instead of walking the actions of all jammers on every update of the jammer list. The jammers of `ewc_common` carry the public variable `ewc_common_isJammer`, so the one handler covers the CUP DUKE vehicles too and `ewc_compat_cup_duke_fnc_removeCrowsActions` is gone
- Boomerang - The setting `ewc_boomerang_markerLifetime` is a global setting now (set by the server). The map markers used the value of each player and the cTab markers the one of the server, so the two could disagree

### Fixed

- BFT Jamming - **Remove BFT Jammer** in Zeus refused a Spoof jammer with the message that the object is no BFT jammer
- Compat RHS AFRF, Compat CUP - The wait for the registration of a vehicle (R-142N) or for Crow's Electronic Warfare (CUP drones) ends when the vehicle is deleted, and after a timeout. It was checked every frame for the rest of the mission before

## [1.4.0] - 2026-11-01

### Fixed

- Compat RHS USAF - A DUKE that is on is switched off when its antenna is hidden, and its weapon goes with it. RHS only took the weapon of a switched off DUKE away, so with the antenna hidden the driver could still switch a running DUKE off and on again. The addon replaces `rhs_fnc_duke_vg` (`CfgFunctions`) and `fnc_syncJammer` treats a hidden antenna as a reason to be off, with the hint *antenna hidden*

### Added

- Compat RHS USAF - Give the Stryker family (M1126, M1127, M1132, M1134) the RHS DUKE weapon, as RHS shows a DUKE antenna on them but no DUKE. They jam IEDs and radios like the other DUKE vehicles. The driver switches it, the M1127 and M1134 get the weapon when the antenna is shown. The antenna has no hitpoints, so it cannot be destroyed
- Compat CUP - New sub-addon `compat_cup_drones`: the CUP MQ-9 and Pchela-1T get the spectrum signal Crow's Electronic Warfare gives its own drones, so drone jammers jam them and the spectrum device shows them. Crow's lists only the vanilla drone bases, and the CUP drones derive from the plain `UAV` class. Settings `ewc_compat_cup_drones_enable` and `ewc_compat_cup_drones_range`
- BFT Jamming - Zeus modules **Set as BFT Jammer** (with a dialog for the type, the radii, the frequency and whether it starts on) and **Remove BFT Jammer**, in the category of Crow's Electronic Warfare. The module of the editor and the one of Zeus register the jammer through the new `fnc_registerBftJammer`. The spectrum frequency of a jammer is a public variable now, as the jammer can come from a Zeus machine
- Compat RnT Vehicles - New addon `compat_rnt`: the Fuchs 1A4 Hummel (`EWC_RnT_Fuchs_1A4_Hummel_*`), a Jäger variant of the Redd'n'Tank Fuchs that jams ACRE radios while it is switched on, modelled on the Störpanzer Hummel of the Bundeswehr. Switch by scroll wheel or ACE, off with the engine. Settings `ewc_compat_rnt_enable` and `ewc_compat_rnt_radius`
- Common - `ewc_common_fnc_registerSwitch`, `fnc_addSwitchActions`, `fnc_addAceSwitchActions`, `fnc_canOperate` and `fnc_canToggle`: the switch actions of the DUKE and the Boomerang, now shared. `ewc_common_fnc_setJammer` brings a jammer in line with a wanted state and replaces it for another radius or other capabilities

### Changed

- Common, Boomerang, Compat CUP - The setting how the crew switches a system is `ewc_common_actionMode` now, instead of `ewc_boomerang_actionMode` and `ewc_compat_cup_actionMode`. The saved values of the old settings are not taken over. The functions `fnc_addActions`, `fnc_addAceActions`, `fnc_canOperate` and `fnc_canToggle` of `boomerang` and `compat_cup` are gone, they are in `ewc_common`
- Compat CUP, Compat RHS USAF, Compat RHS AFRF - The DUKEs and the R-142N replace or switch their Crow's Electronic Warfare jammer with `ewc_common_fnc_setJammer` instead of a copy of the code each

## [1.3.0] - 2026-11-01

### Changed

- Compat CUP, Compat RHS USAF - The addons `compat_cup_duke`, `compat_cup_boomerang`, `compat_rhs_usaf_boomerang` and the DUKE of `compat_rhs_usaf` are sub-addons now, as in ACE: folders `compat_cup_duke`, `compat_cup_boomerang`, `compat_rhs_usaf_duke` and `compat_rhs_usaf_boomerang` of `compat_cup` and `compat_rhs_usaf`, each with a `config.cpp` of its own, so a mod has one PBO. The patch names stay (`ewc_compat_cup_duke`...), and a sub-addon is still skipped alone when its dependencies are missing. The functions are named `ewc_compat_cup_fnc_duke_*` and `ewc_compat_rhs_usaf_fnc_duke_*` instead of `ewc_compat_cup_duke_fnc_*`. Settings, variables and events keep their names
- Boomerang - Rename the addon `compat_boomerang` to `boomerang`, as it is the Boomerang itself and the compat is in `compat_cup_boomerang` and `compat_rhs_usaf_boomerang`. The patch is `ewc_boomerang`, the functions, variables, events, settings and strings are named `ewc_boomerang_*` instead of `ewc_compat_boomerang_*`, so the saved values of its settings are not taken over. The cTab sub-addon is the folder `boomerang_ctab`

## [1.2.0] - 2026-10-29

### Fixed

- Compat RHS USAF - Free the IEDs of a vehicle that is destroyed with the DUKE on, and stop the DUKE script of RHS
- Main - Register the jammer vehicles also while their compat addon is disabled in the settings, which keep them off. Switching a setting on during the mission was without effect for those vehicles

### Changed

- Common - Move the functions, the registry `CfgEWC >> Jammers`, the event handlers and the state hint strings of `ewc_main` into the new addon `ewc_common`. `ewc_main` keeps the structure (mod entry, macros, version, name). The functions, variables, events and strings are now named `ewc_common_*` instead of `ewc_main_*` (for example `ewc_common_fnc_addJammer`, `ewc_common_jammerState`, `ewc_common_vehicleInit`), and the compat addons require `ewc_common`. Other addons that use them have to be changed
- Compat Boomerang - The setting *Show shots on* is now *Show shots* (nothing, map or cTab) and is part of Compat Boomerang. cTab is only offered when it is loaded. The option for both is gone, and the saved value of the old setting is not taken over
- Compat RHS USAF - Leave only the IEDs another running RHS DUKE holds when a DUKE goes offline, as no two of the supported mods run together

### Removed

- Compat CUP, Compat Boomerang - Remove the setting *Require running engine*, the DUKE and the Boomerang always need a running engine
- Main - Remove `enableVariable` from the entries of `CfgEWC >> Jammers`

## [1.1.0] - 2026-10-29

### Fixed

- Compat RHS USAF - Free the IEDs around a vehicle from the server when its DUKE goes offline. RHS did it on the machine of the gunner, which does not work for IEDs that are not local there, so they stayed disabled on a dedicated server
- Compat BWA3 - Keep the CG13 on when the driver of the Dingo gets out. It was switched off because the engine stops, while an eject left it on. The engine now keeps running without a driver as long as the CG13 is on
- Main - Remove the activate and deactivate actions of Crow's EW from the jammer vehicles on every client, not only after the next update. They stayed on DUKE and CG13 vehicles of a client until the next jammer change

### Added

- Compat CUP - Add the server setting *Allow DUKE and Boomerang together* (default off). When on, a CUP vehicle with both antennas can run the DUKE and the Boomerang at the same time
- Compat RHS USAF Boomerang - Add the Boomerang shot finder to the RHS USAF M1245 SOCOM vehicles (`hide_boomerang`), with the same function as the CUP Boomerang. Does not need Crow's Electronic Warfare
- Compat Boomerang - Registry `CfgEWC >> Boomerangs` with the animation sources of the antenna, so a compat addon only has to list them
- Compat Boomerang - Show a silent hint to the crew when the Boomerang goes deaf after the own fire of the vehicle, and when it listens again

### Changed

- Compat Boomerang - Move the Boomerang of `compat_cup_boomerang` into the common addon `compat_boomerang`, shared by CUP and RHS USAF. `compat_cup_boomerang` and `compat_rhs_usaf_boomerang` only register their vehicles. The Boomerang has its own switch setting (*Boomerang switch*) and engine requirement, and one set of settings, variables and events for both mods (`ewc_compat_cup_boomerang_*` became `ewc_compat_boomerang_*`), so saved values of the old Boomerang settings are not taken over
- Compat CUP - The switch setting and the engine requirement of `compat_cup` are for the DUKE only again, the label of the setting is *DUKE switch* (the Boomerang has its own)

## [1.0.0] - 2026-10-29

### Added

- Main - Show a silent hint to the people in a vehicle when the DUKE, the CG13 or the Boomerang is switched on or off, with the reason when it switches itself off (engine stopped, antenna hidden, antennas destroyed, disabled in the settings)
- Compat CUP - Show the shots a CUP Boomerang detects as red enemy markers on cTab, for the side of the vehicle. A sub-addon (folder `ctab`) with its own config, only loaded with cTab
- Compat CUP - Add the setting *Show shots on* (map, cTab or both) for the shots of the Boomerang, only there when cTab is loaded
- Compat CUP - A shot of a Boomerang close to the marker of an earlier shot (50 m, or 20 % of the range if more) does not add a marker on the map or on cTab, it keeps that marker longer
- Compat RHS AFRF - Add the GAZ-66 (R-142N) as a broad spectrum jammer for radios and drones, switched by deploying and folding its mast, with settings for the radius and the jammed signals
- Compat RHS USAF - Add setting to disable the DUKE jammer
- Main - `ewc_main_fnc_addJammer` takes optional Crow's capabilities, to override those of the registry entry
- Compat BWA3 - Add setting to disable the CG13 jammer

### Changed

- Compat CUP - Rename the displayed name of the setting *DUKE switch* to *System switch*, as it switches the Boomerang too. The setting itself (`ewc_compat_cup_actionMode`) is unchanged
- Main - Use a generic mod description instead of a list of the supported vehicles
- Compat RHS - Rename `compat_rhs` to `compat_rhs_usaf` (it only extends RHS USAF) and add `compat_rhs_afrf` for RHS AFRF, so each loads with only the RHS mod it needs. The setting `ewc_compat_rhs_enableDuke` is now `ewc_compat_rhs_usaf_enableDuke`, so a saved value is not taken over
- Compat CUP - Remove the settings for the detection distance and the lockout after own fire of the Boomerang, they are fixed values from the data sheet (30 m, 5 s)
- Main - Add a registry of jammer vehicles (`CfgEWC >> Jammers`) that registers them in Crow's EW without code, with shared `addJammer` and `clearCrowsActions` functions. Compat RHS and BWA3 now only hold their entry and vehicle specific handlers, Compat CUP uses the shared functions
- Compat CUP - Split into the shared base `compat_cup` and the addons `compat_cup_duke` and `compat_cup_boomerang`. The Boomerang no longer needs Crow's Electronic Warfare. Their CBA settings, public variables and events are renamed with the addon prefix (for example `ewc_compat_cup_duke_enable`, `ewc_compat_cup_boomerang_enable`), so saved values of the old settings are not taken over
- Settings - Move CBA settings into an `initSettings.inc.sqf` per addon
- Compat CUP - Use the accuracy of the vehicle Boomerang from the manufacturer data sheet (bearing 2.5°, range 10 %, up to 97 km/h) instead of the figures of the dismounted variant, and a default detection distance of 30 m

### Fixed

- Compat CUP DUKE - Jam the IEDs of CUP (`CUP_IED_V1_Ammo` to `V4`), which were ignored because they are no `PipeBombBase`

## [0.2.0] - 2026-10-28

### Added

- Localization - Add French, Spanish, Polish and Russian translations of all strings, German for the mod name and a localized mod description
- Compat CUP - Add Boomerang shot finder for CUP vehicles that reports shots near the vehicle with a hint and map markers, excludes the DUKE, is deaf after its own fire and works up to 95 km/h
- Compat CUP - Add settings to disable the DUKE and the Boomerang
- Compat CUP - Add DUKE switch (scroll wheel or ACE) for CUP vehicles with a shown DUKE antenna, jamming radios via Crow's EW and IEDs

### Changed

- Compat CUP - Only offer the DUKE and Boomerang switches to driver, commander and gunners, not to passengers
- Compat CUP - Show each piece of the Boomerang shot hint on its own line

## [0.1.0] - 2026-10-28

### Added

- BFT Jamming - Add editor module that jams cTab's Blue Force Tracker (blackout, drift, mixed) as Crow's EW jammer
- Compat BWA3 - Add Crow's EW radio jammer to the Dingo 2 CG13, driven by its existing switch
- Compat RHS - Add Crow's EW radio jammer to vehicles with a DUKE, including antenna damage
- Mod logo and icon for the launcher and main menu
