// Status text and on/off of the DUKE and the Boomerang
params ["_vehicle"];

private _duke = _vehicle getVariable ["RHS_DUKE_OP", false];
if !(_duke isEqualType true) then { _duke = _duke isEqualTo 1 };
private _boomerang = _vehicle getVariable ["ewc_compat_boomerang_on", false];
private _deaf = (_vehicle getVariable ["ewc_compat_boomerang_deafUntil", 0]) > CBA_missionTime;

[format ["DUKE %1 | Boomerang %2%3 | engine %4", ["off", "ON"] select _duke, ["off", "ON"] select _boomerang, ["", " (deaf)"] select (_boomerang && _deaf), ["off", "on"] select isEngineOn _vehicle], _duke || _boomerang]
