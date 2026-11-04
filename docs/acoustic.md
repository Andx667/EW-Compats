# Acoustic Drone Detection

**Acoustic drone sensors** listen for the buzz of rotors and propellers. A drone a sensor hears is marked for its side, on the map or on cTab, and followed: the marker moves with the drone and a line shows the path it took.

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

- A **red drone marker** shows the estimated position.
- A **red line** shows the path the drone took, up to the last 40 points. A small flag labelled *Drone path* marks where the line starts.
- A **faint marker** means only one sensor hears the drone. Its distance is a guess from how loud it sounds and can be off by half or double. A drone behind a hill or upwind sounds further away than it is.
- A **solid marker** means two or more sensors from different directions hear it. The position is much more exact.
- The marker **lags behind** fast drones: sound needs about 3 seconds per kilometre, so the sensor hears where the drone was.
- A drone that nobody hears any more stays marked for the *Track timeout* (30 s), then the marker, the line and the flag disappear. Heard again within that time, it carries on with the same marker and line.

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
- Default: `30`
- Set by: the server
- Purpose: seconds a drone that is no longer heard stays marked, on the map and on cTab.

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
force ewc_acoustic_trackTimeout = 45; // default: 30
force ewc_acoustic_maxRange = 3000; // default: 4000
force ewc_acoustic_ambientNoise = 45; // default: 35
force ewc_acoustic_reportFriendly = false; // default: false
```

## Adding your own drones

Drones from other mods work without changes. This section is for mod authors who want their drones to sound right.

### Which drones are heard

A drone is heard when all of these are true:

- It is a UAV with its AI crew (it is in `allUnitsUAV`). A drone whose crew was deleted cannot fly and is left out.
- It is an `Air` vehicle, alive, with its engine on.
- It is not friendly to the side of the sensor, unless *Track friendly drones* is on. The side comes from the drone's crew group.

### Default loudness

Without an entry of its own, a drone gets a loudness from its kind and its weight (`getMass`). The kind is rotary wing when the class is a `Helicopter`, otherwise fixed wing. On cTab it decides between the rotary and the fixed wing icon.

| Kind | Weight | Level at 1 m | Frequency | Meant for |
|---|---|---|---|---|
| Rotary | under 25 kg | 78 dB | 400 Hz | small electric multirotor |
| Rotary | 25 to 500 kg | 88 dB | 250 Hz | large electric multirotor |
| Rotary | 500 kg and more | 112 dB | 100 Hz | turbine helicopter |
| Fixed | under 25 kg | 75 dB | 300 Hz | small electric plane |
| Fixed | 25 to 2000 kg | 100 dB | 125 Hz | piston engine with a propeller |
| Fixed | 2000 kg and more | 120 dB | 250 Hz | jet |

### Giving a drone its own signature

Add an entry for the drone class, or for a base class all your drones share, to `CfgEWC >> AcousticSignatures` in the `config.cpp` of your mod:

``` cpp
class CfgPatches {
    class MY_Drones_EWC {
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.18;
        requiredAddons[] = {"MY_Drones", "ewc_acoustic"};
        skipWhenMissingDependencies = 1; // the patch is skipped when EW Compats is not loaded
    };
};

class CfgEWC {
    class AcousticSignatures {
        class MY_Quadcopter_base {
            level = 80;      // dB at 1 m
            frequency = 350; // Hz
        };
    };
};
```

- The class name is the drone class or one of its parents, the closest entry counts. An entry on a base class covers all drones that inherit from it.
- `requiredAddons` needs `ewc_acoustic`, so your entries are added to the list of this addon and do not replace it.
- With `skipWhenMissingDependencies = 1` the patch can be in your main mod, players without EW Compats just skip it. Otherwise ship it as a separate optional addon.
- The values are read once per class and mission. Restart the mission after a change.

!!! note "Missions cannot add signatures"
    The entries are read from the game config (`configFile`), not from `description.ext`. A mission uses the entries of the loaded mods, or the default loudness.

### Choosing the values

- **`level`** is the sound level 1 m from the drone, the source level of the whole drone at cruise. It decides how far the drone is heard: 6 dB more roughly doubles the range, 6 dB less halves it (before the air absorbs more over the longer path).
- **`frequency`** is the strongest tone: the blade passing frequency of the rotors or the propeller (blades × revolutions per second) or its strongest harmonic. The air absorbs high tones more, so a high-pitched drone fades faster over distance: at 20 °C and 70 % humidity about 0.3 dB per km at 125 Hz, 1.1 dB at 250 Hz, 2.8 dB at 500 Hz and 5 dB at 1 kHz.
- Published measurements of real drones are the best source. Small quadcopters are about 70 to 80 dB at 1 m, larger multirotors 80 to 90 dB, piston engine drones about 95 to 105 dB.

With the defaults, quiet conditions and flat ground, a small quadcopter is heard at about 500 m, a hexacopter at about 1 km and a piston engine plane at about 5 km.

### Testing

Fly the drone near a sensor and run this in the debug console, with `_mast` the sensor object and `_drone` the drone:

``` cpp
[_mast, _drone] call ewc_acoustic_fnc_getReceivedLevel
// [received level, noise, signal to noise ratio, losses, drone signature], heard from a ratio of 10
```

The last element is the signature in use, `[level, frequency, kind]` with kind `1` for rotary wing and `0` for fixed wing. If it shows the default of the table above, the entry is not found: check the class name and the `requiredAddons`.

### Making a drone jammable

Being heard and being jammed are separate. Crow's Electronic Warfare's drone jammers only jam drones that have a spectrum signal of the type `drone`, and it only gives one to the classes it lists. EW Compats has no list for other mods' drones. The [Compat CUP Drones](compat-cup-drones.md) addon shows how to add the signal for the CUP drones: on the server, raise `crowsEW_spectrum_addBeacon` with `[drone, frequency, range, "drone"]` once Crow's Electronic Warfare is ready.

## Quirks

- Buildings and forests do not block the sound, and gunfire does not drown it out.
- The position is updated every 2 seconds, so markers move in steps.
- Two drones flying close together are still shown as two.

## Dependencies

- None besides CBA
- Optional: [Zeus Enhanced](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631) for the Zeus modules, [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) to show the drones on the tablets
