#include "..\script_component.hpp"
/*
 * Author: Andx
 * Ends the tracks of drones that no sensor has heard for the track timeout, or all of them. Raises ewc_acoustic_trackLost
 * on the server and on the machines the track was last sent to.
 *
 * Arguments:
 * 0: End all tracks <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ewc_acoustic_fnc_dropTracks
 *
 * Public: No
 */

params [["_all", false, [false]]];

private _expired = [];

{
    if (_all || {CBA_missionTime - (_y select 7) > GVAR(trackTimeout)}) then {
        _expired pushBack _x;

        private _payload = [_y select 0, _y select 1];

        [QGVAR(trackLost), _payload] call CBA_fnc_localEvent;

        {
            [QGVAR(trackLost), _payload, _x] call CBA_fnc_ownerEvent;
        } forEach (_y select 8);
    };
} forEach GVAR(tracks);

{
    GVAR(tracks) deleteAt _x;
} forEach _expired;
