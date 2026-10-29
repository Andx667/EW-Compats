private _category = [LELSTRING(main,displayName), LLSTRING(category)];

[
    QGVAR(duke_enable),
    "CHECKBOX",
    [LLSTRING(duke_setting_enable), LLSTRING(duke_setting_enable_tooltip)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(duke_radius),
    "SLIDER",
    [LLSTRING(duke_setting_radius), LLSTRING(duke_setting_radius_tooltip)],
    _category,
    [10, 200, 50, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(duke_jamMines),
    "CHECKBOX",
    [LLSTRING(duke_setting_jamMines), LLSTRING(duke_setting_jamMines_tooltip)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;
