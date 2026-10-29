# Compat RHS USAF

Parent addon of the RHS USAF sub-addons. Each sub-addon is a folder with a `config.cpp` of its own, which the game treats as an addon, and is skipped alone when its dependencies are missing.

| Sub-addon | What it does |
|---|---|
| [`duke`](duke/README.md) | The radio jammer follows the DUKE switch of RHS. Needs Crow's Electronic Warfare |
| [`boomerang`](boomerang/README.md) | Gives the Boomerang of [Compat Boomerang](../compat_boomerang/README.md) to the M1245 SOCOM vehicles |

This addon has no code of its own. It holds the stringtable (the settings category and the strings of the sub-addons) and the patch the sub-addons build on.
