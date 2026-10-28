// Status text and on/off of the CG13
params ["_vehicle"];

private _on = _vehicle getVariable ["BWA3_Dingo2_ECM_on", false];
[format ["CG13 %1 | engine %2", ["off", "ON"] select _on, ["off", "on"] select isEngineOn _vehicle], _on]
