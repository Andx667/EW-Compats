# Compat CUP

CUP models two systems on some of its vehicles and gives them no function: the **DUKE** antenna and the **Boomerang** shot finder. `compat_cup_duke` makes the DUKE work and builds on this addon, the Boomerang is the common `boomerang` with the CUP vehicles registered by `compat_cup_boomerang`. This addon has no function of its own and does not need Crow's Electronic Warfare.

## How it works

- CUP only models the DUKE. The antennas are animation sources that can be hidden, and there is nothing behind them, so the DUKE addon provides the whole function.
- A vehicle counts as equipped if its `AnimationSources` contain one of these (`fnc_getSources`):

  | System | Sources |
  |---|---|
  | DUKE | `hide_antenna_duke` (M1151), `hide_Duke_antenna` and `hide_crew_duke` (M1240), `hide_duke_antennas` (Abrams), `SYS_crewduke` (RG-31) |

  The sources of the Boomerang are in `compat_cup_boomerang`.
  Classes inherited from a parent are not listed as children, so every class up the inheritance chain is read. The result is cached per class, so no class list has to be kept.
- An antenna is shown at phase 0 and hidden at phase 1 (`animationSourcePhase`), see `fnc_getShown` and `fnc_isShown`.
- Crew can switch a system with a scroll wheel action, an ACE self-interaction or both (CBA setting `ewc_common_actionMode`). The actions are the switch actions of `ewc_common`. The DUKE addon registers its switch with `ewc_common_fnc_registerSwitch` in its preInit (id `duke`) and gives it:

  | Argument | Value of the DUKE |
  |---|---|
  | Public variable on the vehicle, the state of the system | `ewc_compat_cup_duke_on` |
  | Can the system be switched on, takes the vehicle | `ewc_compat_cup_fnc_duke_canActivate` |
  | Server event the actions send, with the vehicle and the wanted state | `ewc_compat_cup_duke_toggle` |
  | Titles of the actions | `STR_ewc_compat_cup_duke_activate` / `_deactivate` |
  | Does the vehicle have the system (ACE only) | `fnc_getSources` of this addon is not empty |

- The DUKE and the Boomerang exclude each other unless the server setting `ewc_compat_cup_allowBoth` is on. A system tells the other one with the local server event `ewc_compat_cup_systemOn` when it is switched on, and the other one switches off if it is loaded (`compat_cup_boomerang` passes the event to and from `boomerang`).

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_getSources` | any | Animation sources of a vehicle that belong to a system |
| `fnc_getShown` | any | The ones of them that are currently shown |
| `fnc_isShown` | any | Is at least one antenna of a system shown |

## Settings

| Setting | Default | |
|---|---|---|
| Allow DUKE and Boomerang together | off | Set by the server. Off: switching one system on switches the other off |

## Limitations

- The antenna list is the one of CUP's HMMWV, MATV, RG-31 and Abrams. Other vehicles with other source names are not covered.

## Dependencies

- [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- Optional: [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057) for the self-interaction

## Maintainer

- Andx
