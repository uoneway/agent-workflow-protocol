#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
SKILL="$REPO/skills/setup-workflow"
HASH="$SKILL/scripts/marker-hash.sh"
DETECT="$SKILL/scripts/detect-repo-state.sh"
PROTOCOL_STAMP="$(tr -d '[:space:]' < "$SKILL/PROTOCOL_STAMP")"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/setup-workflow-test.XXXXXX")"
trap 'rm -rf "$TMP_ROOT"' EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

expect_status() {
  local expected="$1"
  shift
  local actual=0
  "$@" >/dev/null 2>&1 || actual=$?
  [ "$actual" -eq "$expected" ] || fail "expected status $expected, got $actual: $*"
}

render_block() {
  local template="$1" stamp="$2" output="$3" marker="${4:-agent-workflow-protocol}"
  sed "s/{{PROTOCOL_STAMP}}/$stamp/g" "$template" > "$output"
  "$HASH" stamp "$output" "$marker" >/dev/null
}

# New repository imprint: render, stamp, preserve surrounding project text.
GREEN="$TMP_ROOT/green"
mkdir -p "$GREEN"
printf '%s\n' '# Project rules' '' '- keep this' > "$GREEN/AGENTS.md"
render_block "$SKILL/templates/agents-block.md" "$PROTOCOL_STAMP" "$GREEN/block.md"
printf '\n' >> "$GREEN/AGENTS.md"
sed -n '1,$p' "$GREEN/block.md" >> "$GREEN/AGENTS.md"
printf '%s\n' '' '<!-- project-tail -->' >> "$GREEN/AGENTS.md"
"$HASH" check "$GREEN/AGENTS.md" >/dev/null
grep -Fqx -- '- keep this' "$GREEN/AGENTS.md" || fail "project prelude was not preserved"
grep -Fqx '<!-- project-tail -->' "$GREEN/AGENTS.md" || fail "project tail was not preserved"

# Current, stale-but-intact, hand-modified, missing, and duplicate marker cases.
STALE="$TMP_ROOT/stale.md"
render_block "$SKILL/templates/agents-block.md" P-0025 "$STALE"
"$HASH" check "$STALE" >/dev/null
sed 's/Orient → Align/Orient -> Align/' "$STALE" > "$TMP_ROOT/modified.md"
expect_status 1 "$HASH" check "$TMP_ROOT/modified.md"
printf '%s\n' '# no marker' > "$TMP_ROOT/absent.md"
expect_status 2 "$HASH" check "$TMP_ROOT/absent.md"
sed -n '1,$p' "$STALE" > "$TMP_ROOT/duplicate.md"
sed -n '1,$p' "$STALE" >> "$TMP_ROOT/duplicate.md"
expect_status 3 "$HASH" check "$TMP_ROOT/duplicate.md"

# Global blocks use an independent marker name and hash.
render_block "$SKILL/templates/global-routing.md" "$PROTOCOL_STAMP" "$TMP_ROOT/global.md" agent-workflow-protocol-global
"$HASH" check "$TMP_ROOT/global.md" agent-workflow-protocol-global >/dev/null

# Brownfield detection reports structural facts and remembers machine placement.
BROWN="$TMP_ROOT/brown"
MACHINE="$TMP_ROOT/machine"
mkdir -p "$BROWN/docs" "$MACHINE/config/agent-workflow-protocol" "$MACHINE/home/.codex"
git init -q "$BROWN"
cp "$GREEN/AGENTS.md" "$BROWN/AGENTS.md"
printf '%s\n' '@AGENTS.md' > "$BROWN/CLAUDE.md"
printf '%s\n' '# Product direction' > "$BROWN/VISION.md"
printf '%s\n' '# Existing design' > "$BROWN/docs/design.md"
printf '%s\n' '{"placement":"local-only"}' > "$MACHINE/config/agent-workflow-protocol/setup-state.json"
HOME="$MACHINE/home" XDG_CONFIG_HOME="$MACHINE/config" "$DETECT" "$BROWN" > "$TMP_ROOT/state.json"
python3 - "$TMP_ROOT/state.json" "$PROTOCOL_STAMP" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    state = json.load(source)

