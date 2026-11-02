#include "script_component.hpp"

// AE3 keeps its connect conditions per machine: the ACE menu and the Network app ask on the machine of the player, the
// wireless sweep on the server, whose answer is the one that counts
[AE3_CONNECT_CONDITION_ID, LINKFUNC(connectCondition)] call AE3_network_fnc_addConnectCondition;

// The Zeus modules are made on the machines of the players
if (hasInterface) then {
    call FUNC(zeusRegister);
};
