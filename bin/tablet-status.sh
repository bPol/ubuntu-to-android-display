#!/usr/bin/env bash
PORT=5900
IP=$(/usr/bin/ip -4 addr show | awk '/enx/ && /inet / {print $2}' | cut -d/ -f1 | head -1)
[ -z "$IP" ] && IP="localhost"
if /usr/bin/pgrep -x wayvnc >/dev/null 2>&1; then
  TEXT="🖥"; CLASS="on"; ALT="on"; TOOLTIP="Connect to: ${IP}:${PORT}\nClick to stop"
else
  TEXT="🖥"; CLASS="off"; ALT="off"; TOOLTIP="Click to start tablet display"
fi
printf '{"text":"%s","alt":"%s","class":"%s","tooltip":"%s"}\n' "$TEXT" "$ALT" "$CLASS" "$TOOLTIP"
