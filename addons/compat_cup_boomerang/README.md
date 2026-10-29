# Compat CUP Boomerang

CUP models a Boomerang shot finder on some of its vehicles (HMMWV, MATV and RG-31 families) but gives it no function. This addon makes it work. It has little code of its own: it adds the animation sources of the antenna to the registry of `compat_boomerang`, which provides the whole function (switch, shot detection, hints, markers), and keeps the Boomerang and the DUKE of `compat_cup_duke` from running at the same time.

## How it works

- `CfgEWC.hpp` adds the entry `CUP` with `sources[] = {"hide_antenna_boomerang", "SYS_boomerang"}` to `CfgEWC >> Boomerangs` (`hide_antenna_boomerang` on the M1151 and M1240, `SYS_boomerang` on the RG-31). The antenna is shown at phase 0 and hidden at phase 1, CUP hides it by default. `compat_boomerang` finds the vehicles with these sources, see its [README](../compat_boomerang/README.md).
- The DUKE and the Boomerang exclude each other. `XEH_postInit.sqf` forwards the event `ewc_compat_boomerang_switchedOn` of `compat_boomerang` as `ewc_compat_cup_systemOn` (system `boomerang`), which the DUKE listens to and switches off. In the other direction it listens to `ewc_compat_cup_systemOn` of the DUKE and switches the Boomerang off (`ewc_compat_boomerang_fnc_setState`). Both run on the server.

## Settings

The settings are the ones of `compat_boomerang`, shared with RHS USAF. The switch for the DUKE (`compat_cup`) does not apply to the Boomerang.

## Dependencies

- [Compat Boomerang](../compat_boomerang/README.md)
- `compat_cup` and [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)

## Maintainer

- Andx
