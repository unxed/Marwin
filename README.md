# Marwin

Marwin is a light runtime for Windows console programs on Linux, written in
[Bp](https://github.com/unxed/bp).

Showcase:

- Far Manager 2 and 3 running in a Linux terminal.
- DOS text-mode programs, such as Norton Commander and others, running in the terminal through DOSBox-X.

Marwin is standalone. It does not inherit anything from Wine, wineserver included. It also shows
that a Wine-like compatibility layer can be built on top of Bp.

Plan: [#1](https://github.com/unxed/Marwin/issues/1).

## Related projects

- **[dllmgr](https://github.com/unxed/dllmgr)** — a manager of DLL variants for Wine and Marwin,
  with a catalog of libraries and fixes. Marwin is its second target: the DLLs are chosen per
  program. `dllmgr check --target marwin` lists the APIs that Marwin does not export yet. Marwin
  writes its load log in Wine's `+loaddll` format, so dllmgr's checks work unchanged. The plan for
  cc580 (comctl32 5.80 in Bp) has moved to [dllmgr#1](https://github.com/unxed/dllmgr/issues/1).
- **[fix-it-in-wine](https://github.com/unxed/fix-it-in-wine)** — an AI agent skill: "fix my
  application under Wine".

## Status

No code yet. Work starts when the Bp concept
([bp#108](https://github.com/unxed/bp/issues/108)) is stable, in the order of
[bp#128](https://github.com/unxed/bp/issues/128).
