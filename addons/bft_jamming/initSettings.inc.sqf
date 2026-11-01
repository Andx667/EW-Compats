private _category = [LELSTRING(main,displayName), LLSTRING(category)];

// Global: every client works out the ghosts itself and has to get the same ones
[
    QGVAR(ghostRatio),
    "SLIDER",
    [LLSTRING(setting_ghostRatio), LLSTRING(setting_ghostRatio_tooltip)],
    _category,
    [0, 1, 0.33, 0, true],
    true
] call CBA_fnc_addSetting;
