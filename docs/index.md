# EW Compats

**EW Compats** (EWC) connects other mods to [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728), so their jammers and jamming effects work with its radio and spectrum systems.

The project is entirely open-source and any contributions are welcome.

!!! info "Requirements"
    EW Compats requires [CBA_A3](https://github.com/CBATeam/CBA_A3/releases/latest) and Crow's Electronic Warfare. Every addon below is skipped when the mod it extends is not loaded. Crow's Electronic Warfare is needed by every addon except the two Boomerang addons.

## Addons

| Addon | Extends | What it does |
|---|---|---|
| [BFT Jamming](bft-jamming.md) | [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) | Editor module that turns an object into a jammer for cTab's Blue Force Tracker |
| [Compat BWA3](compat-bwa3.md) | [BWmod](https://steamcommunity.com/sharedfiles/filedetails/?id=1200127537) | The Dingo 2 CG13 also jams radios |
| [Compat CUP](compat-cup.md) | [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371) | Shared base of the two CUP addons below: finds the vehicles with a DUKE or Boomerang antenna and provides the switch |
| [Compat CUP DUKE](compat-cup-duke.md) | [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371) | Vehicles with a shown DUKE antenna get a DUKE switch that jams radios and IEDs |
| [Compat Boomerang](compat-boomerang.md) | [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371), [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117) | Common core of the Boomerang shot finder of CUP (HMMWV, RG-31) and RHS USAF (M1245 SOCOM): a switch for shot detection with hints and markers on the map and, with cTab, on the tablets. Does not need Crow's Electronic Warfare |
| [Compat RHS USAF DUKE](compat-rhs-usaf.md) | [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117) | Vehicles with a DUKE also jam radios |
| [Compat RHS AFRF](compat-rhs-afrf.md) | [RHS AFRF](https://steamcommunity.com/sharedfiles/filedetails/?id=843425103) | The GAZ-66 (R-142N) jams radios and drones with its mast deployed |
