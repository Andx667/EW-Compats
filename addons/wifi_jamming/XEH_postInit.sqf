#include "script_component.hpp"

// AE3 keeps its connect conditions per machine: the ACE menu and the Network app ask on the machine of the player, the
// wireless sweep on the server, whose answer is the one that counts
// (needs AE3 2.1.0.5 or later, an older one has no such function)
if (isNil "AE3_network_fnc_addConnectCondition") then {
    ERROR("AE3_network_fnc_addConnectCondition is missing, update AE3. Wi-Fi jamming is inactive");
} else {
    [AE3_CONNECT_CONDITION_ID, LINKFUNC(connectCondition)] call AE3_network_fnc_addConnectCondition;
};

// The Zeus modules are made on the machines of the players
if (hasInterface) then {
    call FUNC(zeusRegister);
};
