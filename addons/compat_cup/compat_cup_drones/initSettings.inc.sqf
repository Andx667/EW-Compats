private _category = [LELSTRING(main,displayName), LLSTRING(drones_category)];

[
    QGVAR(drones_enable),
    "CHECKBOX",
    [LLSTRING(drones_setting_enable), LLSTRING(drones_setting_enable_tooltip)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(drones_range),
    "SLIDER",
    [LLSTRING(drones_setting_range), LLSTRING(drones_setting_range_tooltip)],
    _category,
    [300, 10000, 3000, 0],
    true
] call CBA_fnc_addSetting;
