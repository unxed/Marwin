# Marwin

Running Windows programs on Linux, with our own code in Bp. One project, three parts:

1. **Marwin runtime** — a light runtime for Windows console programs; the showcase is
   Far Manager 2 and 3 in a Linux terminal. It is standalone and inherits nothing from Wine,
   wineserver included. Plan: [unxed/bp#129](https://github.com/unxed/bp/issues/129).
2. **cc580** — our own `comctl32.dll` 5.80 in Bp, a native DLL for Wine and for real Windows;
   it fixes the bugs FastStone Image Viewer hits. Plan:
   [unxed/bp#220](https://github.com/unxed/bp/issues/220).
3. **dllmgr** — a manager of DLL variants for Wine, written in Go with
   [goWidgets](https://github.com/unxed/goWidgets). It enables one DLL for one program: a
   module from another Wine release or a third-party one such as cc580. Rollback takes one
   step, and checks show the override really took effect. Next to it is the **wine-fix**
   skill for AI agents: fix an application under Wine by fixing or patching a single DLL,
   then send upstream a text report precise enough to write the patch from.
   Concept (in Russian): [docs/dllmgr-concept.md](docs/dllmgr-concept.md).

## Status

No code yet. The runtime and cc580 start when the Bp concept
([unxed/bp#108](https://github.com/unxed/bp/issues/108)) is stable, in the order of
[unxed/bp#128](https://github.com/unxed/bp/issues/128). dllmgr does not depend on Bp.

## Files

- `docs/dllmgr-concept.md` — dllmgr and wine-fix: facts checked against the Wine 9.0 and
  11.0 sources, data model, checks, index format, CLI, GUI, tests, iterations.
- `dllmgr/spike/spike0.sh` — a manual check to run before any dllmgr code. It loads
  comctl32 from a Wine 11 package into the system Wine 9 for one exe only, and it can be
  undone.
