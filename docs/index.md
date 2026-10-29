# EW Compats

**EW Compats** (EWC) connects other mods to [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728), so their jammers and jamming effects work with its radio and spectrum systems.

The project is entirely open-source and any contributions are welcome.

!!! info "Requirements"
    EW Compats requires [CBA_A3](https://github.com/CBATeam/CBA_A3/releases/latest) and Crow's Electronic Warfare. Every addon below is skipped when the mod it extends is not loaded.

## Addons

| Addon | Extends | What it does |
|---|---|---|
| [BFT Jamming](bft-jamming.md) | [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) | Editor module that turns an object into a jammer for cTab's Blue Force Tracker |
| [Compat BWA3](compat-bwa3.md) | [BWmod](https://steamcommunity.com/sharedfiles/filedetails/?id=1200127537) | The Dingo 2 CG13 also jams radios |
| [Compat CUP](compat-cup.md) | [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371) | Vehicles with a shown DUKE antenna get a DUKE switch that jams radios and IEDs, and ones with a Boomerang shot finder get shot detection with hints and map markers |
| [Compat RHS](compat-rhs.md) | [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117) | Vehicles with a DUKE also jam radios |

## Planned

- RHS AFRF jammer vehicles
- Jammers of the compat addons (DUKE, CG13) also jamming cTab's Blue Force Tracker
- Boomerang shot reports shared on cTab
- Zeus actions for the compat vehicles (force jammer on or off, override radius)
