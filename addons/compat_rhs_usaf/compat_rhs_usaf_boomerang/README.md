# Compat RHS USAF Boomerang

The M1245 SOCOM vehicles of RHS USAF (`rhsusf_m1245_m2crows_socom_d`, `rhsusf_m1245_mk19crows_socom_d` and their `_deploy` variants) model a Boomerang shot finder but give it no function. This addon makes it work. It has no code of its own: it adds the animation source of the antenna to the registry of `boomerang`, which provides the whole function (switch, shot detection, hints, markers).

## How it works

- RHS defines the antenna as the animation source `hide_boomerang` in `rhsusf_MATV_SOF_CROWS_base`, the base class of the four vehicles. It is shown at phase 0 and hidden at phase 1, RHS hides it by default (*hide shot finder* in the vehicle appearance options).
- `CfgEWC.hpp` adds the entry `RHS_USAF` with `sources[] = {"hide_boomerang"}` to `CfgEWC >> Boomerangs`. `boomerang` reads the registry once and finds the vehicles with these sources, see its [README](../../boomerang/README.md).

## Settings

The settings are the ones of `boomerang`.

## Dependencies

- [Boomerang](../../boomerang/README.md)
- [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117) (`rhsusf_c_matv`)

## Maintainer

- Andx
