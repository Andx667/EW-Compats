# Compat CUP

CUP models two systems on some of its vehicles and gives them no function: the **DUKE** antenna and the **Boomerang** shot finder. `compat_cup_duke` makes the DUKE work and builds on this addon, the Boomerang is the common `compat_boomerang` with the CUP vehicles registered by `compat_cup_boomerang`. This addon has no function of its own and does not need Crow's Electronic Warfare.

## How it works

- CUP only models the DUKE. The antennas are animation sources that can be hidden, and there is nothing behind them, so the DUKE addon provides the whole function.
- A vehicle counts as equipped if its `AnimationSources` contain one of these (`fnc_getSources`):

  | System | Sources |
  |---|---|
  | DUKE | `hide_antenna_duke` (M1151), `hide_Duke_antenna` and `hide_crew_duke` (M1240), `hide_duke_antennas` (Abrams), `SYS_crewduke` (RG-31) |

  The sources of the Boomerang are in `compat_cup_boomerang`.
  Classes inherited from a parent are not listed as children, so every class up the inheritance chain is read. The result is cached per class, so no class list has to be kept.
- An antenna is shown at phase 0 and hidden at phase 1 (`animationSourcePhase`), see `fnc_getShown` and `fnc_isShown`.
- Crew can switch a system with a scroll wheel action (`fnc_addActions`), an ACE self-interaction (`fnc_addAceActions`) or both (CBA setting `ewc_compat_cup_actionMode`). `fnc_canOperate` limits them to driver, commander and gunners, and `fnc_canToggle` adds the state of the system.
- The DUKE addon plugs into these functions by naming convention, `<system>` being `duke`:

  | Name | Provided by the system addon |
  |---|---|
  | `ewc_compat_cup_<system>_on` | Public variable on the vehicle, the state of the system |
  | `ewc_compat_cup_<system>_fnc_canActivate` | Can the system be switched on, takes the vehicle |
  | `ewc_compat_cup_<system>_toggle` | Server event the actions send, with the vehicle and the wanted state |
  | `STR_ewc_compat_cup_<system>_activate` / `_deactivate` | Titles of the actions |

- The DUKE and the Boomerang exclude each other. A system tells the other one with the local server event `ewc_compat_cup_systemOn` when it is switched on, and the other one switches off if it is loaded (`compat_cup_boomerang` passes the event to and from `compat_boomerang`).

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_getSources` | any | Animation sources of a vehicle that belong to a system |
| `fnc_getShown` | any | The ones of them that are currently shown |
| `fnc_isShown` | any | Is at least one antenna of a system shown |
| `fnc_canOperate` | clients | May a unit operate the systems of a vehicle: crew only, in the chosen interaction style |
| `fnc_canToggle` | clients | Condition of the switch actions: `fnc_canOperate` and the state of the system |
| `fnc_addActions` | clients | Adds the scroll wheel actions of a system to a vehicle |
| `fnc_addAceActions` | clients | Adds the ACE self-interaction actions of a system to land vehicles |

## Settings

| Setting | Default | |
|---|---|---|
| DUKE switch | Scroll wheel | Scroll wheel, ACE self-interaction or both. Per client. Without ACE the scroll wheel is always used |
| Require running engine | on | Set by the server |

## Limitations

- The antenna list is the one of CUP's HMMWV, MATV, RG-31 and Abrams. Other vehicles with other source names are not covered.

## Dependencies

- [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- Optional: [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057) for the self-interaction

## Maintainer

- Andx
