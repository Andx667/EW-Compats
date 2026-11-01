#include "..\script_component.hpp"
/*
 * Author: Andx
 * Draws the debug overlay, called every frame by the Draw3D handler that fnc_debugToggle adds:
 * - over every vehicle with a Crows jammer or a system of this mod: the state of the jammer (radii, capabilities),
 *   of its switches and the lines of fnc_registerDebug, and rings on the ground for the full radius and the end of the falloff
 * - over IEDs within the full radius of an active jammer: jammed (simulation off) or armed
 * - over units and drones within the radii of an active jammer: the jam strength per signal (radio, BFT, drone)
 * Performance is no concern, this is for testing.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_common_fnc_debugDraw
 *
 * Public: No
 */

private _eye = positionCameraToWorld [0, 0, 0];

private _drawText = {
    params ["_position", "_text", "_color"];

    drawIcon3D ["", _color, _position, 0, 0, 0, _text, 2, 0.03, "PuristaMedium", "center"];
};

private _drawRing = {
    params ["_center", "_radius", "_color"];

    private _points = [];

    for "_i" from 0 to DEBUG_RING_SEGMENTS do {
        private _angle = 360 * _i / DEBUG_RING_SEGMENTS;
        private _x = (_center select 0) + _radius * sin _angle;
        private _y = (_center select 1) + _radius * cos _angle;

        _points pushBack (ASLToAGL [_x, _y, (getTerrainHeightASL [_x, _y]) + 0.3]);
    };

    for "_i" from 1 to count _points - 1 do {
        drawLine3D [_points select (_i - 1), _points select _i, _color];
    };
};

// Crows keeps the jammers in a public map. Each entry is [vehicle, falloff radius, full radius, enabled, capabilities]
private _jammers = (values (missionNamespace getVariable [CROWS_VAR_JAM_MAP, createHashMap])) select {!isNull (_x select 0)};
private _active = _jammers select {_x select 3};

// Vehicles: the ones with a jammer and the ones with a system of this mod
private _vehicles = (_jammers apply {_x select 0}) + (vehicles select {_x isKindOf "LandVehicle"});
_vehicles = _vehicles arrayIntersect _vehicles;

{
    private _vehicle = _x;

    if (_eye distance _vehicle < DEBUG_DISTANCE) then {
        // The systems of a vehicle do not change, so they are only looked for once
        private _systems = _vehicle getVariable QGVAR(debugSystems);

        if (isNil "_systems") then {
            _systems = [
                (keys GVAR(switches)) select {[_vehicle] call ((GVAR(switches) get _x) select 5)},
                (keys GVAR(debugProviders)) select {[_vehicle] call ((GVAR(debugProviders) get _x) select 0)}
            ];
            _vehicle setVariable [QGVAR(debugSystems), _systems];
        };

        _systems params ["_switchIds", "_providerIds"];

        private _jammerIndex = _jammers findIf {(_x select 0) isEqualTo _vehicle};
        private _jammer = [[], _jammers param [_jammerIndex, []]] select (_jammerIndex != -1);

        if (_jammer isNotEqualTo [] || {_switchIds isNotEqualTo []} || {_providerIds isNotEqualTo []}) then {
            private _lines = [[format ["%1 (%2)", getText (configOf _vehicle >> "displayName"), typeOf _vehicle], [1, 1, 1, 1]]];

            if (_jammer isNotEqualTo []) then {
                _jammer params ["", "_falloffRadius", "_radius", "_enabled", "_capabilities"];

                _lines pushBack [
                    format ["jammer %1 | %2 m, falloff to %3 m | %4", ["off", "ON"] select _enabled, round _radius, round (_falloffRadius max _radius), _capabilities joinString ", "],
                    [[0.8, 0.8, 0.8, 1], [0.3, 1, 0.3, 1]] select _enabled
                ];

                if (_enabled) then {
                    private _center = getPosASL _vehicle;

                    [_center, _radius, [0.3, 1, 0.3, 1]] call _drawRing;

                    if (_falloffRadius > _radius) then {
                        [_center, _falloffRadius, [1, 0.8, 0.2, 0.5]] call _drawRing;
                    };
                };
            };

            {
                private _on = _vehicle getVariable [(GVAR(switches) get _x) select 1, false];

                _lines pushBack [format ["%1 %2", _x, ["off", "ON"] select _on], [[0.8, 0.8, 0.8, 1], [0.3, 1, 0.3, 1]] select _on];
            } forEach _switchIds;

            {
                {
                    _lines pushBack [_x, [0.8, 0.8, 0.8, 1]];
                } forEach ([_vehicle] call ((GVAR(debugProviders) get _x) select 1));
            } forEach _providerIds;

            private _top = (_vehicle modelToWorldVisual [0, 0, 0]) vectorAdd [0, 0, 3.5];
            private _count = count _lines;

            {
                _x params ["_text", "_color"];

                [_top vectorAdd [0, 0, (_count - 1 - _forEachIndex) * DEBUG_LINE_HEIGHT], _text, _color] call _drawText;
            } forEach _lines;
        };
    };
} forEach _vehicles;

