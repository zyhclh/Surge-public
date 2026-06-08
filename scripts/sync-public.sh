#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/sync-public.sh <public-repo-url>

Environment variables:
  PUBLIC_WORKTREE   Local checkout path for the public mirror.
                    Default: ../Surge-public
  PUBLIC_BRANCH     Public repository branch to sync.
                    Default: main
  COMMIT_MESSAGE    Commit message used when public changes exist.
                    Default: Sync public mirror

Example:
  scripts/sync-public.sh git@github.com:zyhclh/Surge-public.git
EOF
}

SOURCE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBLIC_REPO_URL="${1:-${PUBLIC_REPO_URL:-}}"
PUBLIC_WORKTREE="${PUBLIC_WORKTREE:-"$SOURCE_ROOT/../Surge-public"}"
PUBLIC_BRANCH="${PUBLIC_BRANCH:-main}"
COMMIT_MESSAGE="${COMMIT_MESSAGE:-Sync public mirror}"

EXCLUDED_PATHS=(
  ".github/workflows/"
  "Conf/Spec/Surge-zyhclh.conf"
  "Conf/Spec/Surge.conf"
  "Conf/Spec/mihomo.yaml"
)

if [[ -z "$PUBLIC_REPO_URL" ]]; then
  usage
  exit 64
fi

SOURCE_REAL="$(cd "$SOURCE_ROOT" && pwd -P)"
PUBLIC_PARENT="$(dirname "$PUBLIC_WORKTREE")"
mkdir -p "$PUBLIC_PARENT"
PUBLIC_PARENT_REAL="$(cd "$PUBLIC_PARENT" && pwd -P)"
PUBLIC_BASENAME="$(basename "$PUBLIC_WORKTREE")"
PUBLIC_REAL="$PUBLIC_PARENT_REAL/$PUBLIC_BASENAME"

if [[ "$PUBLIC_REAL" == "$SOURCE_REAL" ]]; then
  echo "Refusing to sync into the private source repository: $PUBLIC_REAL" >&2
  exit 1
fi

if [[ ! -d "$PUBLIC_WORKTREE" ]]; then
  git clone "$PUBLIC_REPO_URL" "$PUBLIC_WORKTREE"
fi

if [[ ! -d "$PUBLIC_WORKTREE/.git" ]]; then
  echo "Refusing to sync into a non-git directory: $PUBLIC_WORKTREE" >&2
  exit 1
fi

git -C "$PUBLIC_WORKTREE" fetch origin "$PUBLIC_BRANCH" || true
if git -C "$PUBLIC_WORKTREE" rev-parse --verify "origin/$PUBLIC_BRANCH" >/dev/null 2>&1; then
  git -C "$PUBLIC_WORKTREE" checkout -B "$PUBLIC_BRANCH" "origin/$PUBLIC_BRANCH"
else
  git -C "$PUBLIC_WORKTREE" checkout -B "$PUBLIC_BRANCH"
fi

rsync_args=(
  -a
  --delete
  --exclude ".git/"
  --exclude ".DS_Store"
)

for path in "${EXCLUDED_PATHS[@]}"; do
  rsync_args+=(--exclude "$path")
done

rsync "${rsync_args[@]}" "$SOURCE_ROOT/" "$PUBLIC_WORKTREE/"

for path in "${EXCLUDED_PATHS[@]}"; do
  rm -rf "$PUBLIC_WORKTREE/$path"
done

git -C "$PUBLIC_WORKTREE" add -A

if git -C "$PUBLIC_WORKTREE" diff --cached --quiet; then
  echo "No public changes to sync."
  exit 0
fi

git -C "$PUBLIC_WORKTREE" commit -m "$COMMIT_MESSAGE"
git -C "$PUBLIC_WORKTREE" push origin "$PUBLIC_BRANCH"
