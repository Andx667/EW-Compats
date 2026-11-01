#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Per frame handler while ghosts exist. Keeps the stand-in object of every ghost on its displaced position. In
 * "realTime" mode cTab reads the position of the object in the BFT list live, so the object has to follow the
 * unit it copies between two pulses of the lists.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ewc_bft_jamming_fnc_moveGhosts
 *
 * Public: No
 */

{
    _y params ["_dummy", "_source", "_offset"];

    if (!isNull _dummy && {!isNull _source}) then {
        _dummy setPosASL ((getPosASL _source) vectorAdd _offset);
        _dummy setDir direction _source;
    };
} forEach GVAR(ghosts);
