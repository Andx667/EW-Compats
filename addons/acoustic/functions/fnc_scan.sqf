#include "..\script_component.hpp"
/*
 * Author: Andx
 * Scan of the server, every SCAN_INTERVAL s while there are sensors or tracks: every sensor listens for every drone in
 * range, the sensors of a side that hear a drone are combined into one position fix and the track of that drone
 * for that side is updated. Drones that are not heard any more lose their track after the track timeout.
 * The weather and the noise at a sensor are read once per scan, the noise only for sensors with a drone in range.
 *
 * Arguments:
 * 0: Arguments of the handler (unused) <ARRAY>
 * 1: Handle of the per frame handler <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[], _handle] call ewc_acoustic_fnc_scan
 *
 * Public: No
 */

params ["", ["_handle", -1, [0]]];

// A destroyed or deleted sensor stops for good
GVAR(sensors) = GVAR(sensors) select {alive _x};

if (GVAR(sensors) isEqualTo [] && {count GVAR(tracks) == 0}) exitWith {
    [_handle] call CBA_fnc_removePerFrameHandler;
    GVAR(scanHandle) = -1;
};

if (!GVAR(enable)) exitWith {
    [true] call FUNC(dropTracks);
};

// Drones in the air make the sound, a drone on the ground with its engine off does not
private _drones = allUnitsUAV select {alive _x && {_x isKindOf "Air"} && {isEngineOn _x}};

// A number per drone names its tracks, only the server needs it
{
    if (isNil {_x getVariable QGVAR(droneId)}) then {
        GVAR(droneCounter) = GVAR(droneCounter) + 1;
        _x setVariable [QGVAR(droneId), GVAR(droneCounter)];
    };
} forEach _drones;

if (_drones isNotEqualTo []) then {
    private _weather = call FUNC(getWeather);
    private _absorptionCache = createHashMap;
    private _maxRangeSqr = GVAR(maxRange) ^ 2;

    // "<side>:<drone ID>" -> [side, drone, measurements]
    private _heard = createHashMap;

    {
        private _sensor = _x;
        private _side = _sensor getVariable [QGVAR(side), sideUnknown];
        private _mic = (getPosASL _sensor) vectorAdd [0, 0, MIC_HEIGHT];
        private _noise = nil;

        {
            private _drone = _x;

            // A UAV used as a sensor would hear its own engine, getNoiseLevel skips UAVs so nothing masks it
            if (
                _drone isNotEqualTo _sensor
                && {(_mic vectorDistanceSqr getPosASL _drone) <= _maxRangeSqr}
                && {GVAR(reportFriendly) || {(_side getFriend side group _drone) < 0.6}}
            ) then {
                if (isNil "_noise") then {
                    _noise = [_mic, _weather] call FUNC(getNoiseLevel);
                };

                private _measurement = [_mic, _noise, _drone, _weather, _absorptionCache] call FUNC(hearDrone);

                if (_measurement isNotEqualTo []) then {
                    _measurement pushBack _sensor;

                    private _key = format ["%1:%2", _side, _drone getVariable QGVAR(droneId)];

                    if (_key in _heard) then {
                        ((_heard get _key) select 2) pushBack _measurement;
                    } else {
                        _heard set [_key, [_side, _drone, [_measurement]]];
                    };
                };
            };
        } forEach _drones;
    } forEach GVAR(sensors);

    {
        _y params ["_side", "_drone", "_measurements"];

        ([_measurements] call FUNC(estimatePosition)) params ["_fix", "_triangulated"];

        // The fix is as old as the sound the closest sensor heard, the best sensor names the creator on cTab
        private _delay = selectMin (_measurements apply {_x select 6});
        private _best = _measurements select 0;

        {
            if ((_x select 5) > (_best select 5)) then {
                _best = _x;
            };
        } forEach _measurements;

        [_x, _side, _drone, _fix, _triangulated, CBA_missionTime - _delay, _best select 7] call FUNC(updateTrack);
    } forEach _heard;
};

[] call FUNC(dropTracks);
