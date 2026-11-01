# Compat RHS USAF

Parent addon of the RHS USAF sub-addons. Each sub-addon is a folder with a `config.cpp` of its own, which the game treats as an addon, and is skipped alone when its dependencies are missing.

| Sub-addon | What it does |
|---|---|
| [`compat_rhs_usaf_duke`](compat_rhs_usaf_duke/README.md) | The radio jammer follows the DUKE switch of RHS, and the Stryker family gets the DUKE weapon RHS leaves out. Needs Crow's Electronic Warfare |
| [`compat_rhs_usaf_boomerang`](compat_rhs_usaf_boomerang/README.md) | Gives the Boomerang of [Boomerang](../boomerang/README.md) to the M1245 SOCOM vehicles |

This addon has no code of its own. It holds the stringtable (the settings category and the strings of the sub-addons) and the patch the sub-addons build on.
