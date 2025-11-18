#workspace_cleanup.sh
#!/bin/bash
set -euo pipefail

WORKSPACE_ROOT=${1:-/var/lib/jenkins/workspace}
DRY_RUN=${2:-true}
AGE_DAYS=${3:-30}

echo "🧽 Cleaning Jenkins workspaces older than $AGE_DAYS days in $WORKSPACE_ROOT"

if [ "$DRY_RUN" = "true" ]; then
  find "$WORKSPACE_ROOT" -maxdepth 1 -mindepth 1 -type d -mtime +${AGE_DAYS} -printf '%p\n'
else
  find "$WORKSPACE_ROOT" -maxdepth 1 -mindepth 1 -type d -mtime +${AGE_DAYS} -exec rm -rf {} \;
fi

echo "✅ Workspace cleanup completed."
