private _category = [LELSTRING(main,displayName), LLSTRING(category)];

[
    QGVAR(allowBoth),
    "CHECKBOX",
    [LLSTRING(setting_allowBoth), LLSTRING(setting_allowBoth_tooltip)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;
