/*
 * EWC jammer start-up benchmark
 *
 * Measures what it costs to have many jammer vehicles: the frames after N of them appear at once (the same as a mission
 * that starts with N of them) and the frames while their jammers are switched on one by one. Run it once on the build
 * before the change and once on the build after it, then compare the numbers.
 *
 * How to run:
 *   1. Host a LAN mission with Crows Electronic Warfare and the compat addon of the vehicles (any of the test missions of
 *      .hemtt/missions will do). The machine has to be server and client at once, like the host of a LAN game.
 *   2. Wait until the mission runs, then open the debug console (Esc), choose "Local exec" and run the content of this file.
 *      Do not move or look around while it runs (about 8 seconds): the frame times are only comparable when the scene is.
 *   3. The result is in the chat and in the RPT (search for "[EWC benchmark]"). Run it three times and take the middle one.
 *
 * What it does:
 *   baseline   60 frames without vehicles.
 *   start-up   spawns COUNT vehicles in one frame (class from CfgEWC >> Jammers, or the CLASS below) and watches 240 frames.
 *              The first sample contains the spawn itself, which costs the same on both builds. Before the change the
 *              vehicles register with Crows now, after it they do not, so "registered" tells which build you run.
 *   toggle     switches the jammer of TOGGLES vehicles on, one every 15 frames, with ewc_common_fnc_setJammer. This is the
 *              steady-state cost of one change of the jammer list. After the change the first switch registers a vehicle.
 *
 * Numbers per phase:
 *   avg / max   frame time in ms
 *   over 33 ms  frames slower than 30 fps
 *   excess      ms spent above 16.7 ms in total: the hitch you would feel
 *   events      crowsEW_main_updateJammers received here (Crows sends the whole jammer list with each)
 *   entries     jammers in those lists in total: what was sent to every client
 *   registered  vehicles that Crows knows as a jammer
 */

// ---- settings
private _count = 60;           // vehicles
private _class = "";           // "" takes the first land vehicle of CfgEWC >> Jammers, or name a class (the CUP DUKE vehicles are not in it)
private _toggles = 20;         // jammers switched on one by one

if (!isServer || {!hasInterface}) exitWith {
    hint "Run the benchmark on a LAN host (server and client in one).";
};

if (CBA_missionTime <= 0) exitWith {
    hint "The mission has not started yet.";
};

if (!isNil "ewc_bench_pfh") exitWith {
    hint "The benchmark is running already.";
};

if (isNil "ewc_common_fnc_setJammer") exitWith {
    hint "ewc_common is not loaded.";
};

// ---- class: the first land vehicle that the registry of ewc_common describes
if (_class isEqualTo "") then {
    private _entries = configProperties [configFile >> "CfgEWC" >> "Jammers", "isClass _x"];

    {
        private _vehicleConfig = _x;

        if (_class isEqualTo "" && {_entries findIf {
            private _marker = _vehicleConfig >> getText (_x >> "property");

            if (isNumber (_x >> "value")) then {
                isNumber _marker && {getNumber _marker == getNumber (_x >> "value")}
            } else {
                isText _marker && {getText _marker isNotEqualTo ""}
            }
        } != -1}) then {
            _class = configName _vehicleConfig;
        };
    } forEach (("true" configClasses (configFile >> "CfgVehicles")) select {
        getNumber (_x >> "scope") == 2 && {configName _x isKindOf "LandVehicle"}
    });
};

if (_class isEqualTo "") exitWith {
    hint "No vehicle class found. Load a compat mod or set _class.";
};

// ---- state, kept in globals because the frame handler has no access to this scope
ewc_bench_cfg = createHashMapFromArray [["count", _count], ["class", _class], ["toggles", _toggles], ["toggleEvery", 15], ["baselineFrames", 60], ["startupFrames", 240]];
ewc_bench_phase = "baseline";
ewc_bench_frames = [];
ewc_bench_vehicles = [];
ewc_bench_toggled = 0;
ewc_bench_events = 0;
ewc_bench_entries = 0;

ewc_bench_handler = ["crowsEW_main_updateJammers", {
    params ["_jamMap"];

    ewc_bench_events = ewc_bench_events + 1;
    ewc_bench_entries = ewc_bench_entries + count _jamMap;
}] call CBA_fnc_addEventHandler;

ewc_bench_fnc_reset = {
    ewc_bench_frames = [];
    ewc_bench_events = 0;
    ewc_bench_entries = 0;
};

