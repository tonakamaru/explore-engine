# explore-engine

新しい目標を最適ツールへ即ルーティングするための「能力フロンティア地図」を、毎週自動更新するためのエンジン。

ペイン起点（exploit）ではなくサービス起点（explore）でジャンル横断に天井（フロンティア）の移動を観測し、徒労率を下げるための個人用ツール。

## 思想

- **「手順」と「知能」を分離する**
  - 手順 = `build.sh` / `gather.sh`（決定的・LLM不要・冪等）
  - 知能 = `runbook.md`（任意の AI CLI に食わせる単一ジャンル指示書）
- **時間に対する天井移動**を `before → after` で記述する
  - 製品AとBのピア比較や「君はXすべき」という決め打ちはしない
- **ジャンル定義は `genres.conf`、リサーチ手順は `runbook.md`、並列化はシェル**
  - エージェント側のサブエージェント機能には依存しない → モデル/CLI 非依存

## クイックスタート

```bash
git clone https://github.com/tonakamaru/explore-engine
cd explore-engine

# 1) 9ジャンル並列リサーチ → 週次ファイル生成 → HTML/index 再生成 まで一括
./gather.sh

# 2) ブラウザで見る
open index.html        # macOS
xdg-open index.html    # Linux

# 3) （任意）静的配信先にもコピー
DELIVERY_DIR=/mnt/c/path/to/static ./build.sh
```

## エージェントを差し替える

`gather.sh` は `AGENT_CMD` 環境変数で任意の AI CLI に差し替え可能:

```bash
./gather.sh                                       # 既定: claude -p
AGENT_CMD="codex exec --full-auto" ./gather.sh    # OpenAI Codex CLI
AGENT_CMD="gemini -p" ./gather.sh                 # Google Gemini CLI
PARALLEL=3 ./gather.sh                            # 並列数を絞る
DATE=2026-06-20 ./gather.sh                       # 「今日」を上書き
```

並列化は**エージェント側ではなくシェル側**で行う設計のため、サブエージェント機能を持たない CLI でも同等に動く。

## ディレクトリ

```
explore-engine/
├── README.md
├── runbook.md         ← 単一ジャンルのリサーチ指示書（{{GENRE}} 置換あり）
├── genres.conf        ← ジャンル定義（slug|label 一行ずつ・自分で編集）
├── gather.sh          ← 並列オーケストレータ（ジャンル別 shard → merge → build）
├── build.sh           ← 決定的ビルド（.md → .html + index.html）
├── templates/         ← 雛形（天井移動エントリ / 週次デルタ）
├── examples/          ← サンプル出力（こういうのが出ます）
├── genres/            ← ローカルのジャンル別地図（.gitignore対象）
├── weekly/            ← ローカルの週次デルタ＋shards/（.gitignore対象）
└── index.html         ← ローカルの入口（.gitignore対象）
```

`genres/` `weekly/` `index.html` は各自のローカル運用データなのでバージョン管理しない。

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

- **ジャンルの増減**: `genres.conf` を編集（slug は filename 用英小文字、label は runbook に渡る表示名）
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

## ライセンス

MIT
