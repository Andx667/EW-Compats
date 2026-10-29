# Compat CUP cTab

Sub-addon of [Compat CUP](../README.md): shows the shots a CUP Boomerang detects on [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) as a red enemy marker at the estimated position of the shooter, like the markers a player places on the tablet.

## Usage

The CBA setting **Show shots on** (set by the server) decides where a detected shot is shown: on the **map**, on **cTab**, or **both** (default). The setting only exists when cTab is loaded, without cTab the map is used. The hint for the crew is not affected.

## Structure

- The sub-addon is the folder `ctab` of the PBO of Compat CUP. A `config.cpp` in a folder of a PBO is an addon of its own for the game, so its patch (`ewc_compat_cup_ctab`, `SUBADDON`) lists cTab in `requiredAddons` and has `skipWhenMissingDependencies = 1`. Without cTab only this config is skipped, the rest of Compat CUP loads as usual. `addonRootClass` takes author, url and version from the patch of Compat CUP.
- `script_component.hpp` defines `SUBCOMPONENT` and includes the one of Compat CUP. Functions are in `ctab\functions`, compiled with `PREP_SUB(ctab,name)` (`ewc_main`'s `script_macros.hpp`) and named `ewc_compat_cup_fnc_ctab_<name>`. The strings of the sub-addon are `STR_ewc_compat_cup_ctab_*` (`LSUBLSTRING`), in the stringtable of Compat CUP.

## How it works

- Compat CUP raises the CBA event `ewc_compat_cup_shotDetected` on every machine for each detected shot. This sub-addon listens to it (`XEH_preInit.sqf`, so no report is missed while the mission starts), and only the server acts on it (`fnc_ctab_addMarker`), so a shot is one marker. Compat CUP checks the setting too: with it set to cTab only, its own map marker is left out.
- cTab draws the markers of its user marker list. In `cTab_fnc_drawUserMarkers` they are `drawIcon` calls on every cTab map control, translated per marker by `cTab_fnc_translateUserMarker`: icons 0 to 13 and 90 are drawn in red (`cTabColorRed`), these are the "red force" markers. The list is kept by the server per encryption key and sent to the clients, which only see the list of their own key.
- The marker is added with `cTab_fnc_addUserMarker`, called on the server with `[key, [position, icon, size, octant, time, creator]]`. The sub-addon uses icon 6, the red NATO "unknown" symbol, because a Boomerang does not tell what the shooter is, the time of cTab (`cTab_fnc_currentTime`) and the commander of the vehicle as creator. cTab converts a 2D position to ASL and tells the clients of that key with a notification.
- The key is the one of the side of the vehicle (`fnc_ctab_getEncryptionKey`). cTab sets `cTab_encryptionKey_WEST` and the others on the clients only, so a server without them gets cTab's defaults: `b`, `o`, `c`, and for independent the key of the side it is friendly to, else `i`. Sides that share a key (the default for friendly independent) see the marker together, other sides do not.
- A shot close to a cTab marker of an earlier shot of that side does not add one, the same rule as on the map (`fnc_findNearMarker`, see Compat CUP). The server keeps the markers it added per key in `ewc_compat_cup_ctab_shotMarkers` (ID, position, expiry time) and drops the ones a player deleted on the tablet (they are not in `cTab_userMarkerLists` any more). Markers placed by players are not considered. A merged shot only moves the expiry time of the marker, so nothing is sent to the clients and cTab does not notify again. The time on the marker stays the one of the first shot.
- cTab keeps a marker until it is deleted. The sub-addon deletes it (`fnc_ctab_expireMarker`, which schedules itself again for the time left when the expiry time was moved) after the marker lifetime of the **server** (`ewc_compat_cup_markerLifetime`, 0 means no cTab marker), with the transaction ID cTab gave it (`cTab_userMarkerTransactionId` right after adding, which is the ID of the new marker) and `cTab_fnc_deleteUserMarker`.

## Dependencies

- [Compat CUP](../README.md) and so CUP Vehicles and Crow's Electronic Warfare
- [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217)
