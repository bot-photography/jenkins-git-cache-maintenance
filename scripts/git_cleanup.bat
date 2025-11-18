#git_cleanup.sh
#!/bin/bash
set -euo pipefail

CACHE_ROOT=${1:-/var/lib/jenkins/git-cache}
DRY_RUN=${2:-true}
AGGRESSIVE=${3:-false}
AGE_DAYS=${4:-30}

echo "🔍 Searching for Git repositories in $CACHE_ROOT"
find "$CACHE_ROOT" -type d -name ".git" -printf '%h\n' > git_repos_list || true
echo "Found $(wc -l < git_repos_list) repositories."

while IFS= read -r repo; do
  echo "-------------------------------------------"
  echo "🧭 Processing repo: $repo"
  cd "$repo" || continue
  du -sh .git || true

  if [ "$DRY_RUN" = "true" ]; then
    echo "[DRY RUN] Would run: git fetch --prune"
    echo "[DRY RUN] Would run: git reflog expire --expire=${AGE_DAYS}.days --all"
    echo "[DRY RUN] Would run: git gc --auto"
  else
    echo "🧹 Running cleanup..."
    git fetch --prune origin || true
    git reflog expire --expire=${AGE_DAYS}.days --all || true
    git gc --auto || true
    if [ "$AGGRESSIVE" = "true" ]; then
      echo "⚙️ Aggressive cleanup enabled"
      git repack -a -d --depth=250 --window=250 || true
      git prune --expire ${AGE_DAYS}.days || true
    fi
  fi
done < git_repos_list

echo "✅ Git cache cleanup completed."
