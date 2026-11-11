#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Applies the exposure to the local player: a mild headache, and fatigue once the headache is bad enough.
 *
 * The headache is a rise of the pain of ACE medical towards exposure * maximum pain. ACE has no pain per body part, so it is
 * the general pain, and ACE adds its own effects for it. The pain is only topped up to that value and never above, so it
 * does not add to pain from wounds, and it fades by itself (ACE medical) once the exposure falls. The maximum is limited to
 * half of the pain above which ACE can make a unit unconscious, so the jammer alone never gets a player near it. Pain from a
 * wound that comes on top of it is added by ACE as usual and can go over.
 *
 * The fatigue starts when the pain of the jammer has reached the fatigue threshold, and grows with it from there. It is a
 * factor on the effort of every movement in ACE advanced fatigue, or a small rise of the vanilla fatigue without it.
 *
 * Raises the event ewc_rf_exposure_API_stageChanged when the stage of the exposure changes.
 *
 * Arguments:
 * 0: Unit, the local player <OBJECT>
 * 1: Seconds since the last update <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [ACE_player, 1] call ewc_rf_exposure_fnc_applyEffects
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]], ["_deltaTime", LOOP_INTERVAL, [0]]];

private _exposure = GVAR(exposure);
private _painMax = GVAR(painMax) min (MAX_PAIN_SHARE * (missionNamespace getVariable [ACE_VAR_PAIN_UNCONSCIOUS, ACE_PAIN_UNCONSCIOUS_DEFAULT]));
private _jammerPain = _exposure * _painMax;

// A new exposure tells the player again
if (_exposure < HINT_RESET_EXPOSURE) then {
    GVAR(hintedHeadache) = false;
    GVAR(hintedFatigue) = false;
};

// The headache. Not for somebody who is unconscious, ACE does not look at the pain of those
if (
    _jammerPain > 0
    && {!isNil "ace_medical_fnc_adjustPainLevel"}
    && {missionNamespace getVariable ["ace_medical_enabled", false]}
    && {alive _unit}
    && {!(_unit getVariable ["ACE_isUnconscious", false])}
) then {
    private _pain = _unit getVariable [ACE_VAR_PAIN, 0];

    if (_pain < _jammerPain) then {
        [_unit, _jammerPain - _pain] call ace_medical_fnc_adjustPainLevel;
    };

    if (!GVAR(hintedHeadache) && _exposure >= HINT_HEADACHE_EXPOSURE) then {
        GVAR(hintedHeadache) = true;
        hintSilent LLSTRING(hint_headache);
    };
};

// The fatigue: from the threshold to the maximum pain it goes from half to the full factor. A threshold above the maximum
// pain is never reached
private _threshold = GVAR(fatigueThreshold);
private _factor = 1;

if (GVAR(fatigueFactor) > 0 && _painMax >= _threshold && _jammerPain >= _threshold) then {
    private _share = if (_painMax > _threshold) then {
        linearConversion [_threshold, _painMax, _jammerPain, FATIGUE_START_SHARE, 1, true]
    } else {
        1
    };

    _factor = 1 + GVAR(fatigueFactor) * _share;

    if (!GVAR(hintedFatigue)) then {
        GVAR(hintedFatigue) = true;
        hintSilent LLSTRING(hint_fatigue);
    };
};

// The stage, for missions and mods: 0 none, 1 headache from HINT_HEADACHE_EXPOSURE (until the exposure is nearly gone), 2 fatigue
private _stage = 0;

if (_factor > 1) then {
    _stage = 2;
} else {
    if (_exposure >= HINT_HEADACHE_EXPOSURE || {GVAR(stage) >= 1 && _exposure >= HINT_RESET_EXPOSURE}) then {
        _stage = 1;
    };
};

if (_stage != GVAR(stage)) then {
    GVAR(stage) = _stage;

    [QGVAR(API_stageChanged), [_unit, _stage]] call CBA_fnc_localEvent;
};

// The duty factor functions are not public in ACE, but the only way to change its fatigue (ACE uses them itself in
// field_rations). Without them, here after a rename in ACE, the vanilla branch below has no effect under ACE fatigue
if (!isNil "ace_advanced_fatigue_fnc_addDutyFactor" && {missionNamespace getVariable ["ace_advanced_fatigue_enabled", false]}) then {
    // Only tell ACE about a change that matters, and about the end of the factor
    if (abs (_factor - GVAR(dutyFactor)) >= FATIGUE_FACTOR_STEP || {(_factor == 1) != (GVAR(dutyFactor) == 1)}) then {
        if (_factor == 1) then {
            [FATIGUE_FACTOR_ID] call ace_advanced_fatigue_fnc_removeDutyFactor;
        } else {
            [FATIGUE_FACTOR_ID, _factor] call ace_advanced_fatigue_fnc_addDutyFactor;
        };

        GVAR(dutyFactor) = _factor;
    };
} else {
    // Vanilla fatigue only exists with the stamina on
    if (_factor > 1 && {isStaminaEnabled _unit}) then {
        _unit setFatigue (((getFatigue _unit) + (_factor - 1) * VANILLA_FATIGUE_PER_SECOND * _deltaTime) min 1);
    };
};
