# Contributing Setup & Guidelines

## Setting up the Development Environment

### 1. Clone the repository from GitHub

### 2. Install HEMTT

The latest version of HEMTT can be installed by running:

```cmd
winget install hemtt
```

## Coding Guidelines

This mod follows the same coding guidelines as the ACE3 mod, which can be found [here](https://ace3.acemod.org/wiki/development/coding-guidelines).

## Translations

Every text the player sees lives in the `stringtable.xml` of its addon. English comes first and is the fallback, German, French, Spanish, Polish and Russian are translated. The names of the language tags are the ones Arma 3 uses (`German`, `French`, `Spanish`, `Polish`, `Russian`, `Italian`, `Czech`, ...).

- Never hardcode text in configs or scripts. Use `CSTRING(key)` in configs and `LLSTRING(key)` in scripts, and add the key to the stringtable of the addon. Keys are named `STR_ewc_<addon>_<name>`.
- To add a language, add its tag to `TRANSLATIONS` in `tools/stringtable_validator.py` and translate every key. To correct a translation, change the text of the key.
- Run `python tools/stringtable_validator.py`. It checks the structure of the stringtables and prints how many keys each language covers and which are missing. Missing translations are only warnings, as the game falls back to English.
- Keep the texts short and keep mod, DLC and item names (Crow's EW, cTab, DUKE, BFT) untranslated.
