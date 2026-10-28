#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"

// Same as ACE's LINKFUNC: code block calling a function, so the function can be recompiled at runtime
#define LINKFUNC(x) {call FUNC(x)}

// Functions live in each addon's functions folder (ACE convention, CBA's default is the addon root)
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
