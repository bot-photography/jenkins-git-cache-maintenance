# disk_check.sh
#!/bin/bash
set -euo pipefail

THRESHOLD=80
MOUNT_POINT="/var/lib/jenkins"
USAGE=$(df "$MOUNT_POINT" --output=pcent | tail -1 | tr -dc '0-9')

echo "💾 Disk usage for $MOUNT_POINT: ${USAGE}%"

if [ "$USAGE" -ge "$THRESHOLD" ]; then
  echo "⚠️ Disk usage ${USAGE}% >= ${THRESHOLD}% — maintenance needed!"
  exit 0
else
  echo "✅ Disk usage healthy — no cleanup needed."
  exit 1
fi
