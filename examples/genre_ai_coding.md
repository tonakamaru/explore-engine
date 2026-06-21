# AIコーディング/エージェント開発 天井フロンティア地図
**ジャンル**: AIコーディング・エージェント開発（コーディングエージェント／AI IDE／コーディング特化モデル／エージェントSDK／マルチエージェント・オーケストレーション／自律コーディング／関連プロトコル）  
**調査日**: 2026年6月20日  
**スコープ**: 2026年6月時点の能力天井。特に直近12ヶ月（2025年6月〜2026年6月）の移動を重視。

---

## 天井の現在地（サマリー）

AIコーディングの天井は「補完・提案」から「自律実行・デリバリー」へと段階的に移行した。1回のプロンプトで数万行のコードを生成し25時間以上継続動作するエージェントが存在し、SWE-bench Verified（実GitHub issueの解決率）ではフロンティアモデルが95%超を記録している。マルチエージェント並列実行・非同期タスク処理・Issue→PR→レビューのフルサイクル自動化は複数のプロダクション環境で実績を持つ段階に達した。プロトコル層ではMCP（Model Context Protocol）が97百万回/月のSDKダウンロードを超えLinux Foundationに移管、A2A（Agent2Agent）がGoogle主導で150以上の組織に採用されるなど、エコシステムの「配管インフラ」が標準化されつつある。オープンソースモデルもDeepSeek・Qwen系列が独立検証でフロンティアに肉薄し、構造的なコスト圧力が生じている。

---

## 天井移動リスト

---

### 1. 自律コーディングエージェントの実プロダクション定着　〔時期: 2025〜2026（通年で定着）〕

**規模感**: 大 — 「アシスト」から「デリバリー」へのカテゴリ移動

**能力**  
Devin（Cognition）は2025年通年でエンジニアリングチームに組み込まれ、数十万件のPRをマージした。PR採択率は2024年の34%から2025年に67%へ改善。セキュリティ脆弱性修正の所要時間：人間30分→Devin 1.5分（20倍）。ETLファイル移行：人間30〜40時間→Devin 3〜4時間（約10倍）。Litera社で回帰サイクルが93%短縮。Goldman Sachs・Santander・Nubank等で実運用中。

**可能性空間**  
「定型化できる中〜大規模の工学タスク」が人間の監督ありで丸投げ対象になる。テスト生成（カバレッジ50-60%→80-90%への自動引き上げ）、レガシー言語マイグレーション、セキュリティパッチ適用が特に適合度が高い。

**before → after**  
before: AIは提案するだけ。コードを書くのは人間、PRを開くのは人間、テストを走らせるのは人間。  
after: Issue登録→自律的に計画・実装・テスト→PRドラフト→人間レビューのみ、が標準フロー。

