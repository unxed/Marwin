# Marwin

Runs Windows programs on Linux better. One project, several parts:

1. **Marwin runtime** — a light Wine-like runtime for Windows console programs; the showcase is
   Far Manager 2 and 3 in a Linux terminal. It is standalone and inherits nothing from Wine.
   Demonstrates that a Wine-like compatibility layer
   can be built on top of [unxed/bp](https://github.com/unxed/bp). Plan: [#1](https://github.com/unxed/Marwin/issues/1).
2. **dllmgr** — a manager of DLL variants for Wine, written in Go with
   [goWidgets](https://github.com/unxed/goWidgets). It's like a package manager, but for Wine DLLs such as cc580:
   built-in DLLs can be replaced with community-maintained alternatives that include bug fixes. winetricks on steroids.
   Rollback takes one step, and checks show the override really took effect.
   DLLs that cannot be replaced (those with a unix part, and the core ones) get patches instead,
   and a debug-data collector with presets saves agents from inventing a way to get logs each time.
3. **cc580** — our own `comctl32.dll` 5.80 in BP, a native DLL for Wine and for real Windows;
   it fixes the bugs FastStone Image Viewer hits. Plan:
   [#2](https://github.com/unxed/Marwin/issues/2).
   This would be another demonstration of how libraries for dllmgr can be built in BP.
   We also plan to provide a recipe for installing comctl32 from Wine 11 into Wine 9+ for the same purposes.
   
And next to it is the main part,

## The **wine-fix**
   A skill for AI agents: fix my favourite application under Wine by fixing or patching a single DLL,
   make it all work in one click, and then send to Wine a text report precise enough to write the same patch from.
   Concept: [docs/dllmgr-concept.md](docs/dllmgr-concept.md).

## Status

No code yet. Plans for the runtime and cc580 moved here from unxed/bp#129 and unxed/bp#220.

- **Runtime and cc580** start when the Bp concept
  ([unxed/bp#108](https://github.com/unxed/bp/issues/108)) is stable, in the order of
  [unxed/bp#128](https://github.com/unxed/bp/issues/128).
- **dllmgr** does not depend on Bp. Its work starts now (owner's decision, 2026-11-06), from
  iterations 0 and 1 of the concept.

## Files

- `docs/dllmgr-concept.md` — dllmgr and wine-fix: facts checked against the Wine 9.0 and
  11.0 sources, data model, checks, index format, patches, debug-data collection, CLI, GUI,
  tests, iterations.
- `dllmgr/spike/spike0.sh` — a manual check to run before any dllmgr code. It loads
  comctl32 from a Wine 11 package into the system Wine 9 for one exe only, and it can be
  undone.
