#!/usr/bin/env bash
set -euo pipefail

# Publish confirmed skills to dotfiles, then install them for Claude Code and Codex.
# agent-workflow-protocol is the source of truth; dotfiles/config is the deployment snapshot.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_DIR="${DOTFILES_CONFIG_DIR:-$HOME/dotfiles/config}"
PUBLISH_ONLY=0
MODE="--unified"

usage() {
  cat <<'EOF'
Usage: scripts/link-skills.sh [options]

Options:
  --config-dir PATH  dotfiles config repository (default: ~/dotfiles/config)
  --publish-only     publish without installing or verifying local tool links
  --unified          use the shared global instruction file (default)
  --separate         use tool-specific global instruction files
  -h, --help         show this help
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --config-dir)
      [ "$#" -ge 2 ] || { echo "error: --config-dir requires a path" >&2; exit 2; }
      CONFIG_DIR="$2"
      shift 2
      ;;
    --publish-only)
      PUBLISH_ONLY=1
      shift
      ;;
    --unified|--separate)
      MODE="$1"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

command -v rsync >/dev/null 2>&1 || {
  echo "error: rsync is required to publish skills" >&2
  exit 1
}

[ -d "$CONFIG_DIR/ai/skills" ] || {
  echo "error: dotfiles skill directory not found: $CONFIG_DIR/ai/skills" >&2
  echo "run dotfiles setup first, or pass --config-dir PATH" >&2
  exit 1
}

CONFIG_DIR="$(cd "$CONFIG_DIR" && pwd)"
DOTFILES_ROOT="$(cd "$CONFIG_DIR/.." && pwd)"
DEST_ROOT="$CONFIG_DIR/ai/skills"
MANIFEST="$DEST_ROOT/.agent-workflow-protocol-managed"
SETUP_SCRIPTS="$DOTFILES_ROOT/.claude/skills/setup/scripts"

if [ "$PUBLISH_ONLY" -eq 0 ]; then
  for required in link-tool.sh verify.sh; do
    [ -f "$SETUP_SCRIPTS/$required" ] || {
      echo "error: dotfiles setup script not found: $SETUP_SCRIPTS/$required" >&2
      echo "use --publish-only when the dotfiles framework is unavailable" >&2
      exit 1
    }
  done
fi

is_valid_name() {
  case "$1" in
    ''|*[!A-Za-z0-9._-]*) return 1 ;;
    *) return 0 ;;
  esac
}

is_managed() {
  [ -f "$MANIFEST" ] && grep -Fqx "$1" "$MANIFEST"
}

STAGE="$(mktemp -d "$DEST_ROOT/.agent-workflow-protocol-publish.XXXXXX")"
trap 'rm -rf "$STAGE"' EXIT
NEW_MANIFEST="$STAGE/managed-skills"
: > "$NEW_MANIFEST"

found=0
for skill_md in "$REPO"/skills/*/SKILL.md; do
  [ -f "$skill_md" ] || continue
  src_dir="$(dirname "$skill_md")"
  skill_name="$(basename "$src_dir")"
  is_valid_name "$skill_name" || {
    echo "error: unsupported skill name: $skill_name" >&2
    exit 1
  }
  printf '%s\n' "$skill_name" >> "$NEW_MANIFEST"
  mkdir -p "$STAGE/$skill_name"
  rsync -a --delete "$src_dir/" "$STAGE/$skill_name/"
  found=1
done

[ "$found" -eq 1 ] || {
  echo "error: no confirmed skills found under $REPO/skills" >&2
  exit 1
}

# Validate every collision and stale managed entry before changing the destination.
while IFS= read -r skill_name; do
  dest_dir="$DEST_ROOT/$skill_name"
  [ -e "$dest_dir" ] || [ -L "$dest_dir" ] || continue
  if [ -L "$dest_dir" ]; then
    echo "error: refusing to replace symlink in dotfiles: $dest_dir" >&2
    exit 1
  fi
  if ! is_managed "$skill_name" && ! diff -qr "$STAGE/$skill_name" "$dest_dir" >/dev/null 2>&1; then
    echo "error: unmanaged dotfiles skill has different content: $dest_dir" >&2
    echo "rename or remove it after confirming which copy should win" >&2
    exit 1
  fi
done < "$NEW_MANIFEST"

if [ -f "$MANIFEST" ]; then
  while IFS= read -r old_name; do
    [ -n "$old_name" ] || continue
    is_valid_name "$old_name" || {
      echo "error: invalid name in managed manifest: $old_name" >&2
      exit 1
    }
    grep -Fqx "$old_name" "$NEW_MANIFEST" && continue
    stale_dir="$DEST_ROOT/$old_name"
    if [ -L "$stale_dir" ]; then
      echo "error: refusing to remove stale symlink from dotfiles: $stale_dir" >&2
      exit 1
    fi
  done < "$MANIFEST"
fi

while IFS= read -r skill_name; do
  dest_dir="$DEST_ROOT/$skill_name"
  if [ -d "$dest_dir" ] && diff -qr "$STAGE/$skill_name" "$dest_dir" >/dev/null 2>&1; then
    echo "unchanged $skill_name"
    continue
  fi
  rm -rf "$dest_dir"
  mv "$STAGE/$skill_name" "$dest_dir"
  echo "published $skill_name -> $dest_dir"
done < "$NEW_MANIFEST"

if [ -f "$MANIFEST" ]; then
  while IFS= read -r old_name; do
    [ -n "$old_name" ] || continue
    grep -Fqx "$old_name" "$NEW_MANIFEST" && continue
    stale_dir="$DEST_ROOT/$old_name"
    [ -e "$stale_dir" ] || continue
    rm -rf "$stale_dir"
    echo "removed retired skill $old_name from $DEST_ROOT"
  done < "$MANIFEST"
fi

mv "$NEW_MANIFEST" "$MANIFEST"
echo "managed skill list -> $MANIFEST"

if [ "$PUBLISH_ONLY" -eq 1 ]; then
  echo "publish complete (local installation skipped)"
  exit 0
fi

bash "$SETUP_SCRIPTS/link-tool.sh" claude "$MODE"
bash "$SETUP_SCRIPTS/link-tool.sh" codex "$MODE"

# Remove links created by the former direct-link implementation. Third-party
# skills and any links not pointing into this repository are left untouched.
if [ -d "$HOME/.agents/skills" ]; then
  for legacy_link in "$HOME/.agents/skills"/*; do
    [ -L "$legacy_link" ] || continue
    legacy_target="$(readlink "$legacy_link")"
    case "$legacy_target" in
      "$REPO/skills/"*)
        rm "$legacy_link"
        echo "removed legacy direct link: $legacy_link"
        ;;
    esac
  done
fi

bash "$SETUP_SCRIPTS/verify.sh" "$MODE" --tools claude,codex
echo "publish and local installation complete"
