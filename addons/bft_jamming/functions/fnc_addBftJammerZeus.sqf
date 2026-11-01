#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Zeus module "Set as BFT Jammer": asks for the jammer settings in a ZEN dialog and registers the selected object, or a
 * data terminal spawned at the position (as the module of the editor and the jammer module of Crows do), as a BFT jammer.
 *
 * Arguments:
 * 0: Position the module was placed at, ASL <ARRAY>
 * 1: Object the module was placed on <OBJECT> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [getPosASL player, objNull] call ewc_bft_jamming_fnc_addBftJammerZeus
 *
 * Public: No
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_unit", objNull, [objNull]]];

private _onConfirm = {
    params ["_dialogResult", "_in"];
    _dialogResult params ["_jamType", "_isActive", "_radEffective", "_radFalloff", "_frequency"];
    _in params [["_pos", [0, 0, 0], [[]], 3], ["_unit", objNull, [objNull]]];

    // No object selected: spawn a data terminal at the position, Zeus can edit it
    if (isNull _unit) then {
        _unit = createVehicle ["Crows_dataterminal", ASLToAGL _pos, [], 0, "NONE"];

        ["zen_common_addObjects", [[_unit], objNull]] call CBA_fnc_serverEvent;
    };

    [_unit, _jamType, _radEffective, _radFalloff, _frequency, _isActive] call FUNC(registerBftJammer);
};

[
    LLSTRING(moduleAddBftJammer_displayName),
    [
        [
            "COMBO",
            [LLSTRING(moduleAddBftJammer_jamType_displayName), LLSTRING(moduleAddBftJammer_jamType_tooltip)],
            [
                [BFT_JAM_TYPE_BLACKOUT, BFT_JAM_TYPE_DRIFT, BFT_JAM_TYPE_MIXED],
                [LLSTRING(moduleAddBftJammer_jamType_blackout), LLSTRING(moduleAddBftJammer_jamType_drift), LLSTRING(moduleAddBftJammer_jamType_mixed)],
                BFT_JAM_TYPE_BLACKOUT
            ]
        ],
        [
            "CHECKBOX",
            [LLSTRING(zeus_active_displayName), LLSTRING(zeus_active_tooltip)],
            [true]
        ],
        [
            "SLIDER",
            [LLSTRING(moduleAddBftJammer_effectiveRadius_displayName), LLSTRING(moduleAddBftJammer_effectiveRadius_tooltip)],
            [BFT_JAM_MIN_RADIUS, BFT_JAM_MAX_RADIUS, BFT_JAM_DEFAULT_EFFECTIVE_RADIUS, 0]
        ],
        [
            "SLIDER",
            [LLSTRING(moduleAddBftJammer_falloffRadius_displayName), LLSTRING(moduleAddBftJammer_falloffRadius_tooltip)],
            [BFT_JAM_MIN_RADIUS, BFT_JAM_MAX_RADIUS, BFT_JAM_DEFAULT_FALLOFF_RADIUS, 0]
        ],
        [
            "SLIDER",
            [LLSTRING(moduleAddBftJammer_frequency_displayName), LLSTRING(zeus_frequency_tooltip)],
            [BFT_JAM_MIN_FREQUENCY, BFT_JAM_MAX_FREQUENCY, BFT_JAM_DEFAULT_FREQUENCY, 0]
        ]
    ],
    _onConfirm,
    {},
    [_pos, _unit]
] call zen_dialog_fnc_create;
