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
    QGVAR(friendlyFire),
    "CHECKBOX",
    [LLSTRING(setting_friendlyFire), LLSTRING(setting_friendlyFire_tooltip)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(missDistance),
    "SLIDER",
    [LLSTRING(setting_missDistance), LLSTRING(setting_missDistance_tooltip)],
    _category,
    [10, 150, 30, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(lockout),
    "SLIDER",
    [LLSTRING(setting_lockout), LLSTRING(setting_lockout_tooltip)],
    _category,
    [1, 30, 5, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(markerLifetime),
    "SLIDER",
    [LLSTRING(setting_markerLifetime), LLSTRING(setting_markerLifetime_tooltip)],
    _category,
    [0, 120, 30, 0],
    false
] call CBA_fnc_addSetting;
