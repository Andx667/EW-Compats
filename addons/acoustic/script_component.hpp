#define COMPONENT acoustic
#define COMPONENT_BEAUTIFIED Acoustic Drone Detection

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

// Seconds between two scans of the server. Every scan checks each sensor against each drone in range
#define SCAN_INTERVAL 2

// Height (m) of the microphone array above the position of the sensor object
#define MIC_HEIGHT 1.5
// Closest distance (m) the propagation is worked out for, the spreading loss is referenced to 1 m
#define MIN_DISTANCE 1

// Detection: the received level plus the processing gain of the array (beamforming of several microphones and
// narrowband filtering of the rotor or propeller tones) has to be this much (dB) above the background noise
#define PROCESSING_GAIN 25
#define DETECTION_THRESHOLD 10

// Bearing error scale (degrees) at the detection threshold. The noise is random [-2x, 0, 2x] of it, a rescaled Bates
// distribution: one standard deviation is about 0.58 times the scale (3.5° at 6), never more than 2 times (12° at 6).
// It falls with the signal to noise ratio as 1 / sqrt(SNR) (Cramér-Rao bound of a direction estimate), down to the
// minimum. The elevation is less exact than the azimuth, an array on a mast is wider than it is high
#define BEARING_ERROR_MAX 6
#define BEARING_ERROR_MIN 1
#define ELEVATION_ERROR_FACTOR 1.5
// The range of a single sensor comes from the received level and the source level of the drone type. Individual drones
// and the throttle vary the source level by up to this much (dB), so the range is off by a factor of up to 2
#define LEVEL_UNCERTAINTY 6
// Two bearings have to cross at an angle of at least this (degrees) to be triangulated
#define MIN_CROSS_ANGLE 20
// Elevation (degrees) the height of a triangulated drone is worked out with at most
#define MAX_ELEVATION 85

// Ground effect and terrain screening, ISO 9613-2. The path is sampled every BARRIER_SAMPLE_SPACING m, at most
// BARRIER_MAX_SAMPLES times. A single diffracting edge attenuates up to 20 dB
#define BARRIER_SAMPLE_SPACING 50
#define BARRIER_MAX_SAMPLES 16
#define BARRIER_MAX_ATTENUATION 20

// Upwind shadow zone (empirical, the wind gradient bends the sound upwards): dB per m/s of headwind, at most
// WIND_SHADOW_MAX, fully formed at WIND_SHADOW_DISTANCE m and gone for a source above WIND_SHADOW_ELEVATION degrees
#define WIND_SHADOW_DB_PER_MS 1.5
#define WIND_SHADOW_MAX 15
#define WIND_SHADOW_DISTANCE 300
#define WIND_SHADOW_ELEVATION 15

// Background noise at the microphones, summed by energy: wind on the windscreen (dB at the reference speed, pressure
// fluctuations grow with the square of the speed, so 40 dB per decade), rain on the ground and the sensor
#define WIND_NOISE_REFERENCE 35
#define WIND_NOISE_REFERENCE_SPEED 5
#define WIND_NOISE_SLOPE 40
#define WIND_NOISE_MIN_SPEED 0.5
#define RAIN_NOISE_BASE 40
#define RAIN_NOISE_RANGE 20

// Vehicles with a running engine near a sensor mask the drones, level in dB at 1 m
#define NOISE_SOURCE_RADIUS 500
#define NOISE_LEVEL_TANK 110
#define NOISE_LEVEL_CAR 92
#define NOISE_LEVEL_HELICOPTER 120
#define NOISE_LEVEL_PLANE 125
#define NOISE_LEVEL_SHIP 100

// Source levels (dB at 1 m) and dominant frequencies (Hz) of drones without an entry in CfgEWC >> AcousticSignatures,
// chosen by kind and mass (kg)
#define SIGNATURE_SMALL_MASS 25
#define SIGNATURE_LARGE_ROTOR_MASS 500
#define SIGNATURE_LARGE_WING_MASS 2000
#define SIGNATURE_SMALL_ROTOR [78, 400]
#define SIGNATURE_LARGE_ROTOR [88, 250]
#define SIGNATURE_TURBINE_ROTOR [112, 100]
#define SIGNATURE_SMALL_WING [75, 300]
#define SIGNATURE_PISTON_WING [100, 125]
#define SIGNATURE_JET_WING [120, 250]

// Standard atmosphere when the engine does not report a temperature
#define DEFAULT_TEMPERATURE 15

// Alpha-beta filter of a track: share of the residual taken into the position, for a triangulated and a single sensor
// fix, and into the velocity
#define TRACK_ALPHA_TRIANGULATED 0.6
#define TRACK_ALPHA_SINGLE 0.3
#define TRACK_BETA 0.2
// Speeds (m/s) below this are shown as hovering
#define TRACK_HOVER_SPEED 2
// Path of a track: a point every PATH_MIN_STEP m, at most PATH_MAX_POINTS
#define PATH_MIN_STEP 25
#define PATH_MAX_POINTS 40

// Drone kind of a track. fnc_getSignature relies on rotary being 1
#define DRONE_KIND_FIXED 0
#define DRONE_KIND_ROTARY 1

// Where tracks are shown. cTab is only offered when it is loaded, see the sub-addon in folder acoustic_ctab
#define MARKER_TARGET_NONE 0
#define MARKER_TARGET_MAP 1
#define MARKER_TARGET_CTAB 2

// Values of the side combo of the modules
#define SENSOR_SIDES [west, east, independent]
#define SENSOR_SIDE_WEST 0
#define SENSOR_SIDE_EAST 1
#define SENSOR_SIDE_INDEPENDENT 2

// Object that is placed when a module is not synced to one
#define SENSOR_PROP "Land_DataTerminal_01_F"

// The Zeus modules have their own category
#define ZEUS_CATEGORY "EW Compats"
#define SENSOR_ICON "\a3\ui_f\data\igui\cfg\simpletasks\types\listen_ca.paa"

// Map markers of a track: icon at the estimated position and the line of its path. A single sensor fix is fainter
#define MARKER_TYPE "o_uav"
#define MARKER_COLOR "ColorRed"
#define MARKER_ALPHA_SINGLE 0.6
