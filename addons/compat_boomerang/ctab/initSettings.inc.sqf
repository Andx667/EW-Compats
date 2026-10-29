private _category = [LELSTRING(main,displayName), LELSTRING(compat_boomerang,category)];

[
    QGVAR(ctab_markerTarget),
    "LIST",
    [LSUBLSTRING(setting_markerTarget), LSUBLSTRING(setting_markerTarget_tooltip)],
    _category,
    [[MARKER_TARGET_MAP, MARKER_TARGET_CTAB, MARKER_TARGET_BOTH], [LSUBLSTRING(target_map), LSUBLSTRING(target_ctab), LSUBLSTRING(target_both)], MARKER_TARGET_BOTH],
    true
] call CBA_fnc_addSetting;
