# Compat Boomerang

Vehicles with a **Boomerang** shot finder get a Boomerang switch. A running Boomerang detects shots near the vehicle and reports where they came from. The real system is a passive acoustic sensor that locates the shooter from the shockwave and muzzle blast of a shot. CUP and RHS USAF only model the antenna and hide it by default, so this addon provides the function. It is the common core of the two mod addons below, which only say which vehicles have the antenna.

| Mod | Addon | Vehicles |
|---|---|---|
| [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371) | `compat_cup/boomerang` | HMMWV (M1151, M1240) and RG-31 families. Switching it on switches the DUKE of [Compat CUP DUKE](compat-cup-duke.md) off and the other way round |
| [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117) | `compat_rhs_usaf/boomerang` | M1245 SOCOM (`rhsusf_m1245_m2crows_socom_d`, `rhsusf_m1245_mk19crows_socom_d` and their `_deploy` variants) |

This addon does **not** need Crow's Electronic Warfare and works in singleplayer.

!!! note "Real system"
    The real Boomerang is the Raytheon BBN shooter detection system, a mast with a microphone array that uses the muzzle blast and the shockwave of supersonic bullets. Its data sheet gives a bearing error under 2.5°, a range error of ±10 %, detection of bullets that pass within about 30 m of the mast, operation up to 60 mph, and no alert for shots from the own vehicle. The addon uses these figures. The dismounted Boomerang Warrior is less accurate (7.5° and ±20 %), these are not used. The elevation threshold, the 1000 m limit and the 100 m for subsonic bullets are gameplay values, the sources do not give them.

## Controls

*Activate Boomerang* / *Deactivate Boomerang* with the scroll wheel, the ACE self-interaction, or both. Choose in the CBA settings. Only the **driver, commander and gunners** get the switch, passengers do not. It needs a **shown antenna** and the **engine running**. Both mods hide the antenna by default, show it in the vehicle appearance options (RHS: *hide shot finder*). The Boomerang switches off when the engine stops, the antenna is hidden or the vehicle is destroyed.

Every change of state shows a silent hint to everybody in the vehicle, for example *Boomerang on* or *Boomerang off: engine stopped*. The reason is *engine stopped*, *antenna hidden* or *disabled in the settings*.

## Range

| Shot | Heard |
|---|---|
| Supersonic bullet | Within the detection distance of the vehicle (**30 m**), up to **1000 m** from the shooter |
| Slower bullet | Only as muzzle blast, within **100 m** |
| Shells, missiles | Not heard, only small arms |
| Shots from inside the vehicle | Not reported |

The shots of friendly units are reported too, like the real system does. A setting turns this off.

An active Boomerang reports a heard bullet:

- The **crew** gets a hint with one line per information (shot detected, 3 o'clock, ~300 m, bearing 87°, level). It makes no sound.
- Everybody **friendly to the vehicle** gets a red marker at the estimated position of the shooter, on the map or on cTab, or not at all (setting *Show shots*). It disappears after 30 seconds. The map marker is local, the enemy does not see it. On cTab it is a red enemy marker of the side of the vehicle, so everybody with that side's cTab sees it, with the usual cTab notification. cTab is only an option when [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) is loaded.
- Reports are not exact, like the real system: the bearing is off by up to 2.5° and the range by up to 10 %.
- A burst is reported once per second, not bullet by bullet.
- A shot close to a marker that is still there does not add another one, on the map and on cTab. "Close" is 50 m, or 20 % of the reported range if that is more, as the position is less exact the further the shooter is. The existing marker stays longer instead, so a fight shows one marker per shooter that goes away one marker lifetime after the last shot.

## Settings

### `ewc_compat_boomerang_enable`

- Name: Enable Boomerang
- Type: `CHECKBOX`
- Default: `true`
- Set by: the server
- Purpose: if off, there is no Boomerang switch and active Boomerangs switch off.

### `ewc_compat_boomerang_friendlyFire`

- Name: Report friendly fire
- Type: `CHECKBOX`
- Default: `true`
- Set by: the server
- Purpose: report the shots of friendly units too.

### `ewc_compat_boomerang_markerLifetime`

- Name: Marker lifetime
- Type: `SLIDER`
- Range: `0` to `120` s
- Default: `30`
- Set by: each player (client setting), the cTab markers use the value of the server
- Purpose: seconds a marker of a shot stays. `0` turns the markers off.

### `ewc_compat_boomerang_markerTarget`

- Name: Show shots
- Type: `LIST`
- Values: `0` nothing, `1` map, `2` cTab (only offered when cTab is loaded)
- Default: `1`
- Set by: the server
- Purpose: where a detected shot is marked. The hint for the crew is not affected.

### `ewc_compat_boomerang_actionMode`

- Name: Boomerang switch
- Type: `LIST`
- Values: `0` scroll wheel, `1` ACE self-interaction, `2` both
- Default: `0`
- Set by: each player (client setting)
- Purpose: how the Boomerang is switched. Without ACE the scroll wheel is always used.

### Complete example

``` cpp
// cba_settings.sqf
force ewc_compat_boomerang_enable = false; // default: true
force ewc_compat_boomerang_friendlyFire = false; // default: true
ewc_compat_boomerang_markerLifetime = 60; // default: 30
force ewc_compat_boomerang_markerTarget = 2; // default: 1
ewc_compat_boomerang_actionMode = 2; // default: 0
```

## Quirks

- **Deaf for 5 seconds** after the weapons of its own vehicle were fired. Smoke launchers and flares do not count. The crew gets a silent hint when the Boomerang goes deaf (*Boomerang deaf: own fire*) and when it listens again, once per stretch of fire and not for every burst. A Boomerang that is off says nothing.
- **Does not work above 97 km/h** (60 mph), the speed the real system is specified for. It listens again when the vehicle is slower.
- **Up to a second of delay** when an antenna is hidden or the engine stops, because the Boomerang is checked once per second.

## How it works

Each machine checks the bullets it fires against the active Boomerangs and sends a report only for a shot that is heard. The server keeps the list of active Boomerangs and sends it to every machine; a machine only watches projectiles while the list is not empty. The Boomerang does not use Crow's Electronic Warfare.

## Dependencies

- A mod addon with vehicles: `compat_cup/boomerang` with [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371) or `compat_rhs_usaf/boomerang` with [RHS USAF](https://steamcommunity.com/sharedfiles/filedetails/?id=843577117)
- Optional: [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) to show the shots on the tablets
