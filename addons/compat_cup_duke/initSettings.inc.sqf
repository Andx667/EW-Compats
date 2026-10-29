private _category = [LELSTRING(main,displayName), LELSTRING(compat_cup,category)];

[
    QGVAR(enable),
    "CHECKBOX",
    [LLSTRING(setting_enable), LLSTRING(setting_enable_tooltip)],
    _category,
    true,
    true
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
