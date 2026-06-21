# explore-engine

新しい目標を最適ツールへ即ルーティングするための「能力フロンティア地図」を、毎週自動更新するためのエンジン。

ペイン起点（exploit）ではなくサービス起点（explore）でジャンル横断に天井（フロンティア）の移動を観測し、徒労率を下げるための個人用ツール。

## 思想

- **「手順」と「知能」を分離する**
  - 手順 = `build.sh`（決定的・LLM不要・冪等）
  - 知能 = `runbook.md`（Claudeに食わせる週次指示書）
- **時間に対する天井移動**を `before → after` で記述する
  - 製品AとBのピア比較や「君はXすべき」という決め打ちはしない
- **ジャンルは可変**。`runbook.md` のジャンル表を書き換えればフォーク完了。

## クイックスタート

```bash
git clone <repo>
cd explore-engine

# 1) Claudeに週次デルタを取らせる
claude -p "$(cat runbook.md)"

# 2) .md → .html + index を再生成
./build.sh

# 3) （任意）静的配信先にもコピー
DELIVERY_DIR=/mnt/c/path/to/static ./build.sh
```

## ディレクトリ

```
explore-engine/
├── README.md
├── runbook.md          ← Claudeに食わせる週次指示書（自分用に編集可）
├── build.sh            ← 決定的なビルドスクリプト（.md→.html + index）
├── templates/          ← 雛形（天井移動エントリ / 週次デルタ）
├── examples/           ← サンプル出力（こういうのが出ます）
├── genres/             ← ローカルのジャンル別フロンティア地図（.gitignore対象）
├── weekly/             ← ローカルの週次デルタ（.gitignore対象）
└── index.html          ← ローカルの入口（.gitignore対象）
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

`runbook.md` を編集すれば、ジャンル一覧・スコープ・並列数・「やってはいけないこと」を自分用に変えられる。
これがフォークの肝。

## 自動化（任意）

OS側 cron / Windowsタスクスケジューラ から週次で `claude -p "$(cat runbook.md)" && ./build.sh` を叩けば真の自動化になる。Claude Code内蔵 cron は REPL起動中しか発火しないため非推奨。

## FS安全則（WSL利用時）

WSLからWindowsへ配信する場合：URLの多い `.md` を `/mnt/c` に直書きすると Windows Defender が無音で隔離する（`cp` は成功扱いだがファイルは幽霊化）。
`build.sh` の `DELIVERY_DIR=` は必ず `.html` のみをコピーする設計。`.md` は WSL ネイティブに置く。

## ライセンス

MIT
