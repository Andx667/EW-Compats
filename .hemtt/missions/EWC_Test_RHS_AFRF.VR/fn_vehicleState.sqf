// Status text and on/off of the R-142N: the jammer follows the mast
params ["_vehicle"];

private _up = _vehicle doorPhase "mast_source" >= 0.99;
[format ["mast %1 | jammer %2", ["folded", "UP"] select _up, ["off", "ON"] select (_up && {!isNil {_vehicle getVariable "ewc_common_jammerState"}} && {(_vehicle getVariable "ewc_common_jammerState") select 0})], _up]
