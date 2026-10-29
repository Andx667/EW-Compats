// Status text and on/off of the DUKE
params ["_vehicle"];

private _on = _vehicle getVariable ["RHS_DUKE_OP", false];
if !(_on isEqualType true) then { _on = _on isEqualTo 1 };
[format ["DUKE %1 | engine %2", ["off", "ON"] select _on, ["off", "on"] select isEngineOn _vehicle], _on]
