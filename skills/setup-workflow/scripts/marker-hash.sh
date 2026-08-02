#!/usr/bin/env bash
# P-0012
#
# Compute, verify, and stamp the integrity hash of an agent-workflow-protocol
# marker block. The update mode of setup-workflow compares the recorded hash
# against the block's real content to detect hand edits before re-rendering.
#
# Usage:
#   marker-hash.sh compute <file> [marker-name]   # print the hash of the block
#   marker-hash.sh check   <file> [marker-name]   # 0 = intact, 1 = hand-edited, 2 = no marker
#   marker-hash.sh stamp   <file> [marker-name]   # rewrite the hash line in place
#
# marker-name defaults to `agent-workflow-protocol`; pass
# `agent-workflow-protocol-global` for the global routing block.
#
# The hashed content is every line strictly between the start and end markers,
# excluding the hash line itself. Portable to bash 3.2 (macOS). No jq.

set -euo pipefail

CMD="${1:-}"
FILE="${2:-}"
MARKER="${3:-agent-workflow-protocol}"

usage() {
  sed -n '4,16p' "$0" | sed 's/^# \{0,1\}//'
  exit 64
}

[ -n "$CMD" ] && [ -n "$FILE" ] || usage
[ -f "$FILE" ] || { echo "marker-hash: no such file: $FILE" >&2; exit 66; }

START="<!-- $MARKER "
END="<!-- $MARKER end -->"
HASH_PREFIX="<!-- $MARKER-hash:"

sha256() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 | cut -d' ' -f1
  elif command -v sha256sum >/dev/null 2>&1; then
    sha256sum | cut -d' ' -f1
  else
    echo "marker-hash: neither shasum nor sha256sum found" >&2
    exit 69
  fi
}

# Line numbers of the start and end markers. `agent-workflow-protocol ` also
# prefixes `agent-workflow-protocol-global `, so the plain marker must not match
# the global block: require the next token to be a P-stamp.
start_line() {
  grep -n "^${START}P-[0-9]\{4\} start -->" "$FILE" 2>/dev/null | head -1 | cut -d: -f1
}
end_line() {
  grep -nF "$END" "$FILE" 2>/dev/null | head -1 | cut -d: -f1
}

body() {
  local s e
  s="$(start_line)"; e="$(end_line)"
  if [ -z "$s" ] || [ -z "$e" ] || [ "$e" -le "$s" ]; then
    return 1
  fi
  sed -n "$((s + 1)),$((e - 1))p" "$FILE" | grep -vF "$HASH_PREFIX"
}

# Hash of the marker body, or exit 2 when the block is absent. `body | sha256`
# cannot be used directly: a pipeline reports only the last command's status, so
# a missing block would silently hash empty input.
actual_hash() {
  local content
  if ! content="$(body)"; then
    echo "marker-hash: marker block '$MARKER' not found in $FILE" >&2
    exit 2
  fi
  printf '%s\n' "$content" | sha256
}

recorded_hash() {
  sed -n "s|^${HASH_PREFIX} *\([a-f0-9]\{64\}\).*|\1|p" "$FILE" | head -1
}

case "$CMD" in
  compute)
    actual_hash
    ;;

  check)
    ACTUAL="$(actual_hash)"
    RECORDED="$(recorded_hash)"
    if [ -z "$RECORDED" ]; then
      echo "marker-hash: no hash recorded yet (first stamp pending)"
      exit 0
    fi
    if [ "$ACTUAL" = "$RECORDED" ]; then
      echo "marker-hash: intact"
      exit 0
    fi
    echo "marker-hash: MODIFIED — the marker block was edited by hand." >&2
    echo "  recorded: $RECORDED" >&2
    echo "  actual:   $ACTUAL" >&2
    exit 1
    ;;

  stamp)
    ACTUAL="$(actual_hash)"
    TMP="$FILE.marker-hash.tmp"
    if grep -qF "$HASH_PREFIX" "$FILE"; then
      sed "s|^${HASH_PREFIX}.*|${HASH_PREFIX} ${ACTUAL} -->|" "$FILE" > "$TMP"
    else
      # Insert the hash line right after the start marker.
      S="$(start_line)"
      { sed -n "1,${S}p" "$FILE"
        printf '%s %s -->\n' "$HASH_PREFIX" "$ACTUAL"
        sed -n "$((S + 1)),\$p" "$FILE"
      } > "$TMP"
    fi
    mv "$TMP" "$FILE"
    echo "$ACTUAL"
    ;;

  *)
    usage
    ;;
esac
