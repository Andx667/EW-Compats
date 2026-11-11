#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Zeus module "Set as Wi-Fi Jammer": asks for the jammer settings in a ZEN dialog and registers the selected object, or a
 * data terminal spawned at the position, as a Wi-Fi jammer.
 *
 * Arguments:
 * 0: Position the module was placed at, ASL <ARRAY>
 * 1: Object the module was placed on <OBJECT> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [getPosASL player, objNull] call ewc_wifi_jamming_fnc_addWifiJammerZeus
 *
 * Public: No
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_unit", objNull, [objNull]]];

private _onConfirm = {
    params ["_dialogResult", "_in"];
    _dialogResult params ["_isActive", "_radEffective", "_radFalloff", "_frequency"];
    _in params [["_pos", [0, 0, 0], [[]], 3], ["_unit", objNull, [objNull]]];

    // No object selected: spawn a data terminal at the position, Zeus can edit it
    if (isNull _unit) then {
        _unit = createVehicle ["Crows_dataterminal", ASLToAGL _pos, [], 0, "NONE"];

        ["zen_common_addObjects", [[_unit], objNull]] call CBA_fnc_serverEvent;
    };

    [_unit, _radEffective, _radFalloff, _frequency, _isActive] call FUNC(registerWifiJammer);
};

[
    LLSTRING(moduleAddWifiJammer_displayName),
    [
        [
            "CHECKBOX",
            [LLSTRING(zeus_active_displayName), LLSTRING(zeus_active_tooltip)],
            [true]
        ],
        [
            "SLIDER",
            [LLSTRING(moduleAddWifiJammer_effectiveRadius_displayName), LLSTRING(moduleAddWifiJammer_effectiveRadius_tooltip)],
            [WIFI_JAM_MIN_RADIUS, WIFI_JAM_MAX_RADIUS, WIFI_JAM_DEFAULT_EFFECTIVE_RADIUS, 0]
        ],
        [
            "SLIDER",
            [LLSTRING(moduleAddWifiJammer_falloffRadius_displayName), LLSTRING(moduleAddWifiJammer_falloffRadius_tooltip)],
            [0, WIFI_JAM_MAX_RADIUS, WIFI_JAM_DEFAULT_FALLOFF_RADIUS, 0]
        ],
        [
            "SLIDER",
            [LLSTRING(moduleAddWifiJammer_frequency_displayName), LLSTRING(zeus_frequency_tooltip)],
            [WIFI_JAM_MIN_FREQUENCY, WIFI_JAM_MAX_FREQUENCY, WIFI_JAM_DEFAULT_FREQUENCY, 0]
        ]
    ],
    _onConfirm,
    {},
    [_pos, _unit]
] call zen_dialog_fnc_create;
