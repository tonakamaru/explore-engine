#!/usr/bin/env bash
# mapgen.sh — agent-agnostic frontier-map generator (long-form, per-genre).
#
# Produces genres/genre_<slug>.md for each genre in genres.conf, covering
# the period $SCAN_FROM .. $SCAN_TO. Unlike gather.sh (7-day weekly delta),
# this is the "current state baseline" of a genre's frontier.
#
# Usage:
#   ./mapgen.sh                          # all genres in genres.conf
#   ./mapgen.sh ai-coding                # just this genre slug
#   SCAN_FROM=2024-04-01 ./mapgen.sh     # custom start (default: 12 mo ago)
#   SCAN_TO=2026-06-21  ./mapgen.sh      # custom end   (default: today)
#   AGENT_CMD="codex exec --full-auto" ./mapgen.sh
#   PARALLEL=3 ./mapgen.sh
#
set -euo pipefail
cd "$(dirname "$0")"

AGENT_CMD="${AGENT_CMD:-claude -p}"
PARALLEL="${PARALLEL:-7}"
SCAN_TO="${SCAN_TO:-$(date +%Y-%m-%d)}"
SCAN_FROM="${SCAN_FROM:-$(date -d "$SCAN_TO -12 months" +%Y-%m-%d 2>/dev/null \
  || date -j -v-12m -f "%Y-%m-%d" "$SCAN_TO" "+%Y-%m-%d")}"

[ -f runbook_map.md ] || { echo "missing runbook_map.md" >&2; exit 2; }
if [ ! -f genres.conf ]; then
  echo "missing genres.conf" >&2
  echo "  run: cp genres.conf.example genres.conf  (then edit it with your categories)" >&2
  exit 2
fi
RUNBOOK="$(cat runbook_map.md)"

mkdir -p genres

mapfile -t ALL < <(grep -vE '^\s*(#|$)' genres.conf)
if [ $# -gt 0 ]; then
  WANT="$1"
  GENRES=()
  for line in "${ALL[@]}"; do
    [ "${line%%|*}" = "$WANT" ] && GENRES+=("$line")
  done
  if [ ${#GENRES[@]} -eq 0 ]; then
    echo "no genre matches slug: $WANT" >&2
    echo "available slugs:" >&2
    printf '  %s\n' "${ALL[@]%%|*}" >&2
    exit 2
  fi
else
  GENRES=("${ALL[@]}")
fi

echo "[mapgen] from=$SCAN_FROM to=$SCAN_TO genres=${#GENRES[@]} parallel=$PARALLEL agent='$AGENT_CMD'"

run_map() {
  local line="$1"
  local slug="${line%%|*}"
  local label="${line#*|}"
  local raw="genres/genre_${slug}.raw"
  local out="genres/genre_${slug}.md"

  local prompt
  prompt="${RUNBOOK//\{\{GENRE\}\}/$label}"
  prompt="${prompt//\{\{SCAN_FROM\}\}/$SCAN_FROM}"
  prompt="${prompt//\{\{SCAN_TO\}\}/$SCAN_TO}"

  echo "[mapgen] -> $slug ($label)"
  if ! echo "$prompt" | eval "$AGENT_CMD" > "$raw" 2>&1; then
    echo "[mapgen] !! agent exited non-zero for $slug" >&2
  fi
  if ! grep -q '^EXITCODE_OK$' "$raw"; then
    echo "[mapgen] !! missing EXITCODE_OK for $slug (kept .raw for inspection)" >&2
    return 1
  fi
  awk '/^<<<BEGIN_REPORT$/{f=1;next} /^<<<END_REPORT$/{f=0} f' "$raw" > "$out"
  rm -f "$raw"
  echo "[mapgen] OK $slug ($(wc -l < "$out") lines)"
}
export -f run_map
export AGENT_CMD RUNBOOK SCAN_FROM SCAN_TO

printf '%s\n' "${GENRES[@]}" \
  | xargs -n1 -P "$PARALLEL" -I{} bash -c 'run_map "$@"' _ {} \
  || echo "[mapgen] some genres failed; rebuilding what we have"

./build.sh

echo "[mapgen] done."