assert state["has_git"] is True
assert state["already_setup"] is True
assert state["marker_start_count"] == 1
assert state["marker_end_count"] == 1
assert state["protocol_stamp"] == sys.argv[2]
assert state["claude_md"] == "pointer"
assert "VISION.md" in state["doc_candidates"]
assert "design.md" in state["docs_dir"]
assert state["machine_routing_asked"] is True
assert state["machine_routing_choice"] == "local-only"
assert state["tool_hint"] == ["codex"]
PY

# The independently published stamp stays aligned with the authoritative history.
LATEST_PROTOCOL_STAMP="$(sed -n 's/^| \(P-[0-9][0-9][0-9][0-9]\) |.*/\1/p' "$REPO/AGENT_WORKFLOW_PROTOCOL.md" | tail -1)"
[ "$PROTOCOL_STAMP" = "$LATEST_PROTOCOL_STAMP" ] \
  || fail "bundled protocol stamp $PROTOCOL_STAMP does not match history $LATEST_PROTOCOL_STAMP"

# Publishing discovers the confirmed skill and includes its runtime resources.
PUBLISH_CONFIG="$TMP_ROOT/publish/config"
mkdir -p "$PUBLISH_CONFIG/ai/skills"
"$REPO/scripts/link-skills.sh" --config-dir "$PUBLISH_CONFIG" --publish-only >/dev/null
[ -f "$PUBLISH_CONFIG/ai/skills/setup-workflow/SKILL.md" ] || fail "published skill is missing SKILL.md"
[ -f "$PUBLISH_CONFIG/ai/skills/setup-workflow/agents/openai.yaml" ] || fail "published skill is missing UI metadata"
[ -f "$PUBLISH_CONFIG/ai/skills/setup-workflow/PROTOCOL_STAMP" ] || fail "published skill is missing protocol stamp"
[ ! -e "$PUBLISH_CONFIG/ai/skills/setup-workflow/DRAFT.md" ] || fail "draft leaked into published skill"
[ "$(wc -l < "$PUBLISH_CONFIG/ai/skills/.agent-workflow-protocol-managed" | tr -d ' ')" -eq 5 ] \
  || fail "managed manifest does not contain five published skills"
[ ! -e "$PUBLISH_CONFIG/ai/skills/upstream-scout" ] || fail "repository-local skill was published"

# A manifest written before the P-0027 rename is adopted once: retired skills are removed
# and differing managed copies are replaced instead of being treated as unmanaged.
LEGACY_CONFIG="$TMP_ROOT/legacy/config"
mkdir -p "$LEGACY_CONFIG/ai/skills/kickoff" "$LEGACY_CONFIG/ai/skills/align"
echo stale > "$LEGACY_CONFIG/ai/skills/kickoff/SKILL.md"
echo stale > "$LEGACY_CONFIG/ai/skills/align/SKILL.md"
printf 'align\nkickoff\n' > "$LEGACY_CONFIG/ai/skills/.link-workflow-managed"
"$REPO/scripts/link-skills.sh" --config-dir "$LEGACY_CONFIG" --publish-only >/dev/null \
  || fail "legacy manifest was not adopted"
[ ! -e "$LEGACY_CONFIG/ai/skills/kickoff" ] || fail "retired skill from legacy manifest was kept"
diff -qr "$REPO/skills/align" "$LEGACY_CONFIG/ai/skills/align" >/dev/null || fail "legacy managed skill was not replaced"
[ ! -e "$LEGACY_CONFIG/ai/skills/.link-workflow-managed" ] || fail "legacy manifest was not removed"

echo "setup-workflow tests: PASS"
