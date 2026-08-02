#!/usr/bin/env bash
# P-0012
#
# docs/decision-logs/*.md 를 AGENT_WORKFLOW_PROTOCOL.md §4 「결정 ID 규약」에 맞게 검사한다.
#
# 검사 항목
#   ERROR  히스토리 항목 제목이 `### D-NNNN — <제목> (YYYY-MM-DD)` 형식이 아님
#   ERROR  ID가 4자리 zero-pad가 아님
#   ERROR  날짜가 YYYY-MM-DD 형식이 아니거나 실재하지 않는 날짜
#   ERROR  중복 ID (레포 전역)
#   ERROR  prefix 혼용 (레포당 D- 또는 ADR- 하나만)
#   ERROR  `## Current Decision` 섹션이 없는 파일
#   ERROR  레포 어디에서든 존재하지 않는 ID를 인용
#   WARN   ID 연번의 구멍 (항목이 다른 주제 파일로 옮겨졌을 수 있으므로 경고)
#   WARN   어느 `## Current Decision` 에서도 인용되지 않은 ID (결정 실질의 거처 없음)
#   WARN   `## Decision History` 밖에 있는 결정 항목 제목
#
# 인용 스캔에서 제외: .git/, node_modules/, docs/_research/
#
# 사용법: lint-decision-logs.sh [repo-root]
#   repo-root 생략 시 `git rev-parse --show-toplevel`, 실패하면 현재 디렉토리.
#   exit 0 = 문제 없음 또는 경고만 / exit 1 = 오류 하나 이상.
#
# bash 3.2 (macOS 기본) 호환 — 연관 배열·mapfile·${var,,} 사용 금지. jq 비의존.

set -euo pipefail
export LC_ALL=C

TAB=$'\t'
DASH='—' # U+2014 EM DASH — 제목 구분자

