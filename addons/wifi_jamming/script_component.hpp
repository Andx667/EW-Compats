#define COMPONENT wifi_jamming
#define COMPONENT_BEAUTIFIED Wi-Fi Jamming

#include "\z\ewc\addons\main\script_mod.hpp"
#include "\z\ewc\addons\main\script_macros.hpp"

// Capability tag piggybacked onto the capabilities array of Crows' jammers (crowsEW_main_jamMap). Crows only knows
// "VoiceCommsJammer" and "DroneJammer", any other tag rides along untouched in its jamMap and broadcasts, which is how
// a Wi-Fi jammer is registered without touching the code of Crows (the same way as the BFT jammer).
#define WIFI_JAM_CAP "WifiJammer"

// Module attribute defaults (CfgVehicles.hpp) and fallbacks when reading them back. AE3 routers reach 100 m by default
#define WIFI_JAM_DEFAULT_EFFECTIVE_RADIUS 100
#define WIFI_JAM_DEFAULT_FALLOFF_RADIUS 100
#define WIFI_JAM_DEFAULT_FREQUENCY 915
// Range of the experimental antenna of the Spectrum Device, the slider of the Zeus module is limited to it. Real Wi-Fi is
// on 2.4 and 5 GHz, which no antenna of the Spectrum Device reaches
#define WIFI_JAM_MIN_FREQUENCY 520
#define WIFI_JAM_MAX_FREQUENCY 1090
// Radius sliders of the Zeus module, in m
#define WIFI_JAM_MIN_RADIUS 10
#define WIFI_JAM_MAX_RADIUS 5000

// Icon of the modules, the one of the signal source module of Crows
#define WIFI_JAM_ICON "\z\crowsEW\addons\zeus\data\spectrum_signal.paa"

// The Zeus modules are listed in the category of Crows, next to its own jammer modules
#define ZEUS_CATEGORY "Crows Electronic Warfare"

// Spectrum beacon type tag used for detectability (arbitrary, Crows only special-cases the literal "drone")
#define WIFI_JAM_SPECTRUM_TYPE "sweep_wifi"

// Public CBA events and globals of Crow's Electronic Warfare we integrate with
#define CROWSEW_ADD_JAMMER_EVENT "crowsEW_main_addJammer"
#define CROWSEW_REMOVE_JAMMER_EVENT "crowsEW_main_removeJammer"
#define CROWSEW_UPDATE_JAMMERS_EVENT "crowsEW_main_updateJammers"
#define CROWSEW_ADD_BEACON_EVENT "crowsEW_spectrum_addBeacon"
#define CROWSEW_REMOVE_BEACON_EVENT "crowsEW_spectrum_removeBeacon"
#define CROWSEW_JAM_MAP crowsEW_main_jamMap
#define CROWSEW_JAM_MAP_NAME "crowsEW_main_jamMap"
#define CROWSEW_BEACONS crowsEW_spectrum_beacons

// Advanced Equipment (AE3) we integrate with, through its connect condition API (AE3 2.1.0.5 and later). Its network is no
// radio: a router has a wireless range, and AE3 itself drops a client that no longer passes AE3_network_fnc_canConnect
#define AE3_CONNECT_CONDITION_ID "ewc_wifi_jamming"
// Variable AE3 marks a router with (a cascaded router is no laptop and left alone)
#define AE3_VAR_IS_ROUTER "AE3_cap_isRouter"
// Router a device is connected to (objNull when none), read to see whether the sweep of AE3 dropped it
#define AE3_VAR_PARENT "AE3_network_parent"
