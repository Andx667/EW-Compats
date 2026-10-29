# Main

Structure of the mod. It holds no code of its own, the functions are in `ewc_common`.

- `config.cpp` has the patch `ewc_main` and the mod entry (`CfgMods`) with the name and description of the mod.
- `script_mod.hpp` defines the prefix, mod name, author and required versions. `script_version.hpp` holds the version number, which the release reads.
- `script_macros.hpp` has the macros every addon includes through its `script_component.hpp`: `PREP` and `PREP_SUB` to compile functions, and the names of the Crow's Electronic Warfare events and capabilities.
- `stringtable.xml` has the name and description of the mod. The strings of an addon are in its own stringtable.

The code that is shared by the compat addons, the registry of jammer vehicles and the state hint, is in [Common](../common/README.md).
