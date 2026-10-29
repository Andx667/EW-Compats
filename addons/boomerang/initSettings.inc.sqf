private _category = [LELSTRING(main,displayName), LLSTRING(category)];

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

// cTab is only an option with its sub-addon (folder boomerang_ctab), which is skipped without cTab
private _targetValues = [MARKER_TARGET_NONE, MARKER_TARGET_MAP];
private _targetNames = [LLSTRING(target_none), LLSTRING(target_map)];

if (isClass (configFile >> "CfgPatches" >> "cTab_main")) then {
    _targetValues pushBack MARKER_TARGET_CTAB;
    _targetNames pushBack LLSTRING(target_ctab);
};

[
    QGVAR(markerTarget),
    "LIST",
    [LLSTRING(setting_markerTarget), LLSTRING(setting_markerTarget_tooltip)],
    _category,
    [_targetValues, _targetNames, MARKER_TARGET_MAP],
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

[
    QGVAR(actionMode),
    "LIST",
    [LLSTRING(setting_actionMode), LLSTRING(setting_actionMode_tooltip)],
    _category,
    [[ACTION_MODE_SCROLL, ACTION_MODE_ACE, ACTION_MODE_BOTH], [LLSTRING(mode_scroll), LLSTRING(mode_ace), LLSTRING(mode_both)], ACTION_MODE_SCROLL],
    false
] call CBA_fnc_addSetting;
