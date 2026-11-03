#include "..\script_component.hpp"
/*
 * Author: Andx
 * Acoustic signature of a drone: its source level, dominant frequency and kind. The closest entry of the drone class
 * or a parent in CfgEWC >> AcousticSignatures counts. Without one the value is chosen by kind and mass: small
 * and larger electric multirotors, turbine helicopters, small electric planes, piston propeller planes and jets.
 * Cached per class.
 *
 * Arguments:
 * 0: Drone <OBJECT>
 *
 * Return Value:
 * Signature <ARRAY>
 * 0: Source level in dB at 1 m <NUMBER>
 * 1: Dominant frequency in Hz <NUMBER>
 * 2: Kind, DRONE_KIND_ROTARY or DRONE_KIND_FIXED <NUMBER>
 *
 * Example:
 * [_drone] call ewc_acoustic_fnc_getSignature
 *
 * Public: No
 */

params [["_drone", objNull, [objNull]]];

private _class = typeOf _drone;
private _cached = GVAR(signatureCache) get _class;

if (!isNil "_cached") exitWith {_cached};

// DRONE_KIND_ROTARY is 1, DRONE_KIND_FIXED 0
private _kind = parseNumber (_drone isKindOf "Helicopter");
private _registry = configFile >> "CfgEWC" >> "AcousticSignatures";
private _config = configOf _drone;
private _signature = [];

// Entries of parents are not listed as entries of the children, so the inheritance is walked up
while {_signature isEqualTo [] && {!isNull _config}} do {
    private _entry = _registry >> configName _config;

    if (isClass _entry) then {
        _signature = [getNumber (_entry >> "level"), getNumber (_entry >> "frequency")];
    };

    _config = inheritsFrom _config;
};

if (_signature isEqualTo []) then {
    private _mass = getMass _drone;

    _signature = if (_kind == DRONE_KIND_ROTARY) then {
        [SIGNATURE_TURBINE_ROTOR, [SIGNATURE_LARGE_ROTOR, SIGNATURE_SMALL_ROTOR] select (_mass < SIGNATURE_SMALL_MASS)] select (_mass < SIGNATURE_LARGE_ROTOR_MASS)
    } else {
        [SIGNATURE_JET_WING, [SIGNATURE_PISTON_WING, SIGNATURE_SMALL_WING] select (_mass < SIGNATURE_SMALL_MASS)] select (_mass < SIGNATURE_LARGE_WING_MASS)
    };

    // The array of the macro is a constant of the compiled script, pushBack below must not change it
    _signature = +_signature;
};

_signature pushBack _kind;

GVAR(signatureCache) set [_class, _signature];

_signature
