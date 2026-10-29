# Test missions

Multiplayer missions on the VR map to test the compats by hand. Crow's Electronic Warfare does not work in singleplayer, so host them on LAN (or from the editor with *Play in Multiplayer*).

| Mission | Mods besides CBA, Crow's, ACRE | Tests |
|---|---|---|
| `EWC_Test_BWA3.VR` | BWmod | Dingo 2 CG13 |
| `EWC_Test_RHS_USAF.VR` | RHS USAF | DUKE, Boomerang |
| `EWC_Test_RHS_AFRF.VR` | RHS AFRF | GAZ-66 (R-142N) |
| `EWC_Test_CUP.VR` | CUP Vehicles | DUKE, Boomerang |

Each mission spawns one vehicle per model of the covered class family (found in the loaded configs) at `[0,0]`, a **jam lane** 150 m north with IEDs 20 to 130 m east of the parking spot and radio signs 20 to 130 m west of it. Labels show the state of each system, and an IED label turns red while it is jammed. The RHS AFRF mission has no IEDs, as the R-142N does not jam them: it has radio signs and drones up to 1250 m from the lane spot. The CUP and RHS USAF missions also have a **Boomerang range** with a hostile and a friendly shooter.

`hemtt launch bwa3`, `hemtt launch rhs_usaf`, `hemtt launch rhs_afrf` and `hemtt launch cup` open the matching mission in the editor. Use *Play in Multiplayer* there. The folders can also be copied to `Documents\Arma 3 - Other Profiles\<profile>\mpmissions`.
