private _category = [LELSTRING(main,displayName), LLSTRING(category)];

[
    QGVAR(enableCG13),
    "CHECKBOX",
    [LLSTRING(setting_enableCG13), LLSTRING(setting_enableCG13_tooltip)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;
