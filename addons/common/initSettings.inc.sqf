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
    QGVAR(debug),
    "CHECKBOX",
    [LLSTRING(setting_debug), LLSTRING(setting_debug_tooltip)],
    _category,
    false,
    false,
    LINKFUNC(debugToggle)
] call CBA_fnc_addSetting;
