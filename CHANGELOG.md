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

- Compat CUP cTab - Show the shots a CUP Boomerang detects as red enemy markers on cTab, for the side of the vehicle. New addon, only loaded with cTab
- Compat CUP - Add the setting *Show shots on* (map, cTab or both) for the shots of the Boomerang
- Compat RHS - Add setting to disable the DUKE jammer
- Compat BWA3 - Add setting to disable the CG13 jammer

### Changed

- Main - Add a registry of jammer vehicles (`CfgEWC >> Jammers`) that registers them in Crow's EW without code, with shared `addJammer` and `clearCrowsActions` functions. Compat RHS and BWA3 now only hold their entry and vehicle specific handlers, Compat CUP uses the shared functions
- Settings - Move CBA settings into an `initSettings.inc.sqf` per addon
- Compat CUP - Use the accuracy of the vehicle Boomerang from the manufacturer data sheet (bearing 2.5°, range 10 %, up to 97 km/h) instead of the figures of the dismounted variant, and a default detection distance of 30 m

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
