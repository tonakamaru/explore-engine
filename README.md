# explore-engine

新しい目標を最適ツールへ即ルーティングするための「能力フロンティア地図」を、毎週自動更新するためのエンジン。

ペイン起点（exploit）ではなくサービス起点（explore）でジャンル横断に天井（フロンティア）の移動を観測し、徒労率を下げるための個人用ツール。

## 思想

- **「手順」と「知能」を分離する**
  - 手順 = `build.sh` / `gather.sh` / `mapgen.sh`（決定的・LLM不要・冪等）
  - 知能 = `runbook.md` / `runbook_map.md`（任意の AI CLI に食わせる指示書）
- **時間に対する天井移動**を `before → after` で記述する
  - 製品AとBのピア比較や「君はXすべき」という決め打ちはしない
- **2種類の出力**を分けて扱う:
  - **フロンティア地図** (mapgen.sh + runbook_map.md): 各ジャンルの「現在の天井」スナップショット。長期スキャン（既定12ヶ月）。初回 or 大きい変化があった時に再生成
  - **週次デルタ** (gather.sh + runbook.md): 直近7日間の天井移動。毎週回す増分
- **ジャンル定義は `genres.conf`、並列化はシェル**
  - エージェント側のサブエージェント機能には依存しない → モデル/CLI 非依存

## クイックスタート

```bash
git clone https://github.com/tonakamaru/explore-engine
cd explore-engine

# 1) ジャンル定義をコピーして自分用に編集
cp genres.conf.example genres.conf
$EDITOR genres.conf

# 2) 初回: 各ジャンルの「現在のフロンティア地図」を生成（既定で過去12ヶ月をスキャン）
./mapgen.sh
# 任意で開始日を指定（例: 2024年4月以降の全期間をスキャン）
SCAN_FROM=2024-04-01 ./mapgen.sh

# 3) 以降は週次デルタ（直近7日間に動いたものだけ）
./gather.sh

# 4) ブラウザで見る
open index.html        # macOS
xdg-open index.html    # Linux

# 5) （任意）静的配信先にもコピー
DELIVERY_DIR=/path/to/static ./build.sh
```

## エージェントを差し替える

`gather.sh` と `mapgen.sh` はどちらも `AGENT_CMD` 環境変数で任意の AI CLI に差し替え可能:

```bash
./gather.sh                                       # 既定: claude -p
AGENT_CMD="codex exec --full-auto" ./gather.sh    # OpenAI Codex CLI
AGENT_CMD="gemini -p" ./gather.sh                 # Google Gemini CLI
PARALLEL=3 ./gather.sh                            # 並列数を絞る
DATE=2026-06-20 ./gather.sh                       # 「今日」を上書き

./mapgen.sh ai-coding                             # 1ジャンルだけ再マップ
SCAN_FROM=2024-04-01 SCAN_TO=2026-06-21 ./mapgen.sh
```

並列化は**エージェント側ではなくシェル側**で行う設計のため、サブエージェント機能を持たない CLI でも同等に動く。

## ディレクトリ

```
explore-engine/
├── README.md
├── runbook.md            ← 週次デルタ用の指示書（7日スコープ）
├── runbook_map.md        ← フロンティア地図用の指示書（長期スキャン）
├── genres.conf.example   ← ジャンル定義のテンプレ（cp してから編集）
├── gather.sh             ← 週次デルタの並列オーケストレータ
├── mapgen.sh             ← フロンティア地図の並列オーケストレータ
├── build.sh              ← 決定的ビルド（.md → .html + index.html）
├── templates/            ← 雛形（天井移動エントリ / 週次デルタ）
├── genres.conf           ← 自分のジャンル定義（.gitignore対象）
├── genres/               ← ローカルのジャンル別地図（.gitignore対象）
├── weekly/               ← ローカルの週次デルタ＋shards/（.gitignore対象）
└── index.html            ← ローカルの入口（.gitignore対象）
```

`genres.conf` `genres/` `weekly/` `index.html` は各自のローカル運用データなのでバージョン管理しない。

## 出力フォーマット（天井移動エントリ）

