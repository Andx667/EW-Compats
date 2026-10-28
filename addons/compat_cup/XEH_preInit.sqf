#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Vehicle class -> animation sources of its DUKE antennas
GVAR(sourceCache) = createHashMap;

// Vehicle (net ID) -> mines it holds disabled. Only exists on the server
GVAR(active) = createHashMap;
GVAR(loopHandle) = -1;

GVAR(aceLoaded) = isClass (configFile >> "CfgPatches" >> "ace_interact_menu");

private _category = [LELSTRING(main,displayName), LLSTRING(category)];

[
    QGVAR(actionMode),
    "LIST",
    [LLSTRING(setting_actionMode), LLSTRING(setting_actionMode_tooltip)],
    _category,
    [[ACTION_MODE_SCROLL, ACTION_MODE_ACE, ACTION_MODE_BOTH], [LLSTRING(mode_scroll), LLSTRING(mode_ace), LLSTRING(mode_both)], ACTION_MODE_SCROLL],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(radius),
    "SLIDER",
    [LLSTRING(setting_radius), LLSTRING(setting_radius_tooltip)],
    _category,
    [10, 200, 50, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(jamMines),
    "CHECKBOX",
    [LLSTRING(setting_jamMines), LLSTRING(setting_jamMines_tooltip)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(requireEngine),
    "CHECKBOX",
    [LLSTRING(setting_requireEngine), LLSTRING(setting_requireEngine_tooltip)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

ADDON = true;
