#!/usr/bin/env bash
set -euo pipefail

# skills/ 아래의 확정 스킬을 ~/.claude/skills에 symlink로 설치한다.
# 레포가 source of truth — git pull이 곧 업데이트다. (mattpocock/skills 관례)

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.claude/skills"

# DEST 자체가 이 레포를 가리키는 symlink면, 아래 루프가 레포의 skills/ 트리 안에
# symlink를 다시 써넣게 된다. 감지해서 중단한다. (mattpocock/skills link-skills.sh 관례)
if [ -L "$DEST" ]; then
  resolved="$(readlink -f "$DEST")"
  case "$resolved" in
    "$REPO"|"$REPO"/*)
      echo "error: $DEST 가 이 레포를 가리키는 symlink다 ($resolved)." >&2
      echo "제거 후($DEST) 재실행하라 — 스크립트가 실제 디렉토리로 다시 만든다." >&2
      exit 1
      ;;
  esac
fi

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
