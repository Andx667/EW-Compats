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
    QGVAR(requireEngine),
    "CHECKBOX",
    [LLSTRING(setting_requireEngine), LLSTRING(setting_requireEngine_tooltip)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;