if (_active isEqualTo []) exitWith {};

// IEDs within the full radius of an active jammer. Jammers disable them by turning their simulation off
{
    private _mine = _x;

    if (
        _eye distance _mine < DEBUG_DISTANCE
        && {DEBUG_MINE_CLASSES findIf {_mine isKindOf _x} != -1}
        && {_active findIf {(_mine distance2D (_x select 0)) <= (_x select 2)} != -1}
    ) then {
        private _jammed = !simulationEnabled _mine;
        private _title = getText (configOf _mine >> "displayName");

        [
            (getPosATL _mine) vectorAdd [0, 0, 1.2],
            format ["%1: %2", _title, ["in range, armed", "JAMMED (simulation off)"] select _jammed],
            [[1, 0.8, 0.2, 1], [1, 0.2, 0.2, 1]] select _jammed
        ] call _drawText;
    };
} forEach allMines;

// Units on foot and drones within the radii of an active jammer
private _targets = (allUnits select {alive _x && {isNull objectParent _x}}) + (vehicles select {unitIsUAV _x && {alive _x}});

{
    private _target = _x;

    if (_eye distance _target < DEBUG_UNIT_DISTANCE) then {
        // Signal -> strongest jam strength: 1 within the full radius, fading to 0 at the end of the falloff
        private _strengths = createHashMap;
        private _isDrone = unitIsUAV _target;

        {
            _x params ["_jammerVehicle", "_falloffRadius", "_radius", "", "_capabilities"];

            if (_jammerVehicle isNotEqualTo _target) then {
                private _distance = (getPosASL _jammerVehicle) distance (getPosASL _target);
                private _strength = linearConversion [_radius, _falloffRadius max (_radius + 1), _distance, 1, 0, true];

                if (_strength > 0) then {
                    {
                        private _signal = switch (true) do {
                            case (_x isEqualTo CROWS_CAPABILITY_RADIO): {["", "radio"] select !_isDrone};
                            case (_x isEqualTo CROWS_CAPABILITY_DRONE): {["", "drone"] select _isDrone};
                            case ((_x select [0, 9]) isEqualTo "BftJammer"): {["", "BFT"] select !_isDrone};
                            default {""};
                        };

                        if (_signal isNotEqualTo "") then {
                            _strengths set [_signal, _strength max (_strengths getOrDefault [_signal, 0])];
                        };
                    } forEach _capabilities;
                };
            };
        } forEach _active;

        private _lines = [];

        {
            _lines pushBack [
                [format ["%1 jam %2%3", _x, round (_y * 100), "%"], format ["%1 JAMMED", _x]] select (_y >= 1),
                [[1, 0.6, 0.2, 1], [1, 0.2, 0.2, 1]] select (_y >= 1)
            ];
        } forEach _strengths;

        private _top = (ASLToAGL (getPosASLVisual _target)) vectorAdd [0, 0, [2.2, 1.5] select _isDrone];
        private _count = count _lines;

        {
            _x params ["_text", "_color"];

            [_top vectorAdd [0, 0, (_count - 1 - _forEachIndex) * DEBUG_LINE_HEIGHT], _text, _color] call _drawText;
        } forEach _lines;
    };
} forEach _targets;
