# Acoustic Drone Detection

Passive acoustic drone sensors: an editor module, a Zeus module or `ewc_acoustic_fnc_addSensor` makes any object a microphone array of a side. The drones it hears are tracked and shown to that side as a marker with a line along their path, on the map or on cTab. Whether a sensor hears a drone is worked out from outdoor sound propagation (ISO 9613-1 and -2), the weather and the noise around the sensor. Several sensors of a side that hear the same drone are triangulated. Does **not** need Crow's Electronic Warfare, a drone jammer cannot stop it.

Real counterparts are acoustic sensor networks like Sky Fortress (Ukraine) or the Squarehead Discovair and DroneShield arrays: masts with several microphones that find the bearing of the rotor and propeller tones and combine the bearings of several masts.

## How it works

### Sensors and scan

- `fnc_addSensor` (public, any machine, forwarded to the server with `ewc_acoustic_addSensor`) stores the side in the public variable `ewc_acoustic_side` and puts the object into `ewc_acoustic_sensors` (server). `fnc_removeSensor` does the opposite. The module of the editor (`fnc_moduleAddSensor`, server) does it for every synced object, without one it places a `Land_DataTerminal_01_F`. The Zeus modules (`fnc_zeusRegister`, Zeus Enhanced only) do the same on the selected object.
- `fnc_scan` is a CBA per frame handler on the server every `SCAN_INTERVAL` (2 s). It exists only while there is a sensor or a track and removes itself afterwards. Destroyed or deleted sensors are dropped. The drones are `allUnitsUAV` that are `Air`, alive and have their engine on. Sensor × drone pairs further than `ewc_acoustic_maxRange` are skipped before anything expensive, as are drones friendly to the sensor unless `ewc_acoustic_reportFriendly` is on.
- The weather (`fnc_getWeather`: `ambientTemperature`, `humidity`, `wind`, `rain`, speed of sound) is read once per scan, the absorption per frequency once per scan (cache in the scan), the noise of a sensor (`fnc_getNoiseLevel`) only once it has a drone in range.

### Propagation (`fnc_calcReceivedLevel`)

Received level `Lp = Lw - A_div - A_atm - max(A_gr, D_z) - A_wind`, in dB:

| Term | Model |
|---|---|
| `Lw` | Source level at 1 m of the drone type, `fnc_getSignature` |
| `A_div` | Spherical spreading, `20 log10(d)` |
| `A_atm` | `α · d`, `α` from ISO 9613-1 (`fnc_getAbsorption`) for the dominant frequency, the temperature and the humidity. Checked against the table of the standard: 4.98 dB/km at 1 kHz, 20 °C, 70 % |
| `A_gr` | ISO 9613-2 eq. 10 (porous ground): `4.8 - (2 hm / d)(17 + 300 / d)`, at least 0. `hm` is the mean height above the terrain of the path, sampled every 50 m (at most 16 samples) |
| `D_z` | ISO 9613-2 screening: the sample furthest below the terrain is a single edge, `10 log10(3 + 20 z / λ)` with the detour `z` over it, at most 20 dB. The standard has `A_bar = D_z - A_gr`, so ground plus barrier is the larger of the two |
| `A_wind` | Empirical upwind shadow zone: 1.5 dB per m/s of headwind along the path, at most 15 dB, growing to full strength over 300 m and fading out for a source above 15° elevation. ISO 9613-2 assumes downwind propagation, so downwind adds nothing |

Not modelled: buildings and vegetation, temperature inversions, the Doppler shift, reflections.

### Noise and detection

- Noise (`fnc_getNoiseLevel`) is the energetic sum of `ewc_acoustic_ambientNoise`, wind on the windscreen (35 dB at 5 m/s, 40 dB per decade, as the pressure fluctuations grow with the square of the speed), rain (40 to 60 dB) and every non-UAV vehicle with its engine on within 500 m (spherical spreading from 92 dB for cars to 125 dB for planes at 1 m). A sensor that is itself a vehicle with a running engine is deaf.
- A drone is heard when `Lp + PROCESSING_GAIN - noise >= DETECTION_THRESHOLD` (25 dB gain of the array and narrowband processing, 10 dB threshold). With the defaults, quiet conditions and flat ground that is about 500 m for a small quadcopter, 1 km for a hexacopter, 5 km for a piston engine plane. 10 dB more noise roughly halves the range.
- `fnc_hearDrone` uses the position of the drone when the sound left it (retarded time, two fixed point steps of `|P - v τ - R| = c τ`), so a fast drone is heard behind where it is.
- The bearing error (one σ) is `6° · 10^(-(SNR - 10) / 20)`, at least 1°, the elevation error 1.5 times that; the Cramér-Rao bound of a direction estimate falls with `1 / sqrt(SNR)`. The noise is drawn with `random [-2σ, 0, 2σ]`.
- The range of a single sensor inverts spreading and absorption for the nominal source level and a measured level that is off by up to ±6 dB (`LEVEL_UNCERTAINTY`), so it is off by up to a factor of 2. Ground, terrain and wind are unknown to the sensor and make the drone seem further away.

