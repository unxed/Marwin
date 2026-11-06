# Marwin

Running Windows programs on Linux, with our own code in Bp. One project, three parts:

1. **Marwin runtime** — a light runtime for Windows console programs; the showcase is
   Far Manager 2 and 3 in a Linux terminal. It is standalone and inherits nothing from Wine,
   wineserver included. Plan: [#1](https://github.com/unxed/Marwin/issues/1).
2. **cc580** — our own `comctl32.dll` 5.80 in Bp, a native DLL for Wine and for real Windows;
   it fixes the bugs FastStone Image Viewer hits. Plan:
   [#2](https://github.com/unxed/Marwin/issues/2).
3. **dllmgr** — a manager of DLL variants for Wine, written in Go with
   [goWidgets](https://github.com/unxed/goWidgets):
   - enables one DLL for one program: a module from another Wine release or a third-party
     one such as cc580;
   - patches for DLLs that cannot be replaced (those with a unix part, and the core ones);
   - one-step rollback, and checks that show the override really took effect;
   - a debug-data collector with presets, so agents do not have to invent a way to get logs
     each time.

   Next to it is the **wine-fix** skill for AI agents: fix an application under Wine by fixing
   or patching a single DLL, then send upstream a text report precise enough to write the
   patch from. Concept (in Russian): [docs/dllmgr-concept.md](docs/dllmgr-concept.md).

## Status

No code yet. Plans for the runtime and cc580 moved here from unxed/bp#129 and unxed/bp#220.

- **Runtime and cc580** start when the Bp concept
  ([unxed/bp#108](https://github.com/unxed/bp/issues/108)) is stable, in the order of
  [unxed/bp#128](https://github.com/unxed/bp/issues/128).
- **dllmgr** does not depend on Bp. Its work starts now (owner's decision, 2026-11-06), from
  iterations 0 and 1 of the concept.

Reference application: FastStone Image Viewer 7.1 (installer URL and sha256 are in the concept, § 0).

## Files

- `docs/dllmgr-concept.md` — dllmgr and wine-fix: facts checked against the Wine 9.0 and
  11.0 sources, data model, checks, index format, patches, debug-data collection, CLI, GUI,
  tests, iterations.
- `dllmgr/spike/spike0.sh` — a manual check to run before any dllmgr code. It loads
  comctl32 from a Wine 11 package into the system Wine 9 for one exe only, and it can be
  undone.
