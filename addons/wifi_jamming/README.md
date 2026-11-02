# Wi-Fi Jamming

Adds the editor module and the Zeus module **Set as Wi-Fi Jammer**, which cuts the wireless connections of [Advanced Equipment](https://steamcommunity.com/workshop/filedetails/?id=2888888564) (AE3) laptops to AE3 routers. It works like Crow's Electronic Warfare's radio and drone jammers: a device, two radii, and it can be located with the Spectrum Device.

## Usage

Place the module in the editor and optionally synchronise it with the object that should be the jammer. Without a synchronised object a data terminal is spawned at the module's position.

Module attributes:

- **Effective Radius** / **Falloff Radius** (metres): full strength inside the effective radius, fading out linearly over the falloff band beyond it.
- **Frequency**: frequency in MHz under which the active jammer shows in the Spectrum Device. Must be inside the range of the experimental antenna (520 to 1090 MHz). Real Wi-Fi is on 2.4 and 5 GHz, which no antenna of the Spectrum Device reaches, so the frequency is a gameplay value.
- **Active at Mission Start**: whether the jammer starts on, or is switched on later (for example by Zeus).

Zeus can switch the jammer on and off like any Crow's Electronic Warfare jammer and sees it on the map. Unlike Crow's Electronic Warfare's own jammers it makes no sound.

### Zeus

Zeus Enhanced has two modules in the **Crows Electronic Warfare** category: **Set as Wi-Fi Jammer** and **Remove Wi-Fi Jammer**. Place **Set as Wi-Fi Jammer** on an object, or on the ground for a data terminal that is spawned there. **Remove Wi-Fi Jammer** removes the jammer from the object it is placed on (the Spectrum signal goes with it, the object stays). It only removes Wi-Fi jammers, the other jammers are removed with the module of Crow's Electronic Warfare.

## What is jammed

An AE3 wireless link works while the laptop is within the wireless range of its router. A jammer shortens that range by its strength:

| Strength | Where | Range left |
|---|---|---|
| 1 | inside the effective radius | none |
| 0 to 1 | in the falloff band, falling linearly | `range * (1 - strength)` |
| 0 | beyond the outer edge (effective plus falloff radius) | all |

The strength of a link is the stronger of the strengths at the laptop and at the router, and the strongest of all active jammers counts. A laptop in the falloff band of a jammer therefore keeps a connection to a router close by and loses one to a router far away. Inside the effective radius no link survives.

- **Connected laptops are dropped.** A laptop whose link is cut loses its address, as if it had left the range of its router (AE3 shows *Jammed* in the Network app), and has to connect again. AE3 checks its connections every 5 s, so that can take up to 5 s after the jammer is switched on or a laptop is carried into the jamming.
- **New connections are refused.** The Network app and the ACE menu ask AE3 first, which asks the jammer: a jammed laptop cannot connect, the reason shows as *Jammed*.
- **Routers cascaded to another router are left alone**, like AE3 does for its own range check: they manage their own subnets and a mission may link routers that stand far apart.
- **Everybody in range is jammed**, including the own side.
- **A router or laptop that is carried works the same**: positions are read on every check.
- Nothing is restored when the jammer stops. The laptops connect again by hand.

## How it works

The module registers the object as an ordinary jammer in Crow's Electronic Warfare through its public CBA event `crowsEW_main_addJammer`, tagged with the capability `WifiJammer`. Crow's Electronic Warfare passes the tag along unchanged, which gives Zeus markers, switching on and off by action and JIP sync for free, without touching its code. It is the same way the [BFT Jamming](../bft_jamming/README.md) addon works.

Crow's Electronic Warfare registers its `addJammer` handler only in its own `postInit`, but module functions can run earlier, and a server event without a handler is dropped silently. `fnc_registerWifiJammer` therefore raises the event with `CBA_fnc_waitUntilAndExecute` once `CBA_missionTime > 0`. For the same reason our own event handler is registered in `preInit`.

An active Wi-Fi jammer shows in the Spectrum Device as signal type `sweep_wifi` on the module's frequency. `fnc_onUpdateJammersServer` compares the signal with the on/off state on every `crowsEW_main_updateJammers`, reading the actual state from `crowsEW_spectrum_beacons`, because Crows' own toggle only re-adds the signals of its radio and drone jammers.

On every machine `XEH_postInit` registers `fnc_connectCondition` with `AE3_network_fnc_addConnectCondition`. AE3 asks its connect conditions before a laptop joins a router (Network app, ACE menu) and in its own wireless sweep (server, every 5 s), which drops the laptops that no longer pass and tells the Network app the reason. The condition works out the strength from `crowsEW_main_jamMap` and refuses the link when the laptop is farther from the router than the range that is left. Without a jammer that is on it answers at once, so there is no cost without one.

There are deliberately no CBA settings: without a placed module nothing happens anyway, and the frequency is a module attribute.

## Functions

| Function | Runs on | Purpose |
|---|---|---|
| `fnc_addWifiJammer` | server | Handler of the editor module: takes the attributes of the module and the synced object (or a spawned data terminal) and registers it |
| `fnc_registerWifiJammer` | any | Registers an object as a jammer in Crow's Electronic Warfare with the Wi-Fi capability, once `CBA_missionTime > 0`. Shared by both modules |
| `fnc_addWifiJammerZeus` | Zeus client | Zeus module: ZEN dialog with the attributes, then registers the selected object (or a spawned data terminal) |
| `fnc_removeWifiJammerZeus` | Zeus client | Zeus module: removes the jammer from the selected object, only a Wi-Fi jammer |
| `fnc_zeusRegister` | clients | Registers the two Zeus modules with Zeus Enhanced in the category of Crow's Electronic Warfare |
| `fnc_onUpdateJammersServer` | server | Keeps the Spectrum signal in line with the on/off state of the jammers |
| `fnc_connectCondition` | any | Connect condition of AE3: refuses a link whose range the jamming has cut |
| `fnc_getJamStrength` | server | Strongest jamming at an object from all jammers that are on |
| `fnc_calcJamStrength` | any | Jamming strength 0 to 1 from the distance, the effective radius and the falloff radius |

## Coupling to other mods

The integration uses public CBA events and global variables of Crow's Electronic Warfare, and the public API of AE3 (`AE3_network_fnc_addConnectCondition`, `AE3_network_fnc_getWirelessRange`), which needs **AE3 2.1.0.5 or later**. The only variable of AE3 outside that API is `AE3_cap_isRouter`. A future update of either mod could change them and silently break the addon. Test after version bumps of both.

- `crowsEW_main_addJammer`, `crowsEW_main_removeJammer`, `crowsEW_main_updateJammers`, `crowsEW_main_jamMap`
- `crowsEW_spectrum_addBeacon`, `crowsEW_spectrum_removeBeacon`, `crowsEW_spectrum_beacons`
- `AE3_network_fnc_addConnectCondition`, `AE3_network_fnc_getWirelessRange`, `AE3_cap_isRouter`

## Dependencies

- [Crow's Electronic Warfare](https://github.com/Crowdedlight/Crows-Electronic-Warfare) (`crowsEW_main`, `crowsEW_spectrum`)
- [Advanced Equipment](https://steamcommunity.com/workshop/filedetails/?id=2888888564) (`ae3_main`, `ae3_network`)

## Maintainer

- Andx
