#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * How fast a unit is exposed, as the share of a full exposure per second, from the strongest of the jammers that count.
 * Within the near radius a full exposure takes the near time, at the far radius the far time, in between the rate falls
 * linearly, and beyond the far radius there is none. With the defaults that is 15 minutes within 2 m and 30 minutes at 5 m.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Exposure per second, 0 for none <NUMBER>
 *
 * Example:
 * [player] call ewc_rf_exposure_fnc_getRate
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]]];

private _nearRadius = GVAR(nearRadius);
private _farRadius = GVAR(farRadius) max _nearRadius;
private _nearRate = 1 / GVAR(nearTime);
private _farRate = 1 / GVAR(farTime);
private _rate = 0;

{
    _x params ["_jammer", "", "_boundingRadius"];

    if (JAMMER_COUNTS(_x)) then {
        // Far from the jammer, no need to work out the distance to its hull
        if ((_unit distance _jammer) <= (_farRadius + _boundingRadius)) then {
            private _distance = [_unit, _jammer] call FUNC(getDistance);

            if (_distance <= _farRadius) then {
                private _jammerRate = if (_distance <= _nearRadius) then {
                    _nearRate
                } else {
                    linearConversion [_nearRadius, _farRadius, _distance, _nearRate, _farRate]
                };

                _rate = _rate max _jammerRate;
            };
        };
    };
} forEach GVAR(jammers);

_rate
