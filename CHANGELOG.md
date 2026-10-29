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
