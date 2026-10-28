#define MAINPREFIX z
#define PREFIX MOD_PREFIX
#define MOD_NAME MOD_TITLE
#define AUTHOR "Andx"

#define REQUIRED_VERSION 2.18

#include "script_version.hpp"

#define VERSION MAJOR.MINOR
#define VERSION_STR MAJOR.MINOR.PATCH
#define VERSION_AR MAJOR,MINOR,PATCH
#define VERSION_CONFIG version = VERSION; versionStr = QUOTE(VERSION_STR); versionAr[] = {VERSION_AR}

// --- Minimal macro set (no CBA dependency; swap in CBA's
// script_macros_common.hpp instead if/when this mod depends on CBA_A3) ---
#define QUOTE(var1) #var1
#define DOUBLES(var1,var2) var1##_##var2
#define ADDON DOUBLES(PREFIX,COMPONENT)

#ifndef COMPONENT_BEAUTIFIED
    #define COMPONENT_BEAUTIFIED COMPONENT
#endif
#define COMPONENT_NAME QUOTE(MOD_NAME - COMPONENT_BEAUTIFIED)
