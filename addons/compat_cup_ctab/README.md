# Compat CUP cTab

Shows the shots a CUP Boomerang detects on [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217): a red enemy marker at the estimated position of the shooter, like the markers a player places on the tablet. It is only loaded when `ewc_compat_cup` and cTab are both loaded.

## Usage

The CBA setting **Show shots on** of Compat CUP (set by the server) decides where a detected shot is shown: on the **map**, on **cTab**, or **both** (default). Without this addon the map is used whatever the setting says. The hint for the crew is not affected.

## How it works

- `ewc_compat_cup` raises the CBA event `ewc_compat_cup_shotDetected` on every machine for each detected shot. This addon listens to it (`XEH_preInit.sqf`, so no report is missed while the mission starts), and only the server acts on it (`fnc_addMarker`), so a shot is one marker.
- cTab draws the markers of its user marker list. In `cTab_fnc_drawUserMarkers` they are `drawIcon` calls on every cTab map control, translated per marker by `cTab_fnc_translateUserMarker`: icons 0 to 13 and 90 are drawn in red (`cTabColorRed`), these are the "red force" markers. The list is kept by the server per encryption key and sent to the clients, which only see the list of their own key.
- The marker is added with `cTab_fnc_addUserMarker`, called on the server with `[key, [position, icon, size, octant, time, creator]]`. The addon uses icon 6, the red NATO "unknown" symbol, because a Boomerang does not tell what the shooter is, the time of cTab (`cTab_fnc_currentTime`) and the commander of the vehicle as creator. cTab converts a 2D position to ASL and tells the clients of that key with a notification.
- The key is the one of the side of the vehicle (`fnc_getEncryptionKey`). cTab sets `cTab_encryptionKey_WEST` and the others on the clients only, so a server without them gets cTab's defaults: `b`, `o`, `c`, and for independent the key of the side it is friendly to, else `i`. Sides that share a key (the default for friendly independent) see the marker together, other sides do not.
- cTab keeps a marker until it is deleted. The addon deletes it after the marker lifetime of the **server** (`ewc_compat_cup_markerLifetime`, 0 means no cTab marker), with the transaction ID cTab gave it (`cTab_userMarkerTransactionId` right after adding, which is the ID of the new marker) and `cTab_fnc_deleteUserMarker`.

## Dependencies

- [Compat CUP](../compat_cup/README.md) and so CUP Vehicles and Crow's Electronic Warfare
- [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217)
