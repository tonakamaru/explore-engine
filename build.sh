#!/usr/bin/env bash
# explore-engine build: .md → .html + index.html regen. Idempotent. LLM-free.
set -euo pipefail

cd "$(dirname "$0")"

CSS_CDN="https://cdn.jsdelivr.net/npm/github-markdown-css@5/github-markdown.css"
MARKED_CDN="https://cdn.jsdelivr.net/npm/marked@12/marked.min.js"

render_page() {
  local md="$1" out="$2" back="$3" title
  title=$(grep -m1 '^# ' "$md" | sed 's/^# //' || echo "untitled")
  {
    cat <<EOF
<!doctype html>
<html lang="ja"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>${title}</title>
<link rel="stylesheet" href="${CSS_CDN}">
<script src="${MARKED_CDN}"></script>
<style>body{box-sizing:border-box;max-width:880px;margin:0 auto;padding:32px 24px}
@media(prefers-color-scheme:dark){body{background:#0d1117;color-scheme:dark}}
.nav{margin-bottom:16px;font-size:.85rem}.nav a{color:#0969da;text-decoration:none}.nav a:hover{text-decoration:underline}</style>
</head><body>
<div class="nav"><a href="${back}">&larr; index</a></div>
<article class="markdown-body" id="out"></article>
<script id="md" type="text/markdown">
EOF
    cat "$md"
    cat <<'EOF'
</script>
<script>document.getElementById('out').innerHTML=marked.parse(document.getElementById('md').textContent);</script>
</body></html>
EOF
  } > "$out"
}

# Render each .md → sibling .html under genres/ and weekly/
for d in genres weekly; do
  [ -d "$d" ] || continue
  shopt -s nullglob
  for md in "$d"/*.md; do
    render_page "$md" "${md%.md}.html" "../index.html"
  done
  shopt -u nullglob
done

# Generate index.html by scanning directories.
{
  cat <<'EOF'
<!doctype html>
<html lang="ja"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>探索エンジン</title>
<style>
:root{--bg:#f6f8fa;--card:#fff;--fg:#1f2328;--muted:#656d76;--accent:#0969da;--border:#d0d7de}
@media(prefers-color-scheme:dark){:root{--bg:#0d1117;--card:#161b22;--fg:#e6edf3;--muted:#8b949e;--accent:#4493f8;--border:#30363d}}
body{margin:0;background:var(--bg);color:var(--fg);font-family:-apple-system,"Segoe UI","Hiragino Kaku Gothic ProN",Meiryo,sans-serif;line-height:1.55}
.wrap{max-width:880px;margin:0 auto;padding:44px 24px}h1{font-size:1.7rem;margin:0 0 4px}h2{font-size:1.08rem;margin:30px 0 8px}
.sub{color:var(--muted);font-size:.92rem;margin:0 0 18px}
.card{display:block;background:var(--card);border:1px solid var(--border);border-radius:10px;padding:13px 17px;margin:8px 0;text-decoration:none;color:inherit;transition:.15s}
a.card:hover{border-color:var(--accent);transform:translateY(-1px)}
.title{font-weight:600;font-size:.99rem}.empty{color:var(--muted);font-size:.9rem;font-style:italic}
.foot{color:var(--muted);font-size:.8rem;margin-top:30px;border-top:1px solid var(--border);padding-top:14px}
</style></head><body><div class="wrap">
<h1>探索エンジン</h1>
<p class="sub">能力フロンティア地図と週次デルタ</p>
<h2>ジャンル別フロンティア地図</h2>
EOF

  shopt -s nullglob
  genres=(genres/*.md)
  if [ ${#genres[@]} -gt 0 ]; then
    for md in "${genres[@]}"; do
      t=$(grep -m1 '^# ' "$md" | sed 's/^# //' || basename "$md" .md)
      printf '<a class="card" href="%s"><div class="title">%s</div></a>\n' "${md%.md}.html" "$t"
    done
  else
    echo '<p class="empty">まだありません。</p>'
  fi
  echo '<h2>週次デルタ</h2>'
  weekly=(weekly/*.md)
  if [ ${#weekly[@]} -gt 0 ]; then
    # newest first (filenames are weekly_YYYY-MM-DD.md so lexsort = chrono)
    IFS=$'\n' sorted=($(printf '%s\n' "${weekly[@]}" | sort -r))
    for md in "${sorted[@]}"; do
      t=$(grep -m1 '^# ' "$md" | sed 's/^# //' || basename "$md" .md)
      printf '<a class="card" href="%s"><div class="title">%s</div></a>\n' "${md%.md}.html" "$t"
    done
  else
    echo '<p class="empty">まだありません。</p>'
  fi
  shopt -u nullglob
  cat <<'EOF'
<p class="foot">地図＝現在の状態 / 週次＝変化のデルタ。<a href="README.md">README</a></p>
</div></body></html>
EOF
} > index.html

# Optional delivery: copy HTML only (no .md) to DELIVERY_DIR.
if [ -n "${DELIVERY_DIR:-}" ]; then
  mkdir -p "$DELIVERY_DIR/genres" "$DELIVERY_DIR/weekly"
  cp index.html "$DELIVERY_DIR/"
  shopt -s nullglob
  for f in genres/*.html weekly/*.html; do
    cp "$f" "$DELIVERY_DIR/$f"
  done
  shopt -u nullglob
  echo "delivered to: $DELIVERY_DIR"
fi

shopt -s nullglob
gn=(genres/*.html); wn=(weekly/*.html)
shopt -u nullglob
echo "built: ${#gn[@]} genre + ${#wn[@]} weekly + index.html"
