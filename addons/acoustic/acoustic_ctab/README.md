# Acoustic Drone Detection cTab

Sub-addon of [Acoustic Drone Detection](../README.md): shows the drones the acoustic sensors of a side track on [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217) as a red air marker with an arrow for the heading, like the markers a player places on the tablet.

## Usage

The CBA setting **Show drones** (set by the server) decides where a track is shown: **nothing**, the **map** (default) or **cTab**. cTab is only an option when it is loaded, which is when this sub-addon exists.

## Structure

- The sub-addon is the folder `acoustic_ctab` of the PBO. Its patch (`ewc_acoustic_ctab`, `SUBADDON`) lists cTab in `requiredAddons` and has `skipWhenMissingDependencies = 1`, so without cTab only this config is skipped. `addonRootClass` takes author, url and version from the main patch.
- Functions are compiled with `PREP_SUB(ctab,name)` and named `ewc_acoustic_fnc_ctab_<name>`, like `boomerang_ctab`.

## How it works

- `ewc_acoustic_trackUpdated` and `ewc_acoustic_trackLost` are always raised on the server (on clients only for map markers). The handlers are registered in `preInit` and only the server acts on them, so a track is one marker.
- `fnc_ctab_updateMarker` adds the marker with `cTab_fnc_addUserMarker` for the encryption key of the side of the sensors (`ewc_common_fnc_getCtabEncryptionKey`, shared with `boomerang_ctab`). The marker data is `[2D position, icon, size, octant, time, creator]`: icon 4 (red NATO rotary wing) or 5 (fixed wing) from the kind of the signature, no size, the octant of the heading (1 north to 8 north-west, 0 below 2 m/s, so no arrow), `cTab_fnc_currentTime` and the sensor that heard the drone best as creator.
- cTab cannot move a marker, and every new one makes it notify the side. The marker is only replaced (`cTab_fnc_deleteUserMarker`, then a new one) once the drone moved `CTAB_MOVE_DISTANCE` (150 m) **and** the marker is `CTAB_UPDATE_INTERVAL` (10 s) old. A marker a player deleted (not in `cTab_userMarkerLists` any more) is replaced with the next update, the drone is still heard. The ID of a marker is `cTab_userMarkerTransactionId` right after adding it.
- `fnc_ctab_removeMarker` deletes the marker when the track ends. The path of the track is not shown, cTab has no lines.

## Dependencies

- [Acoustic Drone Detection](../README.md)
- [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=3438246217)