ewc_bench_fnc_report = {
    params ["_title"];

    private _frames = ewc_bench_frames;
    private _sum = 0;
    private _max = 0;
    private _over = 0;
    private _excess = 0;

    {
        _sum = _sum + _x;
        _max = _max max _x;

        if (_x > 33.4) then {
            _over = _over + 1;
        };

        _excess = _excess + ((_x - 16.7) max 0);
    } forEach _frames;

    private _registered = {!isNil {_x getVariable "ewc_common_jammerState"}} count ewc_bench_vehicles;

    private _text = format [
        "%1 | %2 frames | avg %3 ms | max %4 ms | over 33 ms: %5 | excess %6 ms | events %7 | entries %8 | registered %9/%10",
        _title, count _frames, (_sum / (count _frames max 1)) toFixed 1, _max toFixed 1, _over, _excess toFixed 0,
        ewc_bench_events, ewc_bench_entries, _registered, count ewc_bench_vehicles
    ];

    diag_log text format ["[EWC benchmark] %1", _text];
    systemChat _text;
};

ewc_bench_fnc_spawn = {
    private _cfg = ewc_bench_cfg;
    private _count = _cfg get "count";
    private _grid = ceil sqrt _count;
    private _origin = (getPosATL player) vectorAdd [25, 0, 0];

    for "_i" from 0 to _count - 1 do {
        private _vehicle = createVehicle [_cfg get "class", _origin vectorAdd [(_i % _grid) * 12, floor (_i / _grid) * 12, 0], [], 0, "CAN_COLLIDE"];
        ewc_bench_vehicles pushBack _vehicle;
    };
};

ewc_bench_fnc_finish = {
    [ewc_bench_pfh] call CBA_fnc_removePerFrameHandler;
    ["crowsEW_main_updateJammers", ewc_bench_handler] call CBA_fnc_removeEventHandler;

    {
        deleteVehicle _x;
    } forEach ewc_bench_vehicles;

    diag_log text "[EWC benchmark] done, the vehicles are deleted";
    systemChat "Benchmark done, see the RPT for the numbers";

    ewc_bench_pfh = nil;
};

ewc_bench_fnc_frame = {
    private _cfg = ewc_bench_cfg;

    // The time the last frame took
    ewc_bench_frames pushBack (diag_deltaTime * 1000);

    switch (ewc_bench_phase) do {
        case "baseline": {
            if (count ewc_bench_frames >= _cfg get "baselineFrames") then {
                ["baseline, no vehicles"] call ewc_bench_fnc_report;

                call ewc_bench_fnc_reset;
                call ewc_bench_fnc_spawn;
                ewc_bench_phase = "startup";
            };
        };
        case "startup": {
            if (count ewc_bench_frames >= _cfg get "startupFrames") then {
                [format ["start-up, %1 x %2", _cfg get "count", _cfg get "class"]] call ewc_bench_fnc_report;

                call ewc_bench_fnc_reset;
                ewc_bench_phase = "toggle";
            };
        };
        case "toggle": {
            private _frames = count ewc_bench_frames;

            if (_frames % (_cfg get "toggleEvery") == 0 && {ewc_bench_toggled < ((_cfg get "toggles") min (count ewc_bench_vehicles))}) then {
                // A vehicle of the registry keeps its radius, so this is a plain switch. Only one without an entry (the CUP DUKE) needs one
                private _vehicle = ewc_bench_vehicles select ewc_bench_toggled;
                private _radius = [-1, 50] select (isNull ([_vehicle] call ewc_common_fnc_getJammerConfig));

                [_vehicle, true, _radius] call ewc_common_fnc_setJammer;
                ewc_bench_toggled = ewc_bench_toggled + 1;
            };

            // Two intervals after the last switch, so the frames after it are in
            if (_frames >= ((_cfg get "toggles") + 2) * (_cfg get "toggleEvery")) then {
                [format ["toggle, %1 jammers switched on one by one", ewc_bench_toggled]] call ewc_bench_fnc_report;

                call ewc_bench_fnc_finish;
            };
        };
    };
};

diag_log text format ["[EWC benchmark] start, %1 x %2", _count, _class];
systemChat format ["Benchmark running with %1 x %2, do not move", _count, _class];

ewc_bench_pfh = [{call ewc_bench_fnc_frame}, 0] call CBA_fnc_addPerFrameHandler;
