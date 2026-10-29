# EW Compats

<p align="center">
    <img src="https://github.com/Andx667/EW-Compats/blob/main/img/icon_512.png" alt="EW Compats Logo">
</p>

<p align="center">
    <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=3828821912">
        <img src="https://img.shields.io/badge/Steam-Workshop-171a21?style=flat-square&logo=steam" alt="EW Compats on Steam Workshop">
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

__Requires__ [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997) ([GitHub](https://github.com/CBATeam/CBA_A3)) and [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728).

__EW Compats__ (EWC) connects other mods to Crow's Electronic Warfare, so their jammers and jamming effects work with its radio and spectrum systems.

The project is entirely __open-source__ and any contributions are welcome.

Steam Workshop: <https://steamcommunity.com/sharedfiles/filedetails/?id=3828821912>

Discord: <https://discord.gg/ag4v6kxYAa>

## Features

Every feature is its own addon and is skipped when the mod it extends is not loaded.

| Addon | Extends | What it does |
|---|---|---|
| [`bft_jamming`](./addons/bft_jamming/README.md) | [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) | Editor module that turns an object into a jammer for cTab's Blue Force Tracker (blackout, position drift or both) |
| [`compat_bwa3`](./addons/compat_bwa3/README.md) | [BWmod](https://steamcommunity.com/sharedfiles/filedetails/?id=1200127537) | The Dingo 2 CG13 also jams radios while its IED jammer is switched on |
| [`compat_cup`](./addons/compat_cup/README.md) | [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371) | Vehicles with a shown DUKE antenna get a DUKE switch (scroll wheel or ACE) that jams radios and IEDs, and ones with a Boomerang shot finder get a switch for shot detection with hints and map markers |
| [`compat_rhs`](./addons/compat_rhs/README.md) | [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117) | Vehicles with a DUKE also jam radios while the DUKE is online |

Radio jamming needs [ACRE](https://steamcommunity.com/sharedfiles/filedetails/?id=751965892) (the radio effect of Crow's Electronic Warfare is applied to the receiving side). Crow's Electronic Warfare only works in multiplayer.

## Planned

- RHS AFRF jammer vehicles
- Jammers of the compat addons (DUKE, CG13) also jamming cTab's Blue Force Tracker
- Boomerang shot reports shared on cTab
- Zeus actions for the compat vehicles (force jammer on or off, override radius)

## Contributing

For new contributors, see the [Contributing Setup & Guidelines](./.github/CONTRIBUTING.md).

## License

EW Compats is licensed under [MIT](./LICENSE).
