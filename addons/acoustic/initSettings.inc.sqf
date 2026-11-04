private _category = [LELSTRING(main,displayName), LLSTRING(category)];

[
    QGVAR(enable),
    "CHECKBOX",
    [LLSTRING(setting_enable), LLSTRING(setting_enable_tooltip)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

// cTab is only an option with its sub-addon (folder acoustic_ctab), which is skipped without cTab
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
    QGVAR(trackTimeout),
    "SLIDER",
    [LLSTRING(setting_trackTimeout), LLSTRING(setting_trackTimeout_tooltip)],
    _category,
    [5, 120, 30, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(maxRange),
    "SLIDER",
    [LLSTRING(setting_maxRange), LLSTRING(setting_maxRange_tooltip)],
    _category,
    [500, 10000, 4000, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(ambientNoise),
    "SLIDER",
    [LLSTRING(setting_ambientNoise), LLSTRING(setting_ambientNoise_tooltip)],
    _category,
    [20, 70, 35, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(reportFriendly),
    "CHECKBOX",
    [LLSTRING(setting_reportFriendly), LLSTRING(setting_reportFriendly_tooltip)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;
