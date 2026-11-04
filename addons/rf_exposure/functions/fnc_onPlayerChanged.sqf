#include "..\script_component.hpp"
/*
 * Author: Andx
 *
 * Handler of the CBA player event "unit": a new unit (respawn, Zeus remote control, switch of unit) starts without
 * exposure. The loop starts again when a jammer is on.
 *
 * Arguments:
 * 0: New unit <OBJECT>
 * 1: Old unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, objNull] call ewc_rf_exposure_fnc_onPlayerChanged
 *
 * Public: No
 */

call FUNC(reset);
call FUNC(updateLoop);
