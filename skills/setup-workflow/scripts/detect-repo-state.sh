#!/usr/bin/env bash
# P-0023
#
# Pre-flight detection for setup-workflow. Emits one JSON object describing the
# target repository so the skill branches on facts instead of guesses.
#
# Usage: detect-repo-state.sh [repo-root]
# Portable to bash 3.2 (macOS). No jq dependency.

set -euo pipefail

ROOT="${1:-}"
if [ -z "$ROOT" ]; then
  ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
fi
cd "$ROOT"

MARKER_START_RE='^<!-- agent-workflow-protocol P-[0-9][0-9][0-9][0-9] start -->$'
MARKER_END='<!-- agent-workflow-protocol end -->'
STATE_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/link-workflow/setup-state.json"

# --- helpers ---------------------------------------------------------------

# Escape a string for embedding in a JSON double-quoted value.
json_escape() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/	/\\t/g'
}

# Print a JSON array from newline-separated stdin. Empty input yields [].
json_array() {
  local first=1 line
  printf '['
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    if [ $first -eq 1 ]; then first=0; else printf ', '; fi
    printf '"%s"' "$(json_escape "$line")"
  done
  printf ']'
}

# Read a top-level string field out of a flat JSON file without jq.
# Returns empty when the file or key is absent.
json_read_string() {
  local file="$1" key="$2"
  [ -f "$file" ] || return 0
  sed -n "s/.*\"$key\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$file" | head -1
}

# --- git -------------------------------------------------------------------

if [ -d .git ] || git rev-parse --git-dir >/dev/null 2>&1; then
  HAS_GIT=true
else
  HAS_GIT=false
fi

REMOTE=none
if [ "$HAS_GIT" = true ]; then
  REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"
  case "$REMOTE_URL" in
    *github.com*) REMOTE=github ;;
    *gitlab.com*|*gitlab.*) REMOTE=gitlab ;;
    ?*) REMOTE=other ;;
  esac
fi

# --- marker block ----------------------------------------------------------

ALREADY_SETUP=false
PROTOCOL_STAMP=""
MARKER_START_COUNT=0
MARKER_END_COUNT=0
if [ -f AGENTS.md ]; then
  MARKER_START_COUNT="$(grep -Ec "$MARKER_START_RE" AGENTS.md 2>/dev/null || true)"
  MARKER_END_COUNT="$(grep -Fxc "$MARKER_END" AGENTS.md 2>/dev/null || true)"
fi
if [ "$MARKER_START_COUNT" -gt 0 ]; then
  ALREADY_SETUP=true
  PROTOCOL_STAMP="$(sed -n 's/.*<!-- agent-workflow-protocol \(P-[0-9]\{4\}\) start -->.*/\1/p' AGENTS.md | head -1)"
fi

# --- AGENTS.md / CLAUDE.md -------------------------------------------------

if [ -f AGENTS.md ]; then AGENTS_MD=exists; else AGENTS_MD=missing; fi

CLAUDE_MD=missing
if [ -f CLAUDE.md ]; then
  # A pointer is a CLAUDE.md whose only substantive line is the @AGENTS.md import.
  SUBSTANTIVE="$(sed -e '/^[[:space:]]*$/d' -e '/^[[:space:]]*<!--/d' CLAUDE.md | wc -l | tr -d ' ')"
  if [ "$SUBSTANTIVE" = "1" ] && grep -q '^[[:space:]]*@AGENTS\.md[[:space:]]*$' CLAUDE.md; then
    CLAUDE_MD=pointer
  else
    CLAUDE_MD=exists
  fi
fi

# --- docs/ -----------------------------------------------------------------

DOCS_LIST=""
if [ -d docs ]; then
  DOCS_LIST="$(ls -1 docs 2>/dev/null | while IFS= read -r e; do
    if [ -d "docs/$e" ]; then printf '%s/\n' "$e"; else printf '%s\n' "$e"; fi
  done)"
fi

# Root-level markdown that may need mapping (keep/convert/migrate/discard).
# AGENTS.md, CLAUDE.md and README.md are handled by their own rules, not mapping.
DOC_CANDIDATES="$(ls -1 *.md 2>/dev/null | grep -v -x -e 'AGENTS.md' -e 'CLAUDE.md' -e 'README.md' || true)"

# Directories at the repo root that hold documents the protocol would relocate.
for d in research notes docs-src adr; do
  if [ -d "$d" ]; then
    DOC_CANDIDATES="$(printf '%s\n%s/\n' "$DOC_CANDIDATES" "$d")"
  fi
done
DOC_CANDIDATES="$(printf '%s\n' "$DOC_CANDIDATES" | grep -v '^$' || true)"

# --- issue tracker ---------------------------------------------------------

TRACKER_HINT=none
if [ "$REMOTE" = github ] && command -v gh >/dev/null 2>&1; then
  # `gh issue list` fails when Issues are disabled for the repo.
  if gh issue list --limit 1 >/dev/null 2>&1; then
    TRACKER_HINT=github-issues
  fi
fi

# --- machine-level state ---------------------------------------------------

MACHINE_ASKED=false
MACHINE_CHOICE=null
if [ -f "$STATE_FILE" ]; then
  PLACEMENT="$(json_read_string "$STATE_FILE" placement)"
  if [ "$PLACEMENT" = global ] || [ "$PLACEMENT" = local-only ]; then
    MACHINE_ASKED=true
    MACHINE_CHOICE="\"$(json_escape "$PLACEMENT")\""
  fi
fi

TOOL_HINT=""
[ -d "$HOME/.claude" ] && TOOL_HINT="claude"
if [ -d "$HOME/.codex" ] || [ -d "$HOME/.agents" ]; then
  if [ -n "$TOOL_HINT" ]; then TOOL_HINT="$TOOL_HINT
codex"; else TOOL_HINT="codex"; fi
fi

# --- emit ------------------------------------------------------------------

printf '{\n'
printf '  "repo_root": "%s",\n' "$(json_escape "$ROOT")"
printf '  "has_git": %s,\n' "$HAS_GIT"
printf '  "already_setup": %s,\n' "$ALREADY_SETUP"
printf '  "marker_start_count": %s,\n' "$MARKER_START_COUNT"
printf '  "marker_end_count": %s,\n' "$MARKER_END_COUNT"
if [ -n "$PROTOCOL_STAMP" ]; then
  printf '  "protocol_stamp": "%s",\n' "$(json_escape "$PROTOCOL_STAMP")"
else
  printf '  "protocol_stamp": null,\n'
fi
printf '  "agents_md": "%s",\n' "$AGENTS_MD"
printf '  "claude_md": "%s",\n' "$CLAUDE_MD"
printf '  "docs_dir": %s,\n' "$(printf '%s\n' "$DOCS_LIST" | json_array)"
printf '  "doc_candidates": %s,\n' "$(printf '%s\n' "$DOC_CANDIDATES" | json_array)"
printf '  "remote": "%s",\n' "$REMOTE"
printf '  "tracker_hint": "%s",\n' "$TRACKER_HINT"
printf '  "machine_routing_asked": %s,\n' "$MACHINE_ASKED"
printf '  "machine_routing_choice": %s,\n' "$MACHINE_CHOICE"
printf '  "tool_hint": %s\n' "$(printf '%s\n' "$TOOL_HINT" | json_array)"
printf '}\n'