usage() {
  cat <<'EOF'
usage: lint-decision-logs.sh [repo-root]

docs/decision-logs/*.md 를 결정 ID 규약(AGENT_WORKFLOW_PROTOCOL.md §4)에 맞게 검사한다.
repo-root 를 생략하면 git rev-parse --show-toplevel, 실패하면 현재 디렉토리를 쓴다.

exit 0: 문제 없음 또는 경고만   exit 1: 오류 있음
EOF
}

case "${1:-}" in
  -h | --help)
    usage
    exit 0
    ;;
esac

ROOT="${1:-}"
if [ -z "$ROOT" ]; then
  ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  [ -n "$ROOT" ] || ROOT="."
fi
if [ ! -d "$ROOT" ]; then
  echo "error: not a directory: $ROOT" >&2
  exit 1
fi
cd "$ROOT"

LOGDIR="docs/decision-logs"
if [ ! -d "$LOGDIR" ]; then
  echo "no decision logs to lint"
  exit 0
fi

WORK="$(mktemp -d "${TMPDIR:-/tmp}/lint-decision-logs.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

FILES="$WORK/files"       # 검사 대상 md 경로
ENTRIES="$WORK/entries"   # num \t prefix \t file \t line
CURTEXT="$WORK/curtext"   # 모든 Current Decision 섹션 본문
FINDINGS="$WORK/findings" # file \t line \t level \t message
IDSET="$WORK/idset"       # 존재하는 ID 토큰 (D-NNNN 형태)
: >"$ENTRIES"
: >"$CURTEXT"
: >"$FINDINGS"
: >"$IDSET"

find "$LOGDIR" -type f -name '*.md' | sort >"$FILES"
if [ ! -s "$FILES" ]; then
  echo "no decision logs to lint"
  exit 0
fi

finding() { # level file line message
  printf '%s\t%s\t%s\t%s\n' "$2" "$3" "$1" "$4" >>"$FINDINGS"
}

# 실재하는 날짜인가 (YYYY-MM-DD 형식은 호출 전에 확인된 상태)
valid_date() {
  local y m d max
  y=$((10#${1:0:4}))
  m=$((10#${1:5:2}))
  d=$((10#${1:8:2}))
  [ "$m" -ge 1 ] && [ "$m" -le 12 ] || return 1
  case "$m" in
    1 | 3 | 5 | 7 | 8 | 10 | 12) max=31 ;;
    4 | 6 | 9 | 11) max=30 ;;
    *)
      if [ $((y % 4)) -eq 0 ] && { [ $((y % 100)) -ne 0 ] || [ $((y % 400)) -eq 0 ]; }; then
        max=29
      else
        max=28
      fi
      ;;
  esac
  [ "$d" -ge 1 ] && [ "$d" -le "$max" ]
}

# 텍스트에서 D-NNNN / ADR-NNNN 토큰만 뽑는다.
# 1단계에서 대시를 포함한 최대 토큰을 잡고(3D-NNNN 같은 앞붙음 방지),
# 2단계에서 정확히 D-/ADR- + 4자리인 것만 남긴다.
extract_ids() {
  grep -o -E '[A-Za-z0-9_]+-[0-9]+' "$1" 2>/dev/null | grep -x -E '(D|ADR)-[0-9]{4}' || true
}

ENTRY_RE="^###[[:space:]]+(D|ADR)-([0-9]{4})[[:space:]]+${DASH}[[:space:]]+(.+)[[:space:]]+\(([0-9]{4}-[0-9]{2}-[0-9]{2})\)[[:space:]]*$"
ID_RE='^###[[:space:]]+(D|ADR)-([0-9]+)'
SEP_RE="[[:space:]]${DASH}[[:space:]]"
TAIL_RE='\(([^()]*)\)[[:space:]]*$'
ISO_RE='^[0-9]{4}-[0-9]{2}-[0-9]{2}$'

# ── 1단계: 파일별 스캔 ────────────────────────────────────────────────
while IFS= read -r f <&3; do
  awk '
    { sub(/\r$/, "") }
    /^## / {
      h = substr($0, 4)
      sub(/^[ \t]+/, "", h); sub(/[ \t]+$/, "", h)
      if (h == "Current Decision") sec = "cur"
      else if (h == "Decision History") sec = "hist"
      else sec = "other"
      print "S\t" NR "\t" sec "\t"
      next
    }
    /^### / { print "H\t" NR "\t" (sec == "" ? "none" : sec) "\t" $0; next }
    { if (sec == "cur") print "C\t" NR "\t" sec "\t" $0 }
  ' "$f" >"$WORK/scan"

  has_cur=0
  while IFS="$TAB" read -r tag lno sec text; do
    case "$tag" in
      S)
        if [ "$sec" = "cur" ]; then has_cur=1; fi
        ;;
      C)
        printf '%s\n' "$text" >>"$CURTEXT"
        ;;
      H)
        if [ "$sec" != "hist" ]; then
          if [ "$sec" = "cur" ]; then printf '%s\n' "$text" >>"$CURTEXT"; fi
          if [[ $text =~ $ID_RE ]]; then
            finding WARN "$f" "$lno" "decision entry outside a '## Decision History' section"
          fi
          continue
        fi

        if [[ $text =~ $ID_RE ]]; then
          prefix="${BASH_REMATCH[1]}"
          digits="${BASH_REMATCH[2]}"
          if [ "${#digits}" -ne 4 ]; then
            finding ERROR "$f" "$lno" "decision ID must be zero-padded to 4 digits: ${prefix}-${digits}"
            continue
          fi
          printf '%s\t%s\t%s\t%s\n' "$digits" "$prefix" "$f" "$lno" >>"$ENTRIES"
          if [[ $text =~ $ENTRY_RE ]]; then
            edate="${BASH_REMATCH[4]}"
            if ! valid_date "$edate"; then
              finding ERROR "$f" "$lno" "not a real date: ${edate} (${prefix}-${digits})"
            fi
          elif [[ ! $text =~ $SEP_RE ]]; then
            finding ERROR "$f" "$lno" "entry title separator must be '${DASH}' (em dash U+2014): ${prefix}-${digits}"
          else
            tail_val=""
            if [[ $text =~ $TAIL_RE ]]; then tail_val="${BASH_REMATCH[1]}"; fi
            if [ -n "$tail_val" ] && [[ ! $tail_val =~ $ISO_RE ]]; then
              finding ERROR "$f" "$lno" "date must be YYYY-MM-DD, found '(${tail_val})': ${prefix}-${digits}"
            else
              finding ERROR "$f" "$lno" "malformed entry title; expected '### ${prefix}-${digits} ${DASH} <title> (YYYY-MM-DD)'"
            fi
          fi
        else
          finding ERROR "$f" "$lno" "not a decision entry; '## Decision History' takes only '### D-NNNN ${DASH} <title> (YYYY-MM-DD)' headings"
        fi
        ;;
    esac
  done <"$WORK/scan"

  if [ "$has_cur" -eq 0 ]; then
    finding ERROR "$f" 1 "missing '## Current Decision' section"
  fi
done 3<"$FILES"

file_count="$(wc -l <"$FILES" | tr -d ' ')"
entry_count="$(wc -l <"$ENTRIES" | tr -d ' ')"

# ── 2단계: 레포 전역 ID 검사 ─────────────────────────────────────────
if [ -s "$ENTRIES" ]; then
  sort -t"$TAB" -k1,1 -k3,3 -k4,4n "$ENTRIES" >"$WORK/entries.sorted"

  # 레포 prefix = 최다 사용 prefix (동수면 사전순)
  repo_prefix="$(cut -f2 "$ENTRIES" | sort | uniq -c | sort -k1,1rn -k2,2 | head -1 | awk '{print $2}')"

  prev_num=""
  prev_loc=""
  while IFS="$TAB" read -r num prefix f lno; do
    if [ "$prefix" != "$repo_prefix" ]; then
      finding ERROR "$f" "$lno" "mixed ID prefix: repo uses ${repo_prefix}-, found ${prefix}-${num}"
    fi
    if [ "$num" = "$prev_num" ]; then
      finding ERROR "$f" "$lno" "duplicate ID ${prefix}-${num} (also at ${prev_loc})"
    else
      prev_num="$num"
      prev_loc="$f:$lno"
    fi
    printf '%s-%s\n' "$prefix" "$num" >>"$IDSET"
  done <"$WORK/entries.sorted"

  sort -u "$IDSET" -o "$IDSET"

  # 연번 구멍 — 최소~최대 사이만 본다 (경고)
  cut -f1 "$ENTRIES" | sort -u >"$WORK/nums"
  prev=""
  while IFS= read -r num; do
    if [ -n "$prev" ]; then
      n=$((10#$num))
      p=$((10#$prev))
      if [ "$n" -gt $((p + 1)) ]; then
        missing=""
        i=$((p + 1))
        while [ "$i" -lt "$n" ]; do
          missing="${missing}${missing:+, }${repo_prefix}-$(printf '%04d' "$i")"
          i=$((i + 1))
        done
        loc="$(awk -F'\t' -v n="$num" '$1 == n { print $3 "\t" $4; exit }' "$WORK/entries.sorted")"
        gf="${loc%%$TAB*}"
        gl="${loc##*$TAB}"
        finding WARN "$gf" "$gl" "ID sequence gap before ${repo_prefix}-${num}: missing ${missing}"
      fi
    fi
    prev="$num"
  done <"$WORK/nums"

  # Current Decision 에서 한 번도 인용되지 않은 ID (경고)
  extract_ids "$CURTEXT" | sort -u >"$WORK/curcites"
  while IFS="$TAB" read -r num prefix f lno; do
    if ! grep -q -x -F "${prefix}-${num}" "$WORK/curcites" 2>/dev/null; then
      finding WARN "$f" "$lno" "${prefix}-${num} is not cited in any '## Current Decision' section"
    fi
  done <"$WORK/entries.sorted"
fi

# ── 3단계: 레포 전역 인용 해소 ───────────────────────────────────────
grep -r -n -I -o -E \
  --exclude-dir=.git --exclude-dir=node_modules \
  '[A-Za-z0-9_]+-[0-9]+' . 2>/dev/null >"$WORK/rawcites" || true

# 해소되지 않는 토큰 집합을 먼저 만들어 두고, 그 토큰이 든 줄만 다시 훑는다
# (인용이 많은 레포에서 줄마다 grep 을 띄우지 않기 위해)
awk -F: '{ print $NF }' "$WORK/rawcites" |
  grep -x -E '(D|ADR)-[0-9]{4}' | sort -u >"$WORK/alltokens" || true
comm -23 "$WORK/alltokens" "$IDSET" >"$WORK/unknown"

: >"$WORK/badcites"
if [ -s "$WORK/unknown" ]; then
  grep -F -f "$WORK/unknown" "$WORK/rawcites" >"$WORK/badcites" || true
fi

while IFS= read -r hit; do
  path="${hit%%:*}"
  rest="${hit#*:}"
  cl="${rest%%:*}"
  token="${rest#*:}"
  path="${path#./}"
  case "$path" in
    docs/_research/*) continue ;;
  esac
  [[ $token =~ ^(D|ADR)-[0-9]{4}$ ]] || continue
  if grep -q -x -F "$token" "$WORK/unknown"; then
    finding ERROR "$path" "$cl" "citation to unknown decision ID ${token}"
  fi
done <"$WORK/badcites"

# ── 보고 ─────────────────────────────────────────────────────────────
sort -t"$TAB" -k1,1 -k2,2n "$FINDINGS" |
  awk -F'\t' '{ printf "%s: %s:%s: %s\n", $3, $1, $2, $4 }'

errors="$(awk -F'\t' '$3 == "ERROR"' "$FINDINGS" | wc -l | tr -d ' ')"
warns="$(awk -F'\t' '$3 == "WARN"' "$FINDINGS" | wc -l | tr -d ' ')"

echo "summary: ${errors} error(s), ${warns} warning(s) in ${file_count} decision-log file(s), ${entry_count} decision(s)"

[ "$errors" -eq 0 ] || exit 1
exit 0
