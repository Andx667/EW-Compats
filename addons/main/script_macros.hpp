#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"

// Same as ACE's LINKFUNC: code block calling a function, so the function can be recompiled at runtime
#define LINKFUNC(x) {call FUNC(x)}

// Functions live in each addon's functions folder (ACE convention, CBA's default is the addon root)
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

// Same for a sub-addon, a folder <addon>_<sub> of the addon with its own config.cpp (as in ACE). Its functions are in the folder "functions" of the sub-addon and named <sub>_<function>
#define PREP_SUB(sub,fncName) [QPATHTOF(DOUBLES(COMPONENT,sub)\functions\DOUBLES(fnc,fncName).sqf), QFUNC(DOUBLES(sub,fncName))] call CBA_fnc_compileFunction

// Crows Electronic Warfare: events, capability and the colour it gives the title of its own actions
#define CROWS_EVENT_ADD_JAMMER "crowsEW_main_addJammer"
#define CROWS_EVENT_REMOVE_JAMMER "crowsEW_main_removeJammer"
#define CROWS_EVENT_TOGGLE_JAMMER "crowsEW_main_toggleJammer"
#define CROWS_EVENT_UPDATE_JAMMERS "crowsEW_main_updateJammers"
// Spectrum beacons: the event that adds one, its type for a jammable drone and the variables that hold the list and the bands
#define CROWS_EVENT_ADD_BEACON "crowsEW_spectrum_addBeacon"
#define CROWS_BEACON_DRONE "drone"
#define CROWS_VAR_BEACONS "crowsEW_spectrum_beacons"
#define CROWS_VAR_FREQUENCY_RANGE "crowsEW_spectrum_spectrumDeviceFrequencyRange"
#define CROWS_CAPABILITY_RADIO "VoiceCommsJammer"
#define CROWS_CAPABILITY_DRONE "DroneJammer"
#define CROWS_ACTION_MARKER "#FFFF00"

// Radius where a jammer has faded out, as factor of its full radius, when an entry of CfgEWC has none
#define DEFAULT_FALLOFF_FACTOR 1.5
