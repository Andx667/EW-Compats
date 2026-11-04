private _category = [LELSTRING(main,displayName), LLSTRING(category)];

// All the settings are global: the server decides, so everybody gets the same rules
[
    QGVAR(enable),
    "CHECKBOX",
    [LLSTRING(setting_enable), LLSTRING(setting_enable_tooltip)],
    _category,
    false,
    true,
    LINKFUNC(updateLoop)
] call CBA_fnc_addSetting;

[
    QGVAR(sources),
    "LIST",
    [LLSTRING(setting_sources), LLSTRING(setting_sources_tooltip)],
    _category,
    [[SOURCES_ALL, SOURCES_VEHICLES], [LLSTRING(sources_all), LLSTRING(sources_vehicles)], SOURCES_ALL],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(nearRadius),
    "SLIDER",
    [LLSTRING(setting_nearRadius), LLSTRING(setting_nearRadius_tooltip)],
    _category,
    [0.5, 20, 2, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(farRadius),
    "SLIDER",
    [LLSTRING(setting_farRadius), LLSTRING(setting_farRadius_tooltip)],
    _category,
    [1, 50, 5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(nearTime),
    "SLIDER",
    [LLSTRING(setting_nearTime), LLSTRING(setting_nearTime_tooltip)],
    _category,
    [60, 7200, 900, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(farTime),
    "SLIDER",
    [LLSTRING(setting_farTime), LLSTRING(setting_farTime_tooltip)],
    _category,
    [60, 14400, 1800, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(recoveryTime),
    "SLIDER",
    [LLSTRING(setting_recoveryTime), LLSTRING(setting_recoveryTime_tooltip)],
    _category,
    [30, 3600, 300, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(painMax),
    "SLIDER",
    [LLSTRING(setting_painMax), LLSTRING(setting_painMax_tooltip)],
    _category,
    [0.05, 0.5, 0.25, 2],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(fatigueThreshold),
    "SLIDER",
    [LLSTRING(setting_fatigueThreshold), LLSTRING(setting_fatigueThreshold_tooltip)],
    _category,
    [0.05, 0.5, 0.15, 2],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(fatigueFactor),
    "SLIDER",
    [LLSTRING(setting_fatigueFactor), LLSTRING(setting_fatigueFactor_tooltip)],
    _category,
    [0, 3, 0.5, 1],
    true
] call CBA_fnc_addSetting;
