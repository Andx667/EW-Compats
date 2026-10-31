# EW Compats

<p align="center">
    <img src="https://github.com/Andx667/EW-Compats/blob/main/img/logo.png" alt="EW Compats Logo">
</p>

<p align="center">
    <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=3828821912">
        <img src="https://img.shields.io/badge/Steam-Workshop-171a21?style=flat-square&logo=steam" alt="EW Compats on Steam Workshop">
    </a>
    <a href="https://andx667.github.io/EW-Compats/">
        <img src="https://img.shields.io/badge/Docs-MkDocs-526cfe?style=flat-square&logo=materialformkdocs&logoColor=white" alt="EW Compats Documentation">
    </a>
    <a href="https://github.com/Andx667/EW-Compats/issues">
        <img src="https://img.shields.io/github/issues-raw/Andx667/EW-Compats.svg?style=flat-square&label=Issues" alt="EW Compats Issues">
    </a>
    <a href="https://github.com/Andx667/EW-Compats/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-MIT-blue?style=flat-square" alt="EW Compats License">
    </a>
    <br>
    <img src="https://img.shields.io/github/actions/workflow/status/Andx667/EW-Compats/check.yml?style=flat-square&label=Check" alt="Check">
    <img src="https://img.shields.io/github/actions/workflow/status/Andx667/EW-Compats/validate.yml?style=flat-square&label=Validate" alt="Validate">
</p>

__Requires__ [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997) ([GitHub](https://github.com/CBATeam/CBA_A3)) and [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728) (not needed for the Boomerang of CUP and RHS USAF).

__EW Compats__ (EWC) connects other mods to Crow's Electronic Warfare, so their jammers and jamming effects work with its radio and spectrum systems.

The project is entirely __open-source__ and any contributions are welcome.

Steam Workshop: <https://steamcommunity.com/sharedfiles/filedetails/?id=3828821912>

Documentation: <https://andx667.github.io/EW-Compats/>

Discord: <https://discord.gg/ag4v6kxYAa>

## Features

Every feature is its own addon and is skipped when the mod it extends is not loaded.

| Addon | Extends | What it does |
|---|---|---|
| [`bft_jamming`](./addons/bft_jamming/README.md) | [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) | Editor module that turns an object into a jammer for cTab's Blue Force Tracker (blackout, position drift or both) |
| [`compat_bwa3`](./addons/compat_bwa3/README.md) | [BWmod](https://steamcommunity.com/sharedfiles/filedetails/?id=1200127537) | The Dingo 2 CG13 also jams radios while its IED jammer is switched on |
| [`compat_cup`](./addons/compat_cup/README.md) | [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371) | Shared base of the CUP sub-addons `compat_cup_duke` and `compat_cup_boomerang` below: finds the vehicles with a DUKE or Boomerang antenna and provides the switch (scroll wheel or ACE) and its settings |
| [`compat_cup_duke`](./addons/compat_cup/compat_cup_duke/README.md) | [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371) | Vehicles with a shown DUKE antenna get a DUKE switch that jams radios and IEDs |
| [`boomerang`](./addons/boomerang/README.md) | [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371), [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117) | Common core of the Boomerang shot finder: a switch for shot detection with hints and markers on the map and, with cTab, on the tablets. Does not need Crow's Electronic Warfare |
| [`compat_cup_boomerang`](./addons/compat_cup/compat_cup_boomerang/README.md) | [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371) | Gives the Boomerang to the HMMWV and RG-31 vehicles with the antenna and keeps it from running together with the DUKE |
| [`compat_rhs_usaf`](./addons/compat_rhs_usaf/README.md) | [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117) | Parent of the RHS USAF sub-addons `compat_rhs_usaf_duke` and `compat_rhs_usaf_boomerang` |
| [`compat_rhs_usaf_duke`](./addons/compat_rhs_usaf/compat_rhs_usaf_duke/README.md) | [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117) | Vehicles with a DUKE also jam radios while the DUKE is online |
| [`compat_rhs_usaf_boomerang`](./addons/compat_rhs_usaf/compat_rhs_usaf_boomerang/README.md) | [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117) | Gives the Boomerang to the M1245 SOCOM vehicles |
| [`compat_rhs_afrf`](./addons/compat_rhs_afrf/README.md) | [RHS AFRF](https://steamcommunity.com/sharedfiles/filedetails/?id=843425103) | The GAZ-66 (R-142N) jams radios and drones while its mast is deployed |

Radio jamming needs [ACRE](https://steamcommunity.com/sharedfiles/filedetails/?id=751965892) (the radio effect of Crow's Electronic Warfare is applied to the receiving side). Crow's Electronic Warfare only works in multiplayer.

## Contributing

For new contributors, see the [Contributing Setup & Guidelines](./.github/CONTRIBUTING.md).

## License

EW Compats is licensed under [MIT](./LICENSE).
