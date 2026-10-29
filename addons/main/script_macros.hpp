#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"

// Same as ACE's LINKFUNC: code block calling a function, so the function can be recompiled at runtime
#define LINKFUNC(x) {call FUNC(x)}

// Functions live in each addon's functions folder (ACE convention, CBA's default is the addon root)
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

// Crows Electronic Warfare: events, capability and the colour it gives the title of its own actions
#define CROWS_EVENT_ADD_JAMMER "crowsEW_main_addJammer"
#define CROWS_EVENT_REMOVE_JAMMER "crowsEW_main_removeJammer"
#define CROWS_EVENT_TOGGLE_JAMMER "crowsEW_main_toggleJammer"
#define CROWS_EVENT_UPDATE_JAMMERS "crowsEW_main_updateJammers"
#define CROWS_CAPABILITY_RADIO "VoiceCommsJammer"
#define CROWS_ACTION_MARKER "#FFFF00"

// Radius where a jammer has faded out, as factor of its full radius, when an entry of CfgEWC has none
#define DEFAULT_FALLOFF_FACTOR 1.5
