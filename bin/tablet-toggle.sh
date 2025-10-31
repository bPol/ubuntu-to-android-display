#!/usr/bin/env bash
set -u
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
LOG="/tmp/tablet-toggle.log"
echo -e "\n---- $(date) ----" >>"$LOG"
exec >>"$LOG" 2>&1
if [ -z "${SWAYSOCK:-}" ] && command -v sway >/dev/null 2>&1; then
  SWAYSOCK="$(sway --get-socketpath || true)"; export SWAYSOCK
fi
MODE="1920x1200@60"; PORT="5900"; SOCK="/run/user/$(id -u)/wayvnc-headless.sock"
notify() { command -v notify-send >/dev/null 2>&1 && notify-send "Tablet display" "$*"; }
if /usr/bin/pgrep -x wayvnc >/dev/null 2>&1; then /usr/bin/pkill -x wayvnc; notify "Stopped"; exit 0; fi
HEADLESS_LIST=$(/usr/bin/swaymsg -t get_outputs | awk -F'"' '/HEADLESS-/{print $4}')
if [ -z "$HEADLESS_LIST" ]; then /usr/bin/swaymsg -q create_output || true; HEADLESS_LIST=$(/usr/bin/swaymsg -t get_outputs | awk -F'"' '/HEADLESS-/{print $4}'); fi
HEADLESS="HEADLESS-1"; if ! echo "$HEADLESS_LIST" | grep -qx "$HEADLESS"; then HEADLESS="$(echo "$HEADLESS_LIST" | head -1)"; fi
for o in $HEADLESS_LIST; do [ "$o" = "$HEADLESS" ] || /usr/bin/swaymsg -q "output $o disable"; done
/usr/bin/swaymsg -q "output $HEADLESS mode $MODE position 2560 0 enable" || true
IP=$(/usr/bin/ip -4 addr show | awk '/enx/ && /inet / {print $2}' | cut -d/ -f1 | head -1); [ -z "$IP" ] && IP="127.0.0.1"
[ -S "$SOCK" ] && rm -f "$SOCK" || true
/usr/bin/nohup /usr/bin/wayvnc -Linfo -S "$SOCK" -o "$HEADLESS" 0.0.0.0 "$PORT" >/tmp/wayvnc.out 2>&1 &
sleep 0.5
if /usr/bin/ss -ltn sport = :$PORT | grep -q ":$PORT"; then notify "Started at ${IP}:$PORT"; else notify "Failed (see /tmp/wayvnc.out)"; fi
