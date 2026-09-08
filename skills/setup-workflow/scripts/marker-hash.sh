#!/usr/bin/env bash
# P-0023
#
# Compute, verify, and stamp the integrity hash of an agent-workflow-protocol
# marker block. The update mode of setup-workflow compares the recorded hash
# against the block's real content to detect hand edits before re-rendering.
#
# Usage:
#   marker-hash.sh compute <file> [marker-name]   # print the hash of the block
#   marker-hash.sh check   <file> [marker-name]   # 0 = intact, 1 = unsafe, 2 = absent, 3 = malformed
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

# Resolve one exact start/end pair. Duplicate, orphaned, nested, or reversed
# markers are malformed; never guess which managed region the user intended.
start_line() {
  grep -n "^${START}P-[0-9]\{4\} start -->$" "$FILE" 2>/dev/null | cut -d: -f1
}
end_line() {
  grep -nFx "$END" "$FILE" 2>/dev/null | cut -d: -f1
}

validate_structure() {
  local starts ends sc ec s e hc
  starts="$(start_line)"; ends="$(end_line)"
  sc="$(printf '%s\n' "$starts" | grep -c '[0-9]' || true)"
  ec="$(printf '%s\n' "$ends" | grep -c '[0-9]' || true)"
  if [ "$sc" -eq 0 ] && [ "$ec" -eq 0 ]; then
    echo "marker-hash: marker block '$MARKER' not found in $FILE" >&2
    return 2
  fi
  if [ "$sc" -ne 1 ] || [ "$ec" -ne 1 ]; then
    echo "marker-hash: malformed marker block '$MARKER' (starts=$sc, ends=$ec)" >&2
    return 3
  fi
  s="$starts"; e="$ends"
  if [ "$e" -le "$s" ]; then
    echo "marker-hash: malformed marker order for '$MARKER'" >&2
    return 3
  fi
  hc="$(sed -n "$((s + 1)),$((e - 1))p" "$FILE" | grep -cF "$HASH_PREFIX" || true)"
  if [ "$hc" -gt 1 ]; then
    echo "marker-hash: multiple hash lines inside '$MARKER'" >&2
    return 3
  fi
}

body() {
  local s e
  validate_structure || return $?
  s="$(start_line)"; e="$(end_line)"
  sed -n "$((s + 1)),$((e - 1))p" "$FILE" | grep -vF "$HASH_PREFIX"
}

# Hash of the marker body, or exit 2 when the block is absent. `body | sha256`
# cannot be used directly: a pipeline reports only the last command's status, so
# a missing block would silently hash empty input.
actual_hash() {
  local content status
  if content="$(body)"; then
    :
  else
    status=$?
    exit "$status"
  fi
  printf '%s\n' "$content" | sha256
}

recorded_hash() {
  local s e
  validate_structure || return $?
  s="$(start_line)"; e="$(end_line)"
  sed -n "$((s + 1)),$((e - 1))p" "$FILE" \
    | sed -n "s|^${HASH_PREFIX} *\([a-f0-9]\{64\}\) -->$|\1|p"
}

case "$CMD" in
  compute)
    actual_hash
    ;;

  check)
    ACTUAL="$(actual_hash)"
    RECORDED="$(recorded_hash)"
    if [ -z "$RECORDED" ]; then
      echo "marker-hash: UNSAFE — no valid hash is recorded inside '$MARKER'" >&2
      exit 1
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
    S="$(start_line)"; E="$(end_line)"
    if sed -n "$((S + 1)),$((E - 1))p" "$FILE" | grep -qF "$HASH_PREFIX"; then
      sed "${S},${E}s|^${HASH_PREFIX}.*|${HASH_PREFIX} ${ACTUAL} -->|" "$FILE" > "$TMP"
    else
      # Insert the hash line right after the start marker.
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
