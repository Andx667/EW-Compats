# Test missions

Multiplayer missions on the VR map to test the compats by hand. Crow's Electronic Warfare does not work in singleplayer, so host them on LAN (or from the editor with *Play in Multiplayer*).

| Mission | Mods besides CBA, Crow's, ACRE | Tests |
|---|---|---|
| `EWC_Test_BWA3.VR` | BWmod | Dingo 2 CG13 |
| `EWC_Test_RHS_USAF.VR` | RHS USAF | DUKE, Boomerang |
| `EWC_Test_RHS_AFRF.VR` | RHS AFRF | GAZ-66 (R-142N) |
| `EWC_Test_CUP.VR` | CUP Vehicles | DUKE, Boomerang |
| `EWC_Test_BFT.VR` | cTab | BFT Jamming (Blackout, Drift, Mixed, Spoof) |

Each mission spawns a few vehicles of the covered class family (found in the loaded configs) at `[0,0]`: the BWA3 and RHS AFRF missions one vehicle, the CUP and RHS USAF missions one vehicle per category (the editor subcategory: cars, MRAPs, APCs, tanks...) and system, preferring a vehicle with both a DUKE and a Boomerang, a **jam lane** 150 m north with IEDs 20 to 130 m east of the parking spot and radio signs 20 to 130 m west of it. Each mission forces the setting `ewc_common_debug` on (`cba_settings.sqf`), so the debug overlay shows the state of each system and whether IEDs, units and drones in range are jammed. The mission labels only add the IED distances, the lane signs and the drone distances. The RHS AFRF mission has no IEDs, as the R-142N does not jam them: it has radio signs and drones up to 1250 m from the lane spot. The CUP and RHS USAF missions also have a **Boomerang range** with a hostile and a friendly shooter.

The **BFT mission** has no mod-specific vehicles, it needs cTab and uses vanilla units. Real units with cTab devices (infantry groups, an MRAP, a truck, an APC, a tank, a helicopter and a patrolling MRAP) stand around the parking spot in the center of the map (4096, 4096), a few more near the **Spoof** station. One jammer station of each type (Spoof 1 km north, Blackout 1.2 km west, Drift 1.2 km east, Mixed 1.2 km south, effective radius 200 m, falloff to 600 m) is switched on at the start, with scroll wheel actions to switch each one and to teleport. The mission forces `ctab_core_bft_mode` to `2`, which Drift needs. Ghosts of Spoof are copies of the real units: stand within 200 m of the Spoof terminal and compare the tablet with the blue *REAL* labels. The second player is in another group, so the first one sees them as a group that can have a ghost too.

`hemtt launch bft`, `hemtt launch bwa3`, `hemtt launch rhs_usaf`, `hemtt launch rhs_afrf` and `hemtt launch cup` open the matching mission in the editor. Use *Play in Multiplayer* there. The folders can also be copied to `Documents\Arma 3 - Other Profiles\<profile>\mpmissions`.