### Fusion and tracks

- `fnc_estimatePosition` combines the measurements of the sensors of one side: two or more bearings that cross at 20° or more are triangulated by weighted least squares (`Σ w (I - d dᵀ) x = Σ w (I - d dᵀ) p`, `w = 1 / σ²`). A crossing behind any sensor is rejected. The height is the weighted mean of `z + distance · tan(elevation)`. Otherwise the sensor with the best SNR gives bearing, elevation and level range. The result is never below the terrain.
- The measurements are associated with the real drone (key `"<side>:<drone ID>"`, a number the scan stores on the drone in `ewc_acoustic_droneId`), so two drones flying together are still two tracks. A real system would have to associate them by position.
- `fnc_updateTrack` runs an alpha-beta filter per track (α 0.6 triangulated, 0.3 single, β 0.2) on the fixes, which smooths the noise and gives heading and speed. The fix is dated to the emission time of the closest sensor. The path keeps a point every 25 m, at most 40.
- Each update is sent to every machine with `ewc_acoustic_trackUpdated` (full path, so a late joiner gets it with the next update). `fnc_dropTracks` ends tracks not heard for `ewc_acoustic_trackTimeout` and raises `ewc_acoustic_trackLost`.

### Display

- `fnc_onTrackUpdated` (clients) shows the track to players friendly to the side of the sensors when `ewc_acoustic_markerTarget` is map: a local `o_uav` marker with height, heading and speed (or *hovering* below 2 m/s), fainter for a single sensor fix, and a local `POLYLINE` marker along the path to the drone. `fnc_onTrackLost` removes both.
- The sub-addon in `acoustic_ctab` shows the track on cTab instead, see its [README](acoustic_ctab/README.md).

### Signatures

`fnc_getSignature` returns `[level, frequency, kind]`, cached per class. The closest entry of the class or a parent in `CfgEWC >> AcousticSignatures` (see `CfgEWC.hpp`) wins. The vanilla drone bases have one. Without an entry, kind and `getMass` decide: multirotor under 25 kg (78 dB, 400 Hz), under 500 kg (88 dB, 250 Hz), turbine helicopter (112 dB, 100 Hz), plane under 25 kg (75 dB, 300 Hz), under 2000 kg piston propeller (100 dB, 125 Hz), jet (120 dB, 250 Hz). The values are estimates from published measurements of comparable real drones.

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_addSensor` | any (public) | Makes an object a sensor of a side |
| `fnc_removeSensor` | any (public) | Stops an object from being a sensor |
| `fnc_getReceivedLevel` | any (public) | Received level, noise, SNR and losses of a sensor and a drone right now, for tuning from the debug console |
| `fnc_moduleAddSensor` | server | Module function of the editor module |
| `fnc_zeusRegister`, `fnc_zeusAddSensor`, `fnc_zeusRemoveSensor` | Zeus | Zeus modules (Zeus Enhanced) |
| `fnc_scan` | server | Every 2 s: listens, combines, updates and drops tracks |
| `fnc_getWeather` | server | Temperature, humidity, wind, rain, speed of sound |
| `fnc_getAbsorption` | any | ISO 9613-1 absorption in dB/m |
| `fnc_getSignature` | any | Source level, frequency and kind of a drone |
| `fnc_getNoiseLevel` | server | Background noise at a sensor |
| `fnc_calcReceivedLevel` | any | ISO 9613 propagation from a source to a microphone |
| `fnc_hearDrone` | server | Detection and noisy measurement of one sensor and drone |
| `fnc_estimatePosition` | server | Triangulation or single sensor fix |
| `fnc_updateTrack` | server | Alpha-beta filter, path, `ewc_acoustic_trackUpdated` |
| `fnc_dropTracks` | server | Ends old tracks, `ewc_acoustic_trackLost` |
| `fnc_onTrackUpdated`, `fnc_onTrackLost` | clients | Map markers |

## Settings

| Setting | Default | |
|---|---|---|
| Enable acoustic drone detection | on | Set by the server |
| Show drones | Map | Nothing, map or cTab (only when cTab is loaded). Set by the server |
| Track timeout | 20 s | Set by the server |
| Maximum range | 4000 m | Set by the server |
| Ambient noise | 35 dB | Set by the server |
| Track friendly drones | off | Set by the server |

## Limitations

- Buildings, forests and other drones do not screen or mask the sound, gunfire and explosions do not add noise.
- The physical constants (gain, threshold, errors, filter) are fixed values in `script_component.hpp`, not settings.
- The tracks are associated by the real drone, not by position.
- A drone is checked every 2 s, so a track moves in steps.

## Dependencies

- `ewc_main` and CBA
- Optional: [Zeus Enhanced](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631) for the Zeus modules, [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) for the sub-addon `acoustic_ctab`

## Maintainer

- Andx
