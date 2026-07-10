#!/usr/bin/env bash
set -euo pipefail

# skills/ 아래의 확정 스킬을 ~/.claude/skills에 symlink로 설치한다.
# 레포가 source of truth — git pull이 곧 업데이트다. (mattpocock/skills 관례)

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.claude/skills"
mkdir -p "$DEST"

found=0
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  if [ -e "$DEST/$name" ] && [ ! -L "$DEST/$name" ]; then
    echo "skip $name — $DEST/$name 이 symlink가 아닌 실체로 존재. 확인 후 제거하고 재실행." >&2
    continue
  fi
  ln -sfn "$src" "$DEST/$name"
  echo "linked $name -> $src"
  found=1
done < <(find "$REPO/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -print0 2>/dev/null)

[ "$found" = 1 ] || echo "skills/에 확정 스킬이 아직 없다."
