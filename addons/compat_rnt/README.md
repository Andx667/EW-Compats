# Compat RnT Vehicles

Adds the **Fuchs 1A4 Hummel** to the Redd'n'Tank Vehicles: a jammer vehicle that jams ACRE radios while it is switched on. It is modelled on the Störpanzer Hummel of the Bundeswehr, a Fuchs variant that jams communications in VHF and UHF. It jams radios only, no drones.

## How it works

- Redd'n'Tank has no EloKa variant of its Fuchs 1A4 and no jammer antenna, so the Hummel is the Jäger variant with a new name (`CfgVehicles.hpp`): `EWC_RnT_Fuchs_1A4_Hummel_Flecktarn`, `_Tropentarn` and `_Wintertarn`. They have the model, textures and crew of the Jäger and look the same. They carry `ewc_compat_rnt_jammer = 1` and so are jammers of the registry in `ewc_common` (`CfgEWC >> Jammers >> RNT_HUMMEL`, radio only), which registers them once on the server as disabled jammers in Crow's Electronic Warfare.
- The crew switches the Hummel with the switch actions of `ewc_common` (scroll wheel or ACE self-interaction, driver, commander and gunners), see `ewc_common_actionMode`. The addon registers its switch with `ewc_common_fnc_registerSwitch` (id `hummel`).
- `fnc_handleToggle` (server) checks the request (`fnc_canActivate`: enabled in the settings, vehicle alive, engine running) and stores the state in the public variable `ewc_compat_rnt_on`. `fnc_syncJammer` (server) then brings the Crow's Electronic Warfare jammer in line with it through `ewc_common_fnc_setJammer`, with the radius of the settings, and tells the crew with the hint of `ewc_common_fnc_notifyState`.
- The Hummel switches itself off when the engine stops, the vehicle is destroyed or the setting turns it off. A switch that was blocked stays off when the engine starts again. The `Engine` and `Killed` event handlers (`fnc_initVehicle`, on every machine because they fire where the vehicle is local) raise the sync on the server.
- Crow's Electronic Warfare adds its own (de)activate actions to every jammer. They would change its state without the switch. `ewc_common` removes them from the vehicles of the registry.

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_initVehicle` | every machine | Class event handler for the Hummel: switch actions and the `Engine` and `Killed` handlers |
| `fnc_canActivate` | any | Can the Hummel be switched on |
| `fnc_getBlockReason` | any | Why it cannot be on (disabled, destroyed, engine stopped), or an empty text |
| `fnc_handleToggle` | server | Checks a switch request and stores the state |
| `fnc_syncJammer` | server | Matches the jammer to the switch and the vehicle: state, radius and hint |

## Settings

| Setting | Default | |
|---|---|---|
| Enable Hummel jamming | on | If off, the Hummel does not jam. Set by the server. A running Hummel switches off the next time the engine stops or it is switched |
| Hummel jamming radius (m) | 500 | Radius with full jamming strength, 100 to 2000 m. The falloff band beyond it is 1.5 times the radius. Set by the server, applied the next time the Hummel is switched on or off |

How the crew switches it is the setting `ewc_common_actionMode`.

## Limitations

- The Hummel looks like a Jäger. There is no roof antenna array, because the Redd'n'Tank Fuchs has none and this addon has no model.
- The range is a gameplay value. The data sheet of the Bundeswehr gives none.
- Everybody in range is jammed, including the own crew and allies. Crow's Electronic Warfare has no immunity apart from Zeus.
- Redd'n'Tank says its vehicles are made for co-op play and that some functions may not work with AI.
- Crow's Electronic Warfare only works in multiplayer.

## Dependencies

- [Redd'n'Tank Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=1128145626) (`Redd_Tank_Fuchs_1A4`)
- [Crow's Electronic Warfare](https://steamcommunity.com/sharedfiles/filedetails/?id=2515887728) (`crowsEW_main`)

## Maintainer

- Andx
