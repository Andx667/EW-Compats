# Events

Mission makers and other mods can hook into EW Compats with CBA events. This page lists the ones that are meant for it. An event that is not listed here is plumbing between the parts of the mod and can change without notice, see [Internal events](#internal-events).

Names follow `ewc_<component>_<what happened>`. Every event says where it is raised, because that decides where your handler has to be added.

``` cpp
// initServer.sqf, initPlayerLocal.sqf or an init field: add the handler on the machines the event is raised on
["ewc_common_stateChanged", {
    params ["_vehicle", "_name", "_on", "_reason"];
    systemChat format ["%1 of %2 is %3", _name, typeOf _vehicle, ["off", "on"] select _on];
}] call CBA_fnc_addEventHandler;
```

## Switched systems

### `ewc_common_stateChanged`

- Raised on: every machine (global)
- Payload: `[vehicle, name, on, reason]`
    - `name`: the system, `"DUKE"` (CUP and RHS USAF), `"CG13"`, `"R-142N"`, `"Hummel"` or `"Boomerang"`
    - `on`: the system is on now
    - `reason`: why a system switched itself off, `"engine"`, `"antenna"`, `"damage"` or `"disabled"` (turned off in the settings). `""` when the crew switched it or nobody has to be told why
- When: a system was really switched on or off. It is not raised again for a state that did not change.

### `ewc_common_jammerChanged`

- Raised on: the server (local event)
- Payload: `[vehicle, enabled, radius]`, the radius is the full jamming radius in m
- When: the radio jammer of a vehicle of the compat addons was registered in Crow's Electronic Warfare, replaced for another radius, or switched on or off. The jammers of the BFT Jamming addon and the jammers of Crow's itself do not raise it, use `crowsEW_main_updateJammers` for those.

## IEDs

Raised by the DUKEs, which hold the IEDs around the vehicle while they are on. The Dingo CG13 jams IEDs inside BWmod, where this mod cannot see it, so it raises none.

### `ewc_common_iedJammed`

- Raised on: the server (local event)
- Payload: `[ied, vehicle]`
- When: the CUP DUKE froze an IED that came into its range. The RHS DUKE freezes IEDs itself (`rhs_duke.sqf`) and does not raise it.

### `ewc_common_iedReleased`

- Raised on: the server (local event)
- Payload: `[ied, vehicle]`, the vehicle is `objNull` if it was deleted
- When: a DUKE let an IED go: the DUKE stopped, or the IED left the range. Raised by the CUP DUKE and the RHS USAF DUKE. An IED that was triggered inside the range explodes on release.

## Boomerang

### `ewc_boomerang_shotDetected`

- Raised on: every machine (global)
- Payload: `[vehicle, position, clock, range, bearing, elevation, side]`
    - `vehicle`: the vehicle that heard the shot
    - `position`: where the shot came from as the Boomerang reports it (with its error), `[x, y, 0]`
    - `clock`: direction relative to the vehicle, 1 to 12
    - `range`: in m, rounded to 10 m
    - `bearing`: in degrees, rounded
    - `elevation`: `0` high, `1` level, `2` low
    - `side`: side of the commander of the vehicle
- When: a running Boomerang detects a shot (at most once per report interval of the vehicle, so not per bullet).

## For addon authors

### `ewc_common_vehicleInit`

- Raised on: every machine (local event, once per vehicle)
- Payload: `[vehicle, class name of its entry in CfgEWC >> Jammers]`
- When: a vehicle that is in the registry of `ewc_common` is created. Add the handler in `preInit`, so editor-placed vehicles are not missed.

### `ewc_boomerang_switchedOn`

- Raised on: the server (local event)
- Payload: `[vehicle]`
- When: a Boomerang is about to be switched on. Systems that exclude the Boomerang, like the CUP DUKE, switch it off here.

## Internal events

These carry commands or keep the machines in sync. Do not rely on them: `ewc_compat_cup_duke_toggle`, `ewc_compat_rnt_toggle`, `ewc_boomerang_toggle`, `ewc_compat_bwa3_ecmToggled`, `ewc_compat_rhs_afrf_mastToggled`, the `syncJammer` events of the compat addons, `ewc_boomerang_vehicleFired`, `listChanged`, `requestList` and `deafChanged`.

To switch a jammer from a script, use the public functions `ewc_common_fnc_setJammer` and `ewc_common_fnc_addJammer` for the Crow's jammer, or the module of Crow's. A system with a switch (DUKE, Hummel) keeps its own state, so the crew's switch and a jammer set from a script can disagree.
