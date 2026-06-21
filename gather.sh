#!/usr/bin/env bash
# gather.sh — agent-agnostic weekly delta orchestrator.
#
# Per-genre research is run in parallel via the shell (xargs -P), not via
# in-agent subagents. This keeps the runbook single-threaded and lets you
# swap CLIs freely:
#
#   ./gather.sh                                  # default: claude -p
#   AGENT_CMD="codex exec --full-auto" ./gather.sh
#   AGENT_CMD="gemini -p" ./gather.sh
#   PARALLEL=3 ./gather.sh                       # lower concurrency
#   DATE=2026-06-20 ./gather.sh                  # override "today"
#
set -euo pipefail
cd "$(dirname "$0")"

AGENT_CMD="${AGENT_CMD:-claude -p}"
PARALLEL="${PARALLEL:-7}"
DATE="${DATE:-$(date +%Y-%m-%d)}"
DATE_FROM="$(date -d "$DATE -7 days" +%Y-%m-%d 2>/dev/null \
  || date -j -v-7d -f "%Y-%m-%d" "$DATE" "+%Y-%m-%d")"

[ -f runbook.md ] || { echo "missing runbook.md" >&2; exit 2; }
if [ ! -f genres.conf ]; then
  echo "missing genres.conf" >&2
  echo "  run: cp genres.conf.example genres.conf  (then edit it with your categories)" >&2
  exit 2
fi
RUNBOOK="$(cat runbook.md)"

SHARDDIR="weekly/shards/${DATE}"
mkdir -p "$SHARDDIR"

mapfile -t GENRES < <(grep -vE '^\s*(#|$)' genres.conf)

echo "[gather] date=$DATE from=$DATE_FROM genres=${#GENRES[@]} parallel=$PARALLEL agent='$AGENT_CMD'"

run_shard() {
  local line="$1"
  local slug="${line%%|*}"
  local label="${line#*|}"
  local raw="$SHARDDIR/${slug}.raw"
  local out="$SHARDDIR/${slug}.md"

  local prompt
  prompt="${RUNBOOK//\{\{GENRE\}\}/$label}"
  prompt="${prompt//\{\{DATE\}\}/$DATE}"
  prompt="${prompt//\{\{DATE_FROM\}\}/$DATE_FROM}"

  echo "[gather] -> $slug ($label)"
  if ! echo "$prompt" | eval "$AGENT_CMD" > "$raw" 2>&1; then
    echo "[gather] !! agent exited non-zero for $slug" >&2
  fi
  if ! grep -q '^EXITCODE_OK$' "$raw"; then
    echo "[gather] !! missing EXITCODE_OK for $slug (kept .raw for inspection)" >&2
    return 1
  fi
  awk '/^<<<BEGIN_REPORT$/{f=1;next} /^<<<END_REPORT$/{f=0} f' "$raw" > "$out"
  echo "[gather] OK $slug ($(wc -l < "$out") lines)"
}
export -f run_shard
export AGENT_CMD SHARDDIR RUNBOOK DATE DATE_FROM

printf '%s\n' "${GENRES[@]}" \
  | xargs -n1 -P "$PARALLEL" -I{} bash -c 'run_shard "$@"' _ {} \
  || echo "[gather] some shards failed; merging what we have"

# Merge shards into one weekly file.
OUT="weekly/weekly_${DATE}.md"
{
  echo "# 週次デルタ ${DATE}（${DATE_FROM} 〜 ${DATE}）"
  echo
  echo "直近7日間に動いた天井をジャンル別にまとめたもの。空欄ジャンルは _動きなし_ または取得失敗。"
  echo
  for line in "${GENRES[@]}"; do
    slug="${line%%|*}"
    label="${line#*|}"
    shard="$SHARDDIR/${slug}.md"
    echo "---"
    echo
    echo "## $label"
    echo
    if [ -s "$shard" ]; then
      # Drop the shard's own H1 to avoid duplicate top-level headings.
      sed '1{/^# /d;}' "$shard"
    else
      echo "_動きなし or 取得失敗_"
    fi
    echo
  done
} > "$OUT"

echo "[gather] merged -> $OUT ($(wc -l < "$OUT") lines)"

./build.sh

echo "[gather] done."
