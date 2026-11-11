# Wi-Fi Jamming

Adds the editor module and the Zeus module **Set as Wi-Fi Jammer**, which cuts the wireless connections of [Advanced Equipment](https://steamcommunity.com/workshop/filedetails/?id=2888888564) (AE3) laptops to AE3 routers. It works like Crow's Electronic Warfare's radio and drone jammers: a device, two radii, and it can be located with the Spectrum Device.

## Usage

Place the module in the editor and optionally synchronise it with the object that should be the jammer. Without a synchronised object a data terminal is spawned at the module's position. The module is in the **Crows Electronic Warfare** category.

| Attribute | Default | Purpose |
|---|---|---|
| Effective Radius | 100 m | Full-strength zone around the jammer, 0 to 5000 m. |
| Falloff Radius | 100 m | Extra band *beyond* the effective radius in which the effect fades out, 0 to 5000 m. 0 is a hard edge. |
| Frequency | 915 MHz | Shown in the Spectrum Device. Must be inside the experimental antenna's range (520 to 1090 MHz). |

Values outside these ranges are set to the nearest limit.
| Active at Mission Start | true | Starts on, or is switched on later (for example by Zeus). |

Zeus can switch the jammer on and off like any Crow's Electronic Warfare jammer and sees it on the map. Unlike Crow's Electronic Warfare's own jammers it makes no sound.

!!! note "Gameplay value"
    Real Wi-Fi is on 2.4 and 5 GHz, which no antenna of the Spectrum Device reaches. The frequency is only where the jammer shows up in the device.

### Zeus

Zeus Enhanced has two modules in the same **Crows Electronic Warfare** category: **Set as Wi-Fi Jammer** and **Remove Wi-Fi Jammer**. Place **Set as Wi-Fi Jammer** on an object, or on the ground for a data terminal that is spawned there. The dialog has the attributes above, with *Active when placed* instead of *Active at Mission Start* and the frequency as a slider. **Remove Wi-Fi Jammer** removes the jammer from the object it is placed on, the Spectrum signal goes with it and the object stays. It only removes Wi-Fi jammers, the other jammers are removed with the module of Crow's Electronic Warfare.

## What is jammed

An AE3 wireless link works while the laptop is within the wireless range of its router. A jammer shortens that range by its strength:

| Strength | Where | Range left |
|---|---|---|
| 1 | inside the effective radius | none |
| 0 to 1 | in the falloff band, falling linearly | `range * (1 - strength)` |
| 0 | beyond the outer edge (effective plus falloff radius) | all |

The strength of a link is the stronger of the strengths at the laptop and at the router, and the strongest of all active jammers counts. A laptop in the falloff band of a jammer therefore keeps a connection to a router close by and loses one to a router far away. Inside the effective radius no link survives.

## Quirks

- **Connected laptops are dropped.** A laptop whose link is cut loses its address, as if it had left the range of its router. The Network app shows *Jammed* (in English, like the other connection messages of AE3), and the laptop has to connect again.
- **New connections are refused.** The Network app and the ACE menu ask AE3 before they connect, and the jammer is part of that check. A jammed laptop gets the reason *Jammed*.
- **Cascaded routers are left alone**, like AE3 does for its own range check.
- **Everybody in range is jammed**, including the own side.
- **Nothing is restored when the jammer stops.** The laptops connect again by hand.
- **Up to 5 seconds of delay** for a switch of the jammer or a moving laptop or router, because AE3 checks its connections every 5 seconds.

## Events

`ewc_wifi_jamming_API_connectionJammed` is raised on the server (local event) for every connection the jamming ends, with `[laptop, router, strength]`, the strength being 0 to 1. A mission can use it for a task that depends on an uplink, a message for the operator, or a log. It is raised one frame after the sweep of AE3 dropped the laptop, once per dropped connection. A refused attempt to connect raises nothing.

``` cpp
["ewc_wifi_jamming_API_connectionJammed", {
    params ["_laptop", "_router", "_strength"];
    systemChat format ["%1 lost %2 (%3 %% jamming)", _laptop, _router, round (_strength * 100)];
}] call CBA_fnc_addEventHandler;
```

## How it works

The module registers the object as an ordinary jammer in Crow's Electronic Warfare through its public CBA event `crowsEW_main_addJammer`, tagged with the capability `WifiJammer`. Crow's Electronic Warfare passes the tag along unchanged, which gives Zeus markers, switching on and off by action and JIP sync for free, without touching its code. It is the same way the [BFT Jamming](bft-jamming.md) addon works.

An active Wi-Fi jammer shows in the Spectrum Device as signal type `sweep_wifi` on the module's frequency.

The addon registers a connect condition with AE3. AE3 asks it before a laptop joins a router and in its own wireless sweep (every 5 seconds), which drops the laptops that no longer pass. Without a jammer that is on the condition answers at once, so there is no cost without one.

There are deliberately no CBA settings: without a placed module nothing happens anyway, and the frequency is a module attribute.

!!! note "Coupling to other mods"
    The integration uses public CBA events and global variables of Crow's Electronic Warfare, and only the public network API of AE3 (`addConnectCondition`, `getWirelessRange`, `getRouters`, `getClients`). It needs **AE3 2.1.0.5 or later** (checked against 2.1.0.7). An update of Crow's Electronic Warfare could still change its events and variables. Test after version bumps of both.

## Dependencies

- [Crow's Electronic Warfare](https://github.com/Crowdedlight/Crows-Electronic-Warfare)
- [Advanced Equipment](https://steamcommunity.com/workshop/filedetails/?id=2888888564)