**出典**  
- [Devin's 2025 Performance Review | Cognition](https://cognition.com/blog/devin-annual-performance-review-2025)  
- [Devin AI Review 2026 | aitoolranked](https://aitoolranked.com/blog/devin-ai-review)  
- [Cognizant × Cognition partnership](https://news.cognizant.com/2026-01-28-Cognizant-and-Cognition-Partner-to-Scale-Autonomous-Software-Engineering-and-Deliver-Business-Value-Across-Enterprise-Operations)

---

### 2. SWE-bench Verified スコアの劇的上昇（13% → 95%超）　〔時期: 〜2026-06〕

**規模感**: 大 — ベンチマーク上は「実GitHub issueの大半を解ける」水準に到達

**能力**  
SWE-bench Verified（実GitHub issue 500件の解決タスク）におけるスコアの変遷：  
- 2024年初頭: 最高13.86%（Devin）  
- 2025年5月: Claude Opus 4 が 72.5%（公式）  
- 2026年6月18日: Claude Mythos 5 が 95.5%、Claude Fable 5 が 95%、Claude Opus 4.8 が 88.6%  
汚染耐性を重視するSWE-bench Pro（Scale AI製、1,865タスク）では標準化スコアがGPT-5.4（xHigh）で59.1%、ベンダー報告ではClaude Opus 4.8が69.2%。

**可能性空間**  
「Python製OSSリポジトリのバグ修正」というクラスのタスクが、人間の介在なしに機械的に解けるケースが多数生まれた。独立ベンチマーク（ProdCodeBench）では産業実データで53〜72%の解決率を確認。

**before → after**  
before: AIはパッチ提案を出すが、実際の動作確認・テスト通過は人間が行う必要があった。  
after: テスト通過まで自律的にループする（run→fail→fix→rerun）。

**出典**  
- [SWE-bench Leaderboard 2026 | codeant.ai](https://www.codeant.ai/blogs/swe-bench-scores)  
- [SWE-bench Verified - 53 LLM scores | BenchLM.ai](https://benchlm.ai/benchmarks/sweVerified)  
- [SWE-bench Pro Leaderboard | morphllm.com](https://www.morphllm.com/swe-bench-pro)  
- [ProdCodeBench | arXiv:2604.01527](https://arxiv.org/abs/2604.01527)  
- [Devin AI Review (SWE-bench 13.86%) | OpenAIToolsHub](https://www.openaitoolshub.org/en/blog/devin-ai-review)

---

### 3. 長時間自律実行（25時間・30,000行・13Mトークン）　〔時期: 2026（GPT-5.3期）〕

**規模感**: 大 — 「一問一答」から「プロジェクト単位の連続実行」への質的変化

**能力**  
OpenAI Codex（GPT-5.3-Codex動作）が約25時間の連続実行で30,000行以上のコードを生成した事例が公式に記録された。消費トークン数は約13M。フロンティアエージェントのタスク完了時間軸は約7ヶ月でダブリング中（METR研究）。最近モデルのo3は110分の時間軸で4時間超タスクに成功する例が複数記録されている。

**可能性空間**  
「マルチ機能のプロダクト（設計→実装→テスト→ドキュメント）」が単一エージェントセッションで完結するクラスのタスクが射程に入った。プロジェクトメモリ（仕様書・マイルストーン計画・ステータスファイル）と途中修正可能性（steerability）がコヒーレンス維持の鍵。

**before → after**  
before: コンテキストウィンドウの上限（数千〜数万トークン）が連続タスクの物理的な制約だった。  
after: ドキュメントをメモリとして外部化し、チェックポイント検証を挟むことで数時間〜数十時間の継続実行が可能。

**出典**  
- [Run long horizon tasks with Codex | OpenAI Developers](https://developers.openai.com/blog/run-long-horizon-tasks-with-codex)  
- [Measuring AI Ability to Complete Long Software Tasks | arXiv:2503.14499](https://arxiv.org/html/2503.14499v3)

---

### 4. 1Mトークンコンテキストの一般化とコスト平準化　〔時期: 2026-03〕

**規模感**: 大 — コードベース全体をコンテキストに載せる「リポジトリスケール理解」が標準化

**能力**  
Claude Opus 4.6・Sonnet 4.6が2026年3月に1Mトークンコンテキストを追加課金なし（同一単価）で正式GA。100,000行規模のコードベース（コメント・テスト・設定ファイル含む）が単一セッションに収まる。Google Gemini 2.5 Proは2Mトークンウィンドウを提供（30冊の小説・12時間の映像・大規模コードベースに相当）。

**可能性空間**  
「リポジトリ全体の一括レビュー」「横断的リファクタリング」「依存関係グラフの全量把握」が、RAGやチャンク分割なしに直接実行できるクラスのタスクになった。

**before → after**  
before: 大規模コードベースはRAG・チャンキング・要約を組み合わせた複雑なパイプラインが必要だった。  
after: リポジトリを丸ごとコンテキストに渡してクエリできる（ただし独立検証で1M超では有効想起率が低下する点は注意）。

**出典**  
- [1M Token Context Window | nstarx.github.io](https://nstarx.github.io/claude_internals/1m-context-window.html)  
- [AI Context Window Comparison 2026 | digitalapplied.com](https://www.digitalapplied.com/blog/ai-context-window-comparison-2026-1m-to-10m-tokens)  
- [Gemini 2.5 Pro improved coding | Google Developers Blog](https://developers.googleblog.com/en/gemini-2-5-pro-io-improved-coding-performance/)

---

### 5. MCPの標準プロトコル化とエコシステム規模（97M SDK DL/月）　〔時期: 2024-11〜（標準化加速 2025-12）〕

**規模感**: 大 — 「Anthropicの実験」から「AIエコシステムの配管インフラ」へ

**能力**  
MCPは2024年11月のAnthropicによる公開から約1年で：  
- SDK月次ダウンロード数: 97M超（全言語合計、2025年12月時点）  
- 本番稼働中のMCPサーバー: 10,000件以上  
- 統合済みAIクライアント: 数百種類  
主要ガバナンス変更: 2025年12月にLinux Foundation傘下の「Agentic AI Foundation」へ移管（Block・OpenAI・AWS・Google・Microsoftが創設メンバー）。  
技術的成熟: 2025年3月にStreamable HTTP導入、6月にOAuth 2.1、11月にClient ID Metadata DocumentsとPKCE S256でセキュリティ強化。

**可能性空間**  
異なるベンダーのAIエージェント・IDE・クラウドサービス・データベースが共通プロトコルで道具を共有する「道具のインターネット」が成立した。開発者が各ツールに個別プラグインを書く必要が消えるクラスの変化。

**before → after**  
before: AIツールがデータソースや外部サービスに接続するには、各ベンダーが独自のプラグイン仕様を実装する必要があった。  
after: MCP準拠のサーバーを1つ立てれば、MCP対応の全クライアント（VS Code、Cursor、ChatGPT、Claude等）から利用可能。

**出典**  
- [The 2026 MCP Roadmap | Model Context Protocol Blog](https://blog.modelcontextprotocol.io/posts/2026-mcp-roadmap/)  
- [MCP Adoption Statistics 2026 | digitalapplied.com](https://www.digitalapplied.com/blog/mcp-adoption-statistics-2026-model-context-protocol)  
- [2026: The Year for Enterprise-Ready MCP Adoption | CData](https://www.cdata.com/blog/2026-year-enterprise-ready-mcp-adoption)  
- [MCP Ecosystem in 2026 | ChatForest](https://chatforest.com/guides/mcp-ecosystem-2026-state-of-the-standard/)

---

### 6. マルチエージェント並列実行の実用化（エージェントチーム）　〔時期: 2025後半〜2026〕

**規模感**: 大 — 「1エージェント1タスク」から「エージェント艦隊の並列運用」へ

**能力**  
複数の主要プラットフォームが並列エージェント実行を実装：  
- **Claude Code**: オーケストレーターが専門化されたサブエージェントを並列スポーン（Task ツール経由）。Anthropic Agent SDKがTypeScript/Pythonで提供。  
- **OpenAI Codex**: 並列で複数エージェントを起動し異なるタスクを同時処理。macOSアプリで複数エージェントのダッシュボード管理。  
- **Cursor**: Background Agentsが非同期で動作しLinearチケット取得・CI実行・Slack通知が連携（Cursor 2.5以降）。  
- **Windsurf**: Wave 13で並列Cascadeセッションを実装。専用ターミナルプロファイル付き複数インスタンス。  
- **GitHub Agent HQ**: 複数エージェントへのタスク割り当て・進捗監視・権限管理を単一コントロールプレーンで提供（GitHub Universe 2025発表）。  
- **Replit Agent 4**: 2026年3月11日リリース。並列タスクフォークでマージコンフリクトの約90%を自動解決。

**可能性空間**  
フロントエンド・バックエンド・セキュリティ・テスト生成などを別エージェントが並列処理するという「専門エージェントチーム」アーキテクチャが実装可能になった。単一エージェントのボトルネックを回避して複雑プロジェクトを加速するクラスの設計が開く。

**before → after**  
before: エージェントは1つずつ順番に動作し、次のタスクは前のタスクが完了するまで待機が必要だった。  
after: 独立したサブタスクを並列でエージェントに割り当て、結果を集約できる。

**出典**  
- [Claude Agent SDK overview | code.claude.com](https://code.claude.com/docs/en/agent-sdk/overview)  
- [Code with Claude 2026: 5 New Agent Features | MindStudio](https://www.mindstudio.ai/blog/code-with-claude-2026-new-agent-features)  
- [5 ways to spawn Multi Agents with the Claude SDK | Medium](https://medium.com/@hugolu87/5-ways-to-spawn-multi-agents-with-the-claude-sdk-orchestra-swarms-f4816cf7e7b3)  
- [How we built our multi-agent research system | Anthropic](https://www.anthropic.com/engineering/multi-agent-research-system)

---

### 7. GitHub Copilot「Issue → PR」フルサイクルの自動化（GA）　〔時期: 2025-09 GA（2026-06 デスクトップ）〕

**規模感**: 中〜大 — GitHubという主流開発フローへのエージェント統合が完了

**能力**  
- 2025年5月: GitHub Copilot Coding Agentを発表（VS Code・Xcode・Eclipse・JetBrains・Visual Studio対応）。  
- 2025年9月: 全有料Copilotサブスクライバーに向けGA。  
- 2026年6月17日: GitHub Copilotデスクトップアプリ（Windows・macOS・Linux）をGA。エージェントコーディングセッションの起動・監視・検証・デプロイを統合管理。  
動作: GitHub issueをCopilotにアサインするとGitHub Actionsで自律実行し、インクリメンタルコミット付きドラフトPRを生成。スクリーンショット等の画像をissueに添付すればビジョン入力として処理。MCP経由でGitHub外部のデータにも接続。

**可能性空間**  
「issueトラッカーをAIへの指示書として使う」という開発フローが標準化された。定型的なバグ修正・機能追加をissue登録のみで着手できるクラスの運用が開く。ブランチ保護・CI/CD承認は人間が維持する設計。

**before → after**  
before: Copilotはエディタ内のコード補完・チャット支援にとどまり、PR作成は人間が行う必要があった。  
after: IssueをアサインするだけでドラフトPRが届く。レビューのみが人間の仕事。

**出典**  
- [GitHub Copilot meet the new coding agent | GitHub Blog](https://github.blog/news-insights/product-news/github-copilot-meet-the-new-coding-agent/)  
- [Introducing GitHub Copilot agent mode | VS Code Blog](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode/)  
- [Copilot coding agent GA | GitHub Community](https://github.com/orgs/community/discussions/159068)  
- [GitHub Copilot Desktop App GA 2026 | Windows Forum](https://windowsforum.com/threads/github-copilot-desktop-app-ga-2026-turns-ai-coding-into-a-supervised-agent-control-plane.427657/)

---

### 8. コーディング特化モデルの強化学習トレーニング（RL on SE tasks）　〔時期: 2025〕

**規模感**: 中〜大 — 汎用モデルの微調整ではなく、コーディングタスクで直接強化学習したモデルが登場

**能力**  
- **OpenAI codex-1（Codex Cloudの基盤）**: o3推論モデルをリアルなコーディングタスクで強化学習してチューニング。テストが通るまで自律的に反復する特性を持つ。  
- **SWE-RL（Meta, 2025）**: Llama 3ベースでGitHub PR・イシューなどソフトウェア進化の記録全体をデータとして強化学習。ルールベース報酬を使った初のSEタスク向けRL手法。  
- **DeepSWE-Preview（Agentica + Together AI）**: Qwen3-32Bから強化学習のみでトレーニングしたオープン系コーディングエージェント。  
- **Windsurf SWE-1/SWE-1.5**: IDEベンダー独自のコーディング特化モデル。SWE-1.5はClaude Sonnet 4.5比13倍の速度を主張（自社申告）。  
ProRL Agentは4B・8B・14BスケールのモデルでもマルチターンエージェントRLが有効と実証。

**可能性空間**  
RL学習により「テストを通す」「エラーメッセージを読んで修正する」などのエージェント的行動が内面化されたモデルが生まれた。汎用モデルより高速かつ精度の高い専用コーディングエージェントを、クローズドAPIに依存せずに構築できるクラスの設計が開く。

**before → after**  
before: コーディングAIはGPTシリーズ等の汎用モデルをfine-tuningするか、プロンプトエンジニアリングで補う方法が主流だった。  
after: コーディングタスク固有の検証シグナル（テスト合否）で直接RLを回すことで、エージェント的挙動を強制的に獲得できる。

**出典**  
- [DeepSWE: Training with RL | Together AI Blog](https://www.together.ai/blog/deepswe)  
- [SWE-RL paper | arXiv:2502.18449](https://arxiv.org/html/2502.18449v1)  
- [Windsurf SWE-1 launch | MarkTechPost](https://www.marktechpost.com/2025/05/16/windsurf-launches-swe-1-a-frontier-ai-model-family-for-end-to-end-software-engineering/)  
- [Cognition SWE-1.5 + Windsurf acquisition | NxCode](https://www.nxcode.io/resources/news/cognition-windsurf-acquisition-swe-1-5-codemaps-2026)

---

### 9. A2A（Agent2Agent）プロトコルの標準化とマルチエージェント相互接続　〔時期: 2025-04〜（2026拡大）〕

**規模感**: 中 — エージェント間通信の「HTTP相当インフラ」が整備されつつある

**能力**  
Google主導で2025年4月9日に公開されたAgent2Agent（A2A）プロトコルが2026年4月時点で150以上の組織に採用。HTTP・SSE・JSON-RPC 2.0を輸送層とし、Agent Cardsで能力広告。技術スタックとしてMCP（エージェント→ツール接続）とA2A（エージェント↔エージェント接続）の役割分担が確立。2025年6月23日にLinux Foundationがプロジェクトとして受理。参加組織はSalesforce・MongoDB・ServiceNow・Accenture・Deloitte・McKinsey等50社超（2026年4月は150社超）。

**可能性空間**  
異なるフレームワーク（LangChain・CrewAI・AutoGen等）や異なるベンダーが作ったエージェントが、プロトコル層で直接タスクをデリゲート・コーディネートできるアーキテクチャが開く。「エージェントマーケットプレイス」（能力を公告し、別エージェントが発見して利用する）が現実的設計に入ってきた。

**before → after**  
before: 複数エージェントを連携させるには、共通フレームワーク内のカスタム実装か密結合なAPIが必要だった。  
after: A2A準拠のエージェントはベンダー・フレームワーク問わず相互接続可能。

**出典**  
- [Linux Foundation A2A Project launch](https://www.linuxfoundation.org/press/linux-foundation-launches-the-agent2agent-protocol-project-to-enable-secure-intelligent-communication-between-ai-agents)  
- [Google A2A Protocol | DEV Community](https://dev.to/agentsindex/googles-a2a-protocol-how-ai-agents-communicate-across-frameworks-52jj)  
- [Google Cloud Unveils Agent2Agent Protocol | Platform Engineering](https://platformengineering.com/editorial-calendar/best-of-2025/google-cloud-unveils-agent2agent-protocol-a-new-standard-for-ai-agent-interoperability-2/)

---

### 10. オープンソース系コーディングモデルのフロンティア肉薄　〔時期: 〜2026-05〕

**規模感**: 中 — クローズドモデル独占から競争的マルチポーラーへの構造変化

**能力**  
- **DeepSeek-V4-Pro**: 1.6T総パラメータ（49Bアクティブ）のMoEモデル。LiveBench 2026年5月スナップショットでCoding Avg 69.99、Agentic Coding Avg 56.67。SWE-bench Verifiedで80.6%（2026年5月時点）。  
- **Qwen 3.6 Plus / Qwen3-235B-A22B**: Coding Avg 71.78（Qwen 3.6 27B、LiveBench 2026年5月）。o3・DeepSeek-R1・Gemini-2.5-Pro比較で競争力を確認。  
- **オープンソース全体**: LiveCodeBenchで90%、AIME 2025で97%に到達。「オープンウェイトモデルが本当に重要になり始めた」と複数の独立分析が評価。

**可能性空間**  
自社インフラ（GPU）を持つ組織がAPIコスト・データプライバシー・カスタマイズの自由度を確保しながら、フロンティアに近い性能のコーディングエージェントを運用できるクラスの選択肢が現実化した。

**before → after**  
before: プロダクション品質のコーディングエージェントはGPT-4・Claude等のクローズドAPIに依存する構造だった。  
after: DeepSeek・Qwen系列を自己ホストしてフロンティア水準に近い性能が得られる。

**出典**  
- [The Best Open-Source LLMs for Agentic Coding 2026 | MindStudio](https://www.mindstudio.ai/blog/best-open-source-llms-agentic-coding-2026)  
- [Best Open-Source LLM Models 2026 | Hugging Face Blog](https://huggingface.co/blog/daya-shankar/open-source-llms)

---

### 11. AI IDEの「エージェント化」：Cursor・Windsurf・VS Code　〔時期: 2025〜2026〕

**規模感**: 中 — エディタが「補完ツール」から「エージェントコントロールプレーン」へ

**能力**  
- **Cursor**: Background Agentsで非同期タスク実行。LinearチケットをCursorから直接アサインしCI・Slack連携まで自動化（Cursor 2.5）。Automations機能でスケジュール実行・依存更新・テスト生成をバックグラウンド処理。  
- **Windsurf（Cognition傘下、2025年12月買収）**: Wave 13で並列Cascadeセッション・「Cascade Hooks」（プレ/ポストアクショントリガー）・カスタムCodestyle自動強制。Devin自律エージェント能力のIDE統合が進行中。  
- **VS Code + GitHub Copilot**: Copilot agent modeがAI編集・端末コマンド・テスト実行のループをIDE内で完結（2025年2月GA）。  
- **Microsoft Agent Framework**: 2025年10月1日パブリックプレビュー。AutoGenとSemantic Kernelを統合しグラフベースワークフローを追加。

**可能性空間**  
「コードを書く場所」と「エージェントに指示する場所」が統合され、IDEがエージェントフリートの指揮センターになるアーキテクチャが実現した。開発者の作業が「実装」から「指示・レビュー・検証」にシフトするクラスの変化。

**before → after**  
before: IDEはファイルを開いてコードを書く場所。AIは補完の提案に留まる。  
after: IDEでタスクをアサイン→エージェントが非同期で動作→結果（PR・コミット）が届く。

**出典**  
- [Introducing GitHub Copilot agent mode | VS Code Blog](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode/)  
- [Windsurf Review 2026 | Taskade](https://www.taskade.com/blog/windsurf-review)  
- [Cognition's Windsurf Acquisition | NxCode](https://www.nxcode.io/resources/news/cognition-windsurf-acquisition-swe-1-5-codemaps-2026)

---

### 12. Claude Opus 4 / Sonnet 4 系列：拡張思考×ツール使用の同時実行　〔時期: 2025-05〕

**規模感**: 中 — 「推論してから行動する」から「推論しながら行動する」への変化

**能力**  
2025年5月22日リリースのClaude Opus 4・Sonnet 4で「ハイブリッド推論」が実装された。拡張思考中にツール（Web検索等）を並列実行し、推論とツール使用を交互に繰り返せる（ベータ機能）。コーディングでは：SWE-bench Verified 72.5%（Opus 4）・72.7%（Sonnet 4）。エージェントタスクでのショートカット回避率が前世代比65%改善。Sonnet 4で「ナビゲーションエラー20%→0%近くへ」（Replit社報告）。AIME 2025で拡張思考を有効化するとOpus 4のスコアが約33%→75%へ上昇（自社発表）。

**可能性空間**  
「複雑な推論を要するコーディングタスク」（設計判断・アーキテクチャ決定・難解なバグ）で、思考過程を外部化した上で検索・実行を混在させる「推論ファースト」なエージェントループが組めるようになった。

**before → after**  
before: モデルは思考か行動かを選択する必要があった（Chain-of-Thoughtか直接出力か）。  
after: 思考途中で検索・実行ツールを呼び出し、結果を推論に組み込んで継続できる。

**出典**  
- [Introducing Claude 4 | Anthropic](https://www.anthropic.com/news/claude-4)  
- [Claude Sonnet 4 and Opus 4 Review | Medium](https://medium.com/@leucopsis/claude-sonnet-4-and-opus-4-a-review-db68b004db90)

---

### 13. 自動テスト生成・CI統合エージェントの実用化　〔時期: 2025〜2026〕

**規模感**: 中 — テストが「書くもの」から「生成されるもの」へ

**能力**  
Qodo Cover・TestSprite・Diffblueなどの専用エージェントが、コードベース解析→テスト生成→実行→自己修復→CI統合のサイクルを自律実行。業界レポートで「テスト生成9倍高速化・テストメンテナンスコスト88%削減」。Devinはテストカバレッジを50-60%から80-90%に引き上げる事例を複数報告。Litera社では回帰サイクルが93%短縮。  
*注：2026年2月の独立研究（arXiv:2501.12793）は「テスト生成量がタスク解決率に統計的有意な効果を持たない」と指摘しており、自社申告の効果測定には慎重な解釈が必要。*

**可能性空間**  
「テストを後付けで書く」工程が自動化対象になり、TDDサイクルをAIが主導するアーキテクチャが実験段階から商用段階に入った。

**before → after**  
before: テスト生成はAIがコード提案を出すだけで、実行・修正・CI統合は人間が行う。  
after: テスト生成→実行→失敗→修正→再実行を全自動でループし、CI/CDに自動プッシュ。

**出典**  
- [How AI Is Redefining Software Testing 2026 | Evozon](https://www.evozon.com/how-ai-is-redefining-software-testing-practices-in-2026/)  
- [AI-Powered Automated Test Generation | Zylos Research](https://zylos.ai/research/2026-03-05-ai-agent-automated-test-generation/)  
- [Revisit Self-Debugging with Self-Generated Tests | arXiv:2501.12793](https://arxiv.org/pdf/2501.12793)

---

### 14. コンピュータ使用（Computer Use）の商用化　〔時期: 2024-10〜2025〕

**規模感**: 中 — 「コードを書く」を超えて「画面を操作する」能力がAPIで提供

**能力**  
Anthropic Claude：Computer Use機能（2024年10月初公開）でデスクトップ環境・ブラウザをclick/type/navigateで制御。OpenAI「Operator」（2025年1月23日）：Web経由で予約・購買等の実世界タスクを実行。OpenAIのComputer-Using AgentはWebVoyagerで87%・WebArenaで58.1%（内部ベンチマーク）。Browser Use（オープンソースフレームワーク）はWebVoyagerで89.1%の成功率（独立ベンチマーク相当、586タスク）。Browserbaseが2025年6月$40Mシリーズ調達・2025年中に50Mセッション処理。

**可能性空間**  
「コードを書いて実行する」の延長として「画面を見てUIを操作する」能力がエージェントに統合されることで、テスト自動化・レガシーシステム操作・SaaS横断ワークフロー実行がプログラミングなしで射程に入る。

**before → after**  
before: エージェントはAPIやCLIでのみ外部システムと接続できた。GUIのみのシステムは人間が操作する必要があった。  
after: GUIシステムをエージェントが直接操作でき、スクリーンショットベースのタスク指示が可能。

**出典**  
- [11 Best AI Browser Agents 2026 | Firecrawl](https://www.firecrawl.dev/blog/best-browser-agents)  
- [Building Browser Agents: Architecture | arXiv:2511.19477](https://arxiv.org/pdf/2511.19477)

---

### 15. AI生成コード比率の急上昇と開発フロー再編　〔時期: 2026時点〕

**規模感**: 中 — 開発者の仕事の性質が「実装」から「方向設定・検証」にシフト

**能力**  
統計的裏付け（2026年時点）：  
- 世界規模: 41%のコードがAI生成と推定  
- GitHub Copilot利用者平均: 46%のコードがAI生成（Javaは61%）  
- Big Tech: 25〜90%（組織による）  
- Gartner予測: 2026年末までに新規コードの60%がAI生成  
- 開発者採用率: 米国で92%が毎日AI開発ツールを使用、世界全体で82%が週次使用  
*品質面の注意点: AI共著コードには人間比1.7倍の重大な問題、AI生成コードの45%にOWASP Top-10脆弱性が含まれるとの独立調査あり（Cycode 2026 State of Product Security）。*

**可能性空間**  
「コードを書くコスト」の急低下が、プロトタイプ速度・実験の並列数・1人のエンジニアが管理できるプロジェクト数を拡大するクラスの変化。ただし検証・セキュリティ審査コストの上昇という対称的な変化が同時に発生している。

**before → after**  
before: エンジニアは実装の大部分を自ら書き、AIは補完・サジェストが役割だった。  
after: エンジニアの主作業が「仕様の精緻化・生成コードのレビュー・品質ゲート管理」に移行しつつある。

**出典**  
- [Vibe Coding Statistics 2026 | Hostinger](https://www.hostinger.com/blog/vibe-coding-statistics)  
- [State of Vibe Coding 2026 | Taskade](https://www.taskade.com/blog/state-of-vibe-coding)  
- [AI in Software Development Trends 2026 | Modall](https://modall.ca/blog/ai-in-software-development-trends-statistics)

---

## 萌芽／ウォッチ（まだ実用前だが来そうな兆し）

### A. エージェント記憶の永続化と経験蓄積　〔時期: 2026〜・萌芽〕
セッションをまたいで過去の作業・判断・コードベース知識を累積する「持続メモリ」が商用フレームワーク（Mem0・Cognee等）として整備されつつある。Just-In-Time RL（2026年1月arXiv:2603.14212）は「蓄積ログから動的にプロンプト構築」することでグラジェントなしの継続的学習を示した。実運用での長期的性能劣化防止（壊滅的忘却）は未解決のまま。経験蓄積エージェントは「新規プロジェクト初日から既存コードベースを理解した状態で動作する」可能性を持ち、オンボーディングコストを消す方向に働く。

### B. 形式検証×LLM統合　〔時期: 2026〜・萌芽〕
NeuroSymbolic Verifier・AgenticDomiKnowSなどの研究が、LLM出力を記号ソルバー・定理証明器で検証するパイプラインを実証中（2026年初頭）。AgenticDomiKnowSはNeSyプログラム開発を数時間→10〜15分に圧縮し86〜97%のグラフ正確度を達成（arXiv:2601.00743）。本格的な「証明可能正確性を持つコード生成」には至っていない。セキュリティクリティカル・安全クリティカル領域への適用拡大の前提条件となる技術。

### C. PASTE（投機的ツール実行）等の推論高速化　〔時期: 2026-03〜・萌芽〕
Pattern-Aware Speculative Tool Execution（2026年3月）はエージェントのツール呼び出しパターンを学習し、LLMが次の決定を下す前に投機的にツールを実行することでレイテンシを削減。長時間エージェントのコストと速度のトレードオフを変える可能性がある。

### D. セキュリティ専門エージェント　〔時期: 2026-03〜・萌芽〕
Codex Security（OpenAI、2026年3月）がリポジトリの脅威モデル構築→脆弱性検索→サンドボックス検証→修正提案を自動実行。現時点でLLMはパッチ適用済みコードと脆弱コードの区別に苦しむ（独立研究）ものの、CVE-2025-53773のようなCopilot自体への攻撃（プロンプトインジェクション経由のRCE、CVSS 9.6）が発見されており、AIコード生成とセキュリティの相互作用は急速に複雑化している。

### E. エージェント評価ベンチマークの精度向上　〔時期: 2026〜・萌芽〕
SWE-bench Pro（汚染耐性、1,865タスク・41リポジトリ）、ProdCodeBench（産業実データ・7言語、arXiv 2026年4月）、SWE-MERA（動的ベンチマーク）など評価手法自体が進化中。自社申告スコアのインフレに対抗する独立評価インフラの整備が進んでいる。

---

*本ドキュメントは公式changelog・公式リリースノート・ベンチマーク一次情報を優先し、自社申告ベンチと独立検証は本文中で明示的に区別した。X（旧Twitter）・Reddit・HackerNewsの情報は文脈確認の補助として参照した。*
