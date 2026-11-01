private _category = [LELSTRING(main,displayName), LLSTRING(category)];

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
    [100, 2000, JAMMER_DEFAULT_RADIUS, 0],
    true
] call CBA_fnc_addSetting;
