# Compat RHS

Vehicles with a **DUKE** (M1117, HMMWV family, MATV, M1A1/M1A2 and others) also jam ACRE radios, in addition to IEDs. The radio jammer follows the DUKE switch of RHS.

## Range

| State | Effective | Falloff band | Outer edge |
|---|---|---|---|
| Both antennas intact | **50 m** | 75 m | **125 m** |
| One antenna destroyed | **30 m** (60 %) | 45 m | **75 m** |
| Both antennas destroyed | off | off | off |
| DUKE switched off | off | off | off |

The 50 m is the IED jammer radius hardcoded in RHS. The falloff band is 1.5 times the effective radius. The 60 % for one antenna matches `rhs_duke.sqf`.

## Quirks

- **Operated through the weapon.** RHS toggles the DUKE with a pseudo weapon (`rhsusf_weap_duke`). The addon reads the result 0.5 s after the shot, because RHS only sets `RHS_DUKE_OP` in a spawned script.
- **A destroyed antenna changes the range.** Crow's Electronic Warfare cannot change the radii of a jammer, so the jammer is removed and registered again with the new range. Hits within the delay are merged into one sync.
- **Locality matters.** RHS only starts its jamming script if gunner and vehicle are local on the same machine, for example not for a gunner in the turret of someone else's vehicle. Then `RHS_DUKE_OP` does not change and the radio jammer stays off, like the IED jammer.
- **Use the DUKE weapon, not Crow's actions.** Crow's own (de)activate actions are removed from DUKE vehicles, because they would desync the two.
- **Everybody in range is jammed**, including the own crew and allies.
- **Multiplayer only.**
- **CUP vehicles are not covered.** They only have a DUKE model without function, see [Compat CUP](compat-cup.md).

## Dependencies

- [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728)
