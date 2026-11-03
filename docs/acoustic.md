# Acoustic Drone Detection

**Acoustic drone sensors** listen for the buzz of rotors and propellers. A drone a sensor hears is marked for its side, on the map or on cTab, and followed: the marker moves with the drone and a line shows the path it took. The marker gives the estimated height above the ground, the heading and the speed.

Whether a sensor hears a drone depends on what a real microphone would hear: how loud the drone is, how far away it is, the hills in between, the weather and the noise around the sensor. One sensor gives a rough position. **Two or more sensors** that hear the same drone from different directions locate it much more exactly.

This addon does **not** need Crow's Electronic Warfare. It works in singleplayer, and drone jammers do not affect it: the sensors only listen.

!!! note "Real systems"
    Acoustic sensor networks such as Sky Fortress in Ukraine, or the arrays of Squarehead and DroneShield, are masts with several microphones. Each mast finds the direction of a drone from the sound, and the directions of several masts are combined into a position. They are cheap and silent, cannot be jammed and see no further than they hear: a few hundred metres for small drones, several kilometres for drones with combustion engines.

## Placing sensors

### In the editor

Place the module **Acoustic Drone Sensor** (category *EW Compats*), choose the **side** that gets the reports and **sync** it to the objects that are sensors, for example a mast, a crate or a vehicle. One module can make many sensors. Without a synced object, the module places a data terminal as the sensor.

### In Zeus

With [Zeus Enhanced](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631), the category *EW Compats* has two modules:

- **Acoustic Drone Sensor**: place it on an object and choose the side. Placed on empty ground, it adds a data terminal.
- **Remove Acoustic Sensor**: place it on a sensor.

### By script

``` cpp
// Any machine
[_mast, west] call ewc_acoustic_fnc_addSensor;
[_mast] call ewc_acoustic_fnc_removeSensor;
```

A sensor that is destroyed stops for good.

## What a sensor hears

With the default settings and calm weather in open country:

| Drone | Example | Heard up to about |
|---|---|---|
| Small quadcopter | AR-2 Darter | 500 m |
| Larger multirotor | AL-6 Pelican, utility drones | 1 km |
| Propeller plane with combustion engine | Greyhawk, Ababil, Fenghuang | 5 km |
| Turbine helicopter, jet | Falcon, Sentinel | up to the maximum range (4 km) |

Things that make a sensor hear **less**:

- **Noise around the sensor.** The setting *Ambient noise* sets the base level, about 30 dB for quiet countryside, 45 for a village, 60 for a city or a battlefield. 10 dB more noise roughly halves the range.
- **Running engines nearby.** A vehicle with its engine running close to the sensor drowns out everything. A sensor on a vehicle only works with the engine **off**.
- **Wind and rain.** Wind blowing on the microphones and rain add noise. Wind also matters for direction: a sensor **upwind** of a drone hears it worse than one downwind.
- **Hills.** A drone behind a hill is much harder to hear. A drone high up is heard better than one skimming the ground.
- **Temperature and humidity** change how much of the sound the air swallows on the way. This matters most for small drones, whose sound is higher, and over long distances.

Only drones in the air with their engine running make a sound. Friendly drones are not tracked unless the setting *Track friendly drones* is on.

## Reading the markers

- A **red drone marker** shows the estimated position, with height, heading and speed, for example *Drone 120 m, 45°, 60 km/h*, or *hovering* for a drone that stands still.
- A **red line** shows the path the drone took, up to the last 40 points.
- A **faint marker** means only one sensor hears the drone. Its distance is a guess from how loud it sounds and can be off by half or double. A drone behind a hill or upwind sounds further away than it is.
- A **solid marker** means two or more sensors from different directions hear it. The position is much more exact.
- The marker **lags behind** fast drones: sound needs about 3 seconds per kilometre, so the sensor hears where the drone was.
- A drone that nobody hears any more stays marked for the *Track timeout* (20 s), then the marker and line disappear.

Only the side of the sensor and its friends see the markers. On **cTab** (setting *Show drones*), the drone is a red air marker of that side, with an arrow for its heading and the usual cTab notification. cTab cannot move a marker, so it is replaced when the drone has moved at least 150 m, at most every 10 seconds. cTab shows no path line.

## Settings

### `ewc_acoustic_enable`

- Name: Enable acoustic drone detection
- Type: `CHECKBOX`
- Default: `true`
- Set by: the server
- Purpose: if off, the sensors hear nothing and all markers disappear.

### `ewc_acoustic_markerTarget`

- Name: Show drones
- Type: `LIST`
- Values: `0` nothing, `1` map, `2` cTab (only offered when cTab is loaded)
- Default: `1`
- Set by: the server
- Purpose: where the drones are marked.

### `ewc_acoustic_trackTimeout`

- Name: Track timeout
- Type: `SLIDER`
- Range: `5` to `120` s
- Default: `20`
- Set by: the server
- Purpose: seconds a drone that is no longer heard stays marked.

### `ewc_acoustic_maxRange`

- Name: Maximum range
- Type: `SLIDER`
- Range: `500` to `10000` m
- Default: `4000`
- Set by: the server
- Purpose: drones further from a sensor are not checked, however loud they are. A lower value saves work on the server.

### `ewc_acoustic_ambientNoise`

- Name: Ambient noise
- Type: `SLIDER`
- Range: `20` to `70` dB
- Default: `35`
- Set by: the server
- Purpose: background noise at the sensors without wind, rain and vehicles. Raise it for cities or busy battlefields.

### `ewc_acoustic_reportFriendly`

- Name: Track friendly drones
- Type: `CHECKBOX`
- Default: `false`
- Set by: the server
- Purpose: also track the drones of the own and friendly sides. A real sensor cannot tell friend from foe.

### Complete example

``` cpp
// cba_settings.sqf
force ewc_acoustic_enable = true; // default: true
force ewc_acoustic_markerTarget = 2; // default: 1
force ewc_acoustic_trackTimeout = 30; // default: 20
force ewc_acoustic_maxRange = 3000; // default: 4000
force ewc_acoustic_ambientNoise = 45; // default: 35
force ewc_acoustic_reportFriendly = false; // default: false
```

## Drones from other mods

Drones from other mods work without changes: their loudness is chosen from their type (multirotor, helicopter, plane) and weight. A mod can give its drones an exact loudness, see the README of the addon on GitHub.

## Testing

`ewc_acoustic_fnc_getReceivedLevel` tells what a sensor hears of a drone right now, from the debug console:

``` cpp
[_mast, _drone] call ewc_acoustic_fnc_getReceivedLevel
// [received level, noise, signal to noise ratio, losses, drone signature], heard from a ratio of 10
```

## Quirks

- Buildings and forests do not block the sound, and gunfire does not drown it out.
- The position is updated every 2 seconds, so markers move in steps.
- Two drones flying close together are still shown as two.

## Dependencies

- None besides CBA
- Optional: [Zeus Enhanced](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631) for the Zeus modules, [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) to show the drones on the tablets
