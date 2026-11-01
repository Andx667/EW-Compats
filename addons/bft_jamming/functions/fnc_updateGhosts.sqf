#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * CLIENT ONLY. Adds the ghosts of Spoof jammers to the BFT lists of cTab (called by fnc_onBftListsUpdated after the
 * jamming). A viewer inside the effective radius of an active Spoof jammer sees a ghost of some of the groups and
 * vehicles of its own list: a copy of the entry on a position displaced by a fixed offset of 150 to 400 m, that moves
 * with the unit it copies and has a changed callsign. Which units have a ghost and where is worked out from the net IDs
 * (fnc_ghostRandom), so every client gets the same ghosts without anything being synced. The setting
 * ewc_bft_jamming_ghostRatio is the share of units that have one.
 *
 * Ghosts are only made of groups and vehicles, never of the members of the group of the viewer. cTab draws those from
 * the live position of the unit, and it draws a group or a vehicle from the live position of the first object of its
 * entry in "realTime" mode, which is why every ghost has a local stand-in object (GVAR(ghosts), key -> [stand-in,
 * unit it copies, offset]). A group whose leader sits in a vehicle has none, the vehicle covers it.
 * With few units the share can come out as none, so every jammer has at least one ghost. A ghost only goes when its jammer is switched off, destroyed or the viewer leaves the radius.
 *
 * Arguments:
 * 0: Active BFT jammers, each [unit, radFalloff, radEffective, enabled, capabilities] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_jammers] call ewc_bft_jamming_fnc_updateGhosts
 *
 * Public: No
 */

params [["_jammers", [], [[]]]];

private _viewer = missionNamespace getVariable ["cTab_player", player];

if (isNull _viewer) then {
    _viewer = player;
};

private _viewerVehicle = vehicle _viewer;
private _viewerPos = getPosASL _viewerVehicle;

private _spoofers = _jammers select {
    (BFT_JAM_CAP_SPOOF in (_x select 4)) && {_viewerPos distance (getPosASL (_x select 0)) <= (_x select 2)}
};

// Key -> [list tag, entry, unit it copies]
private _wanted = createHashMap;
private _eligibleCount = 0;

if (_spoofers isNotEqualTo [] && {GVAR(ghostRatio) > 0}) then {
    private _sources = (cTabBFTgroups apply {["g", _x]}) + (cTabBFTvehicles apply {["v", _x]});

    {
        private _spoofer = _x select 0;
        private _spooferId = netId _spoofer;

        // Key -> [number of the key, what a ghost needs], for all units this jammer could make a ghost of
        private _eligible = createHashMap;

        {
            _x params ["_tag", "_entry"];

            private _source = _entry select 0;

            if (
                !isNull _source
                && {_source isNotEqualTo _spoofer}
                && {_source isNotEqualTo _viewerVehicle}
                && {group _source isNotEqualTo group _viewer}
                && {_tag == "v" || {vehicle _source isEqualTo _source}}
            ) then {
                private _key = format ["%1_%2_%3", _tag, netId _source, _spooferId];

                _eligible set [_key, [[_key, "pick"] call FUNC(ghostRandom), [_tag, _entry, _source]]];
            };
        } forEach _sources;

        _eligibleCount = _eligibleCount + count _eligible;

        // The share of units with a ghost. With few units the share can come out as none, so the jammer always
        // has at least one: the unit with the lowest number
        private _lowest = [2, ""];

        {
            if ((_y select 0) < GVAR(ghostRatio)) then {
                _wanted set [_x, _y select 1];
            };

            if ((_y select 0) < (_lowest select 0)) then {
                _lowest = [_y select 0, _x];
            };
        } forEach _eligible;

        if ((_lowest select 1) isNotEqualTo "") then {
            _wanted set [_lowest select 1, (_eligible get (_lowest select 1)) select 1];
        };
    } forEach _spoofers;
};

{
    if !(_x in _wanted) then {
        deleteVehicle ((GVAR(ghosts) get _x) select 0);
        GVAR(ghosts) deleteAt _x;
    };
} forEach (keys GVAR(ghosts));

private _groupGhosts = [];
private _vehicleGhosts = [];

{
    _y params ["_tag", "_entry", "_source"];

    private _ghost = GVAR(ghosts) getOrDefault [_x, []];

    if (_ghost isEqualTo []) then {
        // Local and invisible, only there so cTab has a position to read
        private _dummy = createSimpleObject [BFT_JAM_GHOST_CLASS, [0, 0, 0], true];
        _dummy hideObject true;

        private _angle = 360 * ([_x, "angle"] call FUNC(ghostRandom));
        private _distance = linearConversion [0, 1, [_x, "distance"] call FUNC(ghostRandom), BFT_JAM_GHOST_MIN_OFFSET, BFT_JAM_GHOST_MAX_OFFSET];

        _ghost = [_dummy, _source, [_distance * sin _angle, _distance * cos _angle, 0]];
        GVAR(ghosts) set [_x, _ghost];
    };

    _ghost params ["_dummy", "", "_offset"];

    _dummy setPosASL ((getPosASL _source) vectorAdd _offset);
    _dummy setDir direction _source;

    private _copy = +_entry;
    _copy set [0, _dummy];
    _copy set [3, [_entry select 3, _x] call FUNC(ghostCallsign)];
    _copy set [5, (_entry select 5) vectorAdd _offset];

    ([_groupGhosts, _vehicleGhosts] select (_tag == "v")) pushBack _copy;
} forEach _wanted;

// For the debug overlay: Spoof jammers around the viewer, units they could copy, ghosts
GVAR(ghostStats) = [count _spoofers, _eligibleCount, count _wanted];

cTabBFTgroups = cTabBFTgroups + _groupGhosts;
cTabBFTvehicles = cTabBFTvehicles + _vehicleGhosts;

// The stand-ins follow their units while there are any
if (count GVAR(ghosts) > 0 && {GVAR(ghostHandle) < 0}) then {
    GVAR(ghostHandle) = [LINKFUNC(moveGhosts), BFT_JAM_GHOST_MOVE_INTERVAL] call CBA_fnc_addPerFrameHandler;
};

if (count GVAR(ghosts) == 0 && {GVAR(ghostHandle) >= 0}) then {
    [GVAR(ghostHandle)] call CBA_fnc_removePerFrameHandler;
    GVAR(ghostHandle) = -1;
};
