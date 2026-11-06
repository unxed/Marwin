#!/usr/bin/env bash
# Спайк: comctl32 из Wine 11 в системный Wine 9 только для одного exe.
# В систему ничего не ставит, меняет только префикс, умеет откатываться.
#   ./spike0.sh probe "/путь/FSViewer.exe"        # что грузится (закройте программу — будет итог)
#   ./spike0.sh apply wine-stable-i386_11*.deb system|sxs
#   ./spike0.sh undo system|sxs
set -euo pipefail
P="${WINEPREFIX:-$HOME/.wine}"; export WINEPREFIX="$P"
APP="${APP:-FSViewer.exe}"
KEY="HKCU\\Software\\Wine\\AppDefaults\\$APP\\DllOverrides"
sig() { dd if="$1" bs=1 skip=64 count=16 status=none; }
case "${1:-}" in
probe)
  mkdir -p "$P/spike0"
  WINEDEBUG=+loaddll,warn+module wine "$2" >/dev/null 2>"$P/spike0/probe.log" || true
  grep -aE 'comctl32|No implementation' "$P/spike0/probe.log" | sort -u | head -30 ;;
apply)
  mode="$3"; BK="$P/spike0/$mode"
  [ -e "$BK/dest" ] && { echo "уже применено: undo $mode"; exit 1; }
  X=$(mktemp -d); trap 'rm -rf "$X"' EXIT; dpkg-deb -x "$2" "$X"
  if [ "$mode" = system ]; then
    src=$(find "$X" -path '*/i386-windows/comctl32.dll')
    grep -q '^#arch=win64' "$P/system.reg" && d=syswow64 || d=system32
    dest="$P/drive_c/windows/$d/comctl32.dll"
  else
    src=$(find "$X" -path '*/i386-windows/comctl32_v6.dll')
    dirs=("$P"/drive_c/windows/winsxs/x86_microsoft.windows.common-controls_6595b64144ccf1df_6.*/)
    [ ${#dirs[@]} -eq 1 ] || { printf 'нужен ровно один каталог:\n%s\n' "${dirs[@]}"; exit 1; }
    dest="${dirs[0]%/}/comctl32.dll"
  fi
  [ -f "$src" ] && [ -e "$dest" ] || { echo "нет src='$src' или dest='$dest'"; exit 1; }
  [ "$(sig "$src")" = "Wine builtin DLL" ] || { echo "у src нет метки builtin — стоп"; exit 1; }
  mkdir -p "$BK"; cp -a "$dest" "$BK/orig.dll"; echo "$dest" > "$BK/dest"
  rm -f "$dest"                                   # не писать сквозь симлинк
  cp "$src" "$dest"
  dd if=/dev/zero of="$dest" bs=1 seek=64 count=32 conv=notrunc status=none
  wine reg add "$KEY" /v comctl32 /d native,builtin /f
  echo "OK: $dest" ;;
undo)
  BK="$P/spike0/$2"; dest=$(cat "$BK/dest")
  rm -f "$dest"; cp -a "$BK/orig.dll" "$dest"; rm "$BK/dest"
  [ -e "$P/spike0/system/dest" ] || [ -e "$P/spike0/sxs/dest" ] || \
    wine reg delete "$KEY" /v comctl32 /f ;;
*) echo "usage: probe <exe> | apply <deb> system|sxs | undo system|sxs"; exit 1 ;;
esac
