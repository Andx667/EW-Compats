# Compat CUP Boomerang

Vehicles with a **Boomerang** shot finder (HMMWV, MATV and RG-31 families) get a Boomerang switch. A running Boomerang detects shots near the vehicle and reports where they came from. The real system is a passive acoustic sensor that locates the shooter from the shockwave and muzzle blast of a shot. It is hidden by default on these vehicles.

This addon does **not** need Crow's Electronic Warfare and works in singleplayer.

!!! note "Real system"
    The real Boomerang is the Raytheon BBN shooter detection system, a mast with a microphone array that uses the muzzle blast and the shockwave of supersonic bullets. Its data sheet gives a bearing error under 2.5°, a range error of ±10 %, detection of bullets that pass within about 30 m of the mast, operation up to 60 mph, and no alert for shots from the own vehicle. The addon uses these figures. The dismounted Boomerang Warrior is less accurate (7.5° and ±20 %), these are not used. The elevation threshold, the 1000 m limit and the 100 m for subsonic bullets are gameplay values, the sources do not give them.

## Controls

*Activate Boomerang* / *Deactivate Boomerang* with the scroll wheel or the ACE self-interaction, see [Compat CUP](compat-cup.md#controls). The Boomerang switches off when the engine stops, the antenna is hidden or the vehicle is destroyed.

Every change of state shows a silent hint to everybody in the vehicle, for example *Boomerang on* or *Boomerang off: engine stopped*. The reason is *engine stopped*, *antenna hidden* or *disabled in the settings*.

## Range

| Shot | Heard |
|---|---|
| Supersonic bullet | Within the detection distance of the vehicle (**30 m** by default), up to **1000 m** from the shooter |
| Slower bullet | Only as muzzle blast, within **100 m** |
| Shells, missiles | Not heard, only small arms |
| Shots from inside the vehicle | Not reported |

The shots of friendly units are reported too, like the real system does. A setting turns this off.

An active Boomerang reports a heard bullet:

- The **crew** gets a hint with one line per information (shot detected, 3 o'clock, ~300 m, bearing 87°, level). It makes no sound.
- Everybody **friendly to the vehicle** gets a red marker at the estimated position of the shooter, on the map, on cTab or both (setting *Show shots on*). It disappears after 30 seconds. The map marker is local, the enemy does not see it. On cTab it is a red enemy marker of the side of the vehicle, so everybody with that side's cTab sees it, with the usual cTab notification. This needs [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217), without it the map is used.
- Reports are not exact, like the real system: the bearing is off by up to 2.5° and the range by up to 10 %.
- A burst is reported once per second, not bullet by bullet.
- A shot close to a marker that is still there does not add another one, on the map and on cTab. "Close" is 50 m, or 20 % of the reported range if that is more, as the position is less exact the further the shooter is. The existing marker stays longer instead, so a fight shows one marker per shooter that goes away one marker lifetime after the last shot.

## Settings

| Setting | Default | |
|---|---|---|
| Enable CUP Boomerang | on | If off, no Boomerang switch and active Boomerangs switch off. Set by the server |
| Report friendly fire | on | Set by the server |
| Detection distance | 30 m | For supersonic bullets. Set by the server |
| Lockout after own fire | 5 s | Set by the server |
| Marker lifetime | 30 s | 0 turns the markers off. Per player for the map, cTab markers use the value of the server |
| Show shots on | Map and cTab | Map, cTab or both. Only there when cTab is loaded. Set by the server |

The switch and the engine requirement are shared with the DUKE, see [Compat CUP](compat-cup.md#settings).

## Quirks

- **Deaf for 5 seconds** after the weapons of its own vehicle were fired. Smoke launchers and flares do not count. The time is a setting.
- **Does not work above 97 km/h** (60 mph), the speed the real system is specified for. It listens again when the vehicle is slower.
- **Up to a second of delay** when an antenna is hidden or the engine stops, because the Boomerang is checked once per second.

## How it works

Each machine checks the bullets it fires against the active Boomerangs and sends a report only for a shot that is heard. The server keeps the list of active Boomerangs and sends it to every machine; a machine only watches projectiles while the list is not empty. The Boomerang does not use Crow's Electronic Warfare.

## Dependencies

- [Compat CUP](compat-cup.md) with [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
- Optional: [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) to show the shots on the tablets
