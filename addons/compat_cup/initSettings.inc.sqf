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
    QGVAR(enableDuke),
    "CHECKBOX",
    [LLSTRING(setting_enableDuke), LLSTRING(setting_enableDuke_tooltip)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(enableBoomerang),
    "CHECKBOX",
    [LLSTRING(setting_enableBoomerang), LLSTRING(setting_enableBoomerang_tooltip)],
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

[
    QGVAR(requireEngine),
    "CHECKBOX",
    [LLSTRING(setting_requireEngine), LLSTRING(setting_requireEngine_tooltip)],
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
    [10, 150, 50, 0],
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