```
### N. タイトル　〔時期: YYYY-MM〕
**規模感**: 大/中/小 — 理由
**能力**: 何が新たに可能になったか
**可能性空間**: 一般化したクラス（個人への決め打ちはしない）
**before → after**: 過去の天井 → 現在の天井
**出典**: URL
```

ピア間比較ではなく**時間比較**。固定ベースライン（before）を必ず明示する。

## カスタマイズ

- **ジャンルの増減**: `genres.conf`（`genres.conf.example` からコピーした自分用ファイル）を編集（slug は filename 用英小文字、label は runbook に渡る表示名）
- **リサーチの規約**: `runbook.md` の「規約」「やってはいけないこと」「few-shot サンプル」を編集
- **並列数**: `PARALLEL=N ./gather.sh`
- **配信先**: `DELIVERY_DIR=...`

## 出力プロトコル（エージェント側）

`runbook.md` は出力に厳格なプロトコルを要求する:

- `<<<BEGIN_REPORT` / `<<<END_REPORT` マーカーで本文を挟む
- 最後に `EXITCODE_OK` を単独行で出力する
- マーカーが揃わない出力は失敗扱い

これは CLI 横断で**「終わった/終わってない」**を文字列で判定するための約束事。エージェントの「考えてる風の前置き」を本文から切り離せる。

## 自動化（任意）

OS側 cron / Windowsタスクスケジューラ から週次で `./gather.sh` を叩けば真の自動化になる。Claude Code 内蔵 cron は REPL 起動中しか発火しないため非推奨。

例（月曜 08:57 ローカル）:

```cron
57 8 * * 1 cd /path/to/explore-engine && ./gather.sh >> gather.log 2>&1
```

## FS安全則（WSL利用時）

WSL から Windows へ配信する場合：URLの多い `.md` を `/mnt/c` に直書きすると Windows Defender が無音で隔離する（`cp` は成功扱いだがファイルは幽霊化）。
`build.sh` の `DELIVERY_DIR=` は必ず `.html` のみをコピーする設計。`.md` は WSL ネイティブに置く。

## トラブルシューティング

### Windows / Git Bash で `claude -p` 経由だと全 shard が失敗する

**症状**: 既定の `AGENT_CMD="claude -p"` のまま `./gather.sh` / `./mapgen.sh` を Git Bash から実行すると、全ジャンルが `agent exited non-zero` → `missing EXITCODE_OK` で失敗する。`weekly/shards/<日付>/<slug>.raw` を覗くと:

```
/c/Users/<you>/AppData/Roaming/npm/claude: line 12:
C:\Users\<you>\anaconda3\Library\c\Users\<you>\AppData\Roaming\npm/node_modules/@anthropic-ai/claude-code/bin/claude.exe:
No such file or directory
```

**原因**: `@anthropic-ai/claude-code` を npm global インストールした際の **Git Bash 用シム**（`.../npm/claude`）が `basedir` 解決を誤り、無関係な PATH 要素（例: `anaconda3\Library\...`）を前置した壊れたパスを組み立てている。`claude.exe` 実体は存在し、PowerShell 経由（`claude.ps1`）なら正常に動く。CLI 本体ではなく Git Bash 用シムの不具合。

**回避策**: `claude.exe` の実体を `AGENT_CMD` に直接指定する:

```bash
CLAUDE_EXE='"/c/Users/<you>/AppData/Roaming/npm/node_modules/@anthropic-ai/claude-code/bin/claude.exe"'
AGENT_CMD="$CLAUDE_EXE -p" ./gather.sh
AGENT_CMD="$CLAUDE_EXE -p" ./mapgen.sh
```

`<you>` はあなたの Windows ユーザー名。実体パスが違う場合は `where claude` / `where claude.exe` で確認できる。

（報告: [#1](https://github.com/tonakamaru/explore-engine/issues/1) — Git Bash + 4 ジャンルで実証済み）

### `mapfile: command not found` / 構文エラー（macOS）

macOS デフォルト bash は 3.2 で `mapfile` をサポートしていない。`brew install bash` で 4.x/5.x を入れ、`bash ./gather.sh` のように明示的に新しい bash で実行する。

## ライセンス

MIT
