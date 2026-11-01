private _category = [LELSTRING(main,displayName), LLSTRING(category)];

[
    QGVAR(enableDuke),
    "CHECKBOX",
    [LLSTRING(setting_enableDuke), LLSTRING(setting_enableDuke_tooltip)],
    _category,
    true,
    true,
    LINKFUNC(duke_onSettingChanged)
] call CBA_fnc_addSetting;
