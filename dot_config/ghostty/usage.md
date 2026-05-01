# Ghostty + tmux + Claude Code 操作ガイド

構成: Ghostty (ターミナル) + tmux (多重化) + Claude Code + Neovim

起動時に tmux セッション `main` へ自動接続する。
tmux prefix = `Ctrl+a`

---

## Ghostty キーバインド

### tmux window 操作

| キー | 動作 |
|------|------|
| `Cmd+t` | 新規 tmux window |
| `Cmd+w` | 現在の tmux window を閉じる |
| `Ctrl+Tab` | 次の tmux window |
| `Ctrl+Shift+Tab` | 前の tmux window |
| `Cmd+1〜9` | tmux window 番号でジャンプ |

### tmux ペイン操作

| キー | 動作 |
|------|------|
| `Cmd+n` | ペインを横分割 |
| `Cmd+Shift+n` | ペインを縦分割 |
| `Cmd+Shift+h` | 左のペインへ移動 |
| `Cmd+Shift+j` | 下のペインへ移動 |
| `Cmd+Shift+k` | 上のペインへ移動 |
| `Cmd+Shift+l` | 右のペインへ移動 |
| `Cmd+↑` / `Cmd+k` | スクロールアップ |
| `Cmd+↓` / `Cmd+j` | スクロールダウン |
| `Cmd+i` | コピーモード開始 |

### セッション操作

| キー | 動作 |
|------|------|
| `Cmd+s` | Claude 状態付きセッション/window 一覧 (fzf) |

### Claude Code

| キー | 動作 |
|------|------|
| `Shift+Enter` | Claude Code へ改行を送る（入力欄内での改行） |

### macOS ネイティブタブ（Ghostty 本体のタブ）

`Cmd+t` は tmux に割り当て済みのため、ネイティブタブは `Shift` を加える。

| キー | 動作 |
|------|------|
| `Cmd+Shift+t` | 新規ネイティブタブ |
| `Cmd+Shift+w` | ネイティブタブを閉じる |
| `Cmd+Shift+[` | 前のネイティブタブ |
| `Cmd+Shift+]` | 次のネイティブタブ |

### その他

| キー | 動作 |
|------|------|
| `Cmd+r` | Ghostty 設定をリロード |
| `Ctrl+a` | tmux prefix を送信（二重 Ctrl+a で C-a をアプリに送る） |

---

## tmux キーバインド

prefix なしのキーバインドと、`Ctrl+a` の後に押すキーの一覧。

### prefix なし

| キー | 動作 |
|------|------|
| `Ctrl+Tab` | 次の window |
| `Ctrl+Shift+Tab` | 前の window |
| マウスホイール | スクロール |
| ステータスバーダブルクリック（空白部） | 新規 window |
| ステータスバーダブルクリック（window 名） | window を閉じる |
| ステータスバー右端クリック | tmux から detach |

### ウィンドウ操作（prefix + key）

| キー | 動作 |
|------|------|
| `c` | 新規 window |
| `x` | 現在の window を閉じる |
| `1〜9` | window 番号でジャンプ |
| `r` | tmux 設定をリロード |
| `m` | 直前のセッションに切替 |

### ペイン操作（prefix + key）

| キー | 動作 |
|------|------|
| `h` または `\|` | 横分割（カレントパス引き継ぎ） |
| `v` または `-` | 縦分割（カレントパス引き継ぎ） |
| `H` | 左のペインへ移動 |
| `J` または `j` | 下のペインへ移動 |
| `K` | 上のペインへ移動 |
| `L` または `l` | 右のペインへ移動 |
| `↑/↓/←/→` | 矢印キーでペイン移動 |

Ghostty の `Cmd+Shift+h/j/k/l` も同様にペイン移動できる。

### コピーモード（prefix + [ で開始）

| キー | 動作 |
|------|------|
| `[` | コピーモード開始 |
| `v` | 選択開始 |
| `y` | コピーしてモード終了 |
| `r` | 矩形選択トグル |

### プレフィックスのキャンセル

| キー | 動作 |
|------|------|
| `prefix + ESC` | プレフィックス入力をキャンセル |
| `prefix + Ctrl+c` | プレフィックス入力をキャンセル |

### セッション操作（prefix + key）

| キー | 動作 |
|------|------|
| `n` | セッション名を入力して現在のディレクトリで新規セッション作成 |
| `k` | セッションを fzf で選択して削除（`*` = 現在のセッション）。現在のセッション削除時は `main` へ移動、`main` 削除時は自動再作成 |
| `g` | ghq 管理リポジトリを fzf で選択してセッション切替/作成 |
| `s` | Claude 状態付きセッション/window 一覧 (fzf) |
| `m` | 直前のセッションに切替 |

### worktree 操作（prefix + key）

git リポジトリ内のペインで実行すると、そのリポジトリを対象に動作する。
worktree 内のペインから実行しても、常にメインリポジトリを自動検出する。
worktree は `<リポジトリ親>/<リポジトリ名>.worktrees/<ブランチ名>` に作成される。

| キー | 動作 |
|------|------|
| `o` | ブランチ名を入力して新規 worktree 作成 |
| `w` | ブランチ/worktree を fzf で選択（作成 or 切替） |
| `W` | ローカル+リモートブランチを fzf で選択して作成 or 切替 |
| `p` / `P` | PR 番号または URL を入力して worktree 作成 |
| `q` / `Q` | worktree を fzf で選択して削除（現在の worktree も対象）。削除後は `main` セッションへ移動 |

### その他（prefix + key）

| キー | 動作 |
|------|------|
| `u` | スクロールバック内の URL を fzf でリスト表示してブラウザで開く |
| `b` | 現在 window のブランチに紐づく PR をブラウザで開く（PR が無い場合はエラー通知） |
| `e` | カレントペインを VS Code で開く（worktree 内なら `.code-workspace` 経由で開き拡張機能が正しく動作する） |
| `Ctrl+g` | Neovim でプロンプトを編集して Claude Code に送信 |
| `?` | ドキュメントを fzf で選択して表示（Ghostty+tmux / worktree / Neovim） |

---

## worktree 操作の詳細

### o: 新規 worktree 作成

1. ブランチ名を入力
2. 現在のペインのディレクトリから git のメインリポジトリを自動検出
   - worktree 内から実行しても正しくメインリポジトリを参照する
3. ベースブランチを自動決定（`origin/HEAD` → `main` → `master` → `develop` の順）
4. worktree を作成（既存ブランチ・リモートブランチ・新規ブランチに対応）
5. ブランチ名で新規セッションを作成して切替（スラッシュはハイフンに変換）
   - Window `server`: サーバー用（フックで pane 分割・サーバー起動）
   - Window `nvim`: Neovim をワークツリールートで起動（フォーカスはこちら）
   - Window `cl`: ワークツリーディレクトリの汎用シェル
6. リポジトリ固有フック `~/.config/tm-wt/hooks/<リポジトリ名>/on-create.zsh` を実行
   - CFO-Alpha:
     - `.code-workspace` を生成して VSCode をバックグラウンドで起動
     - server window: 右ペインで npm run watch を起動
   - その他のリポジトリ: フックファイルがなければ server は 1 pane のまま
7. worktree 削除時はセッションと `.code-workspace` ファイルがともに削除される

### w: ブランチ/worktree 切替

fzf でローカルブランチ一覧を表示する。
`[wt]` プレフィックスが付いているブランチは worktree 作成済みで、対応セッションに切替できる。
`[wt]` なしのブランチを選択すると新規 worktree を作成する。

worktree セッションへ切り替える際は `on-attach` フックが実行される。
- CFO-Alpha: 切替先サーバーが停止していれば `npm run watch` を起動
- その他のリポジトリ: フックなし

`g`/`m`/`s` などで worktree でないセッション（`main` 等）へ移動した場合は、サーバーはそのまま動き続ける。

### p: PR から worktree 作成

1. PR 番号（例: `12345`）または URL を入力
2. `gh` コマンドで PR 情報（ブランチ名・タイトル）を自動取得
3. `o` と同じ手順で worktree を作成
4. セッション名はブランチ名ベース（`q`/`w` で選択・削除できる）
5. Window 1 の名前が `PR#12345` になりPR番号を識別できる

### q: worktree 削除

現在表示中の worktree も削除対象に含まれる。

1. fzf で削除する worktree を選択（現在の worktree も選択可）
2. `Y/n` で確認（Enter = yes）
3. ローカルブランチも削除するか確認（Enter = yes）
4. git worktree を削除してプルーン
5. ローカルブランチを削除（選択した場合）
6. 対応する tmux セッションを削除
7. 現在の worktree を削除した場合は `main` セッションへ自動移動

### g: リポジトリセッション切替

ghq 管理下のリポジトリを fzf で選択する。
対象リポジトリの tmux セッションが存在すれば切替、なければ新規セッションを作成する。
セッション名はリポジトリ名（例: `CFO-Alpha`）。

### s: Claude 状態付きセッション一覧

全セッション・window を fzf で表示して切替できる。
Claude Code の状態を以下のアイコンで確認できる（hooks との連携が必要）。

| アイコン | 意味 |
|----------|------|
| ⚡ | ツール実行中 |
| ✅ | 応答完了・入力待ち |
| ❓ | permission プロンプト待ち |

---

## 設定ファイル

### スクリプト

| ファイル | 内容 |
|----------|------|
| `~/.config/ghostty/config` | Ghostty 設定（キーバインド・外観・起動コマンド） |
| `~/.config/ghostty/usage.md` | このガイド |
| `~/.config/tmux/tmux.conf` | tmux 設定（prefix・ペイン・worktree バインド） |
| `~/.local/bin/tm-new-session` | 新規セッション作成スクリプト |
| `~/.local/bin/tm-kill-session` | セッション削除スクリプト（現在のセッションも対象） |
| `~/.local/bin/tm-wt` | worktree 作成/切替/削除スクリプト |
| `~/.local/bin/tm-pr` | PR から worktree 作成スクリプト |
| `~/.local/bin/tm-ghq` | ghq リポジトリセッション切替スクリプト |
| `~/.local/bin/tm` | Claude 状態付きセッション一覧スクリプト（ツリー表示・グループ区切り） |
| `~/.local/bin/tm-code` | `prefix + e` 用 VSCode 起動スクリプト（worktree: `.code-workspace` 経由、メインリポジトリ: フォルダ直接） |
| `~/.local/bin/tm-claude-icon` | tmux ステータスバー用 Claude 状態アイコン表示スクリプト（bash） |
| `~/.local/bin/tm-claude-notify` | Claude Code 完了・許可待ち通知スクリプト（tmux + BEL + terminal-notifier） |
| `~/.local/bin/tm-status-length` | tmux セッション切替時に `status-left-length` を動的更新するスクリプト |

### tm-wt 設定ディレクトリ（`~/.config/tm-wt/`）

| ファイル | 内容 | chezmoi 管理 |
|----------|------|:----------:|
| `README.md` | フックの作り方・修正方法のリファレンス | ✅ |
| `hooks/<リポジトリ名>/on-create.zsh` | worktree 新規作成フック | ✅ |
| `hooks/<リポジトリ名>/on-attach.zsh` | worktree 接続フック（新規/既存） | ✅ |
| `ports` | セッション名:ポート対応表（手動設定） | ✅ |
| `repos` | 登録済みリポジトリ一覧（tm-wt が自動追記） | — |
| `active-server` | 現在起動中のサーバーセッション名（実行時生成） | — |

---

## サーバー管理の仕組み

worktree の作成・接続時にリポジトリ固有のフックスクリプトを実行する。
フックファイルが存在しないリポジトリではサーバー起動などの処理は行われない。

| フック | 実行タイミング |
|--------|--------------|
| `~/.config/tm-wt/hooks/<リポジトリ名>/on-create.zsh` | worktree 新規作成時（初回のみ） |
| `~/.config/tm-wt/hooks/<リポジトリ名>/on-attach.zsh` | worktree セッションに入る時（新規/既存問わず） |

**新しいリポジトリへのフック追加・既存フックの修正方法は `~/.config/tm-wt/README.md` を参照。**

### CFO-Alpha の動作

| タイミング | 動作 |
|------------|------|
| worktree 新規作成 | 右ペイン作成 → `npm i`（初回のみ） → `npm run watch` 起動 |
| worktree 切替 | 右ペインがなければ作成 → サーバー停止中なら `npm run watch` 起動 |
| worktree 以外のセッションへ移動 | サーバーはそのまま動き続ける |
| worktree 削除 | 削除対象がアクティブなら `active-server` ファイルを削除 |

---

## 将来の計画: マルチ worktree 並列開発環境

現状はバックエンドが EC2 上で動いているため、フロントサーバーを同時に1つしか起動できない。
以下の対応により、複数 worktree を並列で動作確認できる環境を構築予定。

### 参考資料

- PR: https://github.com/C-FO/CFO-Alpha/pull/141140
- 設計記事: https://confluence.atlassian.freee.co.jp/wiki/spaces/ENG/blog/2026/02/17/4184672375/AI+TUI

### 目標

- バックエンドをローカルで起動し、worktree ごとに異なるポートで動作させる
- フロントエンドも worktree ごとに異なるポートで起動する
- 複数 worktree を同時に起動して並列で動作確認できるようにする

### 対応内容（予定）

1. バックエンドのローカル化
   - EC2 接続から Rails サーバーをローカル起動に移行
   - worktree ごとに異なるポートで `rails server` を起動

2. ポート管理の復活
   - `tm-wt` スクリプトのポート割り当てロジック（`_get_port`/`_free_port`）を再導入
   - バックエンドとフロントエンドをペアで管理

3. `tm-wt` の変更
   - `_create_worktree`: フロントとバックエンド両方を起動
   - `_switch_session`: サーバー停止・起動ロジックを削除（並列起動するため不要に）
   - `_mode_delete`: ポートの解放処理を復活

---

## トラブルシューティング

### worktree 作成時に `rimraf: command not found` が発生する

**症状**

worktree 作成直後の `npm ci` 実行時に以下のエラーが出る。

```
sh: rimraf: command not found
npm error Lifecycle script `clean` failed with error: code 127
npm error command sh -c npm run build:generator && ...
```

**原因**

ルートの `package.json` の `postinstall` スクリプトが `packages/generator` のビルドを実行する。
`packages/generator` の `clean` スクリプトは `rimraf dist` を使うが、
`packages/generator/package.json` の依存関係に `rimraf` が定義されていないため、
worktree の `npm ci` でインストールされずエラーになる。

メインリポジトリでは他パッケージの依存としてルートの `node_modules/.bin/rimraf` に
ホイストされているため発生しない。

**回避策（現在の対応）**

`tm-wt` では `npm i` を使用している。`postinstall` で rimraf エラーが発生した場合は
`npm i --ignore-scripts` に変更することで回避できる。

**根本修正（コードへの変更が必要）**

`packages/generator/package.json` の `devDependencies` に `rimraf` を追加する。

```json
{
  "devDependencies": {
    "rimraf": "^5.0.0"
  }
}
```

これにより worktree の `npm ci` でも `rimraf` がインストールされ、
`--ignore-scripts` なしで `npm ci` を実行できるようになる。

### mise の警告が表示される

**症状**

```
mise WARN  tracking config: failed to ln -sf .../.tool-versions .../tracked-configs/f263ad91197e3db4: File exists (os error 17)
```

**原因**

同じリポジトリの worktree は同じ `.tool-versions` ファイルを参照するため、
mise が同一ハッシュのシンボリックリンクを再作成しようとして競合する。

**対応**

動作上の問題はない。mise はツールバージョンを正常に適用して処理を続行している。

### Ghostty 設定リロード時に "unknown field" エラーが表示される

**症状**

```
window-columns: unknown field
window-rows: unknown field
```

**原因**

`window-columns` / `window-rows` は Ghostty の有効な設定フィールドではない。
`window-save-state = always` が設定済みであれば、ウィンドウサイズは前回の状態を自動復元するため、
列数・行数の明示的な指定は不要かつサポートされていない。

**修正内容**

`config.ghostty` から以下の行を削除した。

```
window-columns = 220   # 削除
window-rows = 50       # 削除
```

ウィンドウサイズを変更したい場合は、Ghostty 上でウィンドウを手動でリサイズする。
`window-save-state = always` により次回起動時にそのサイズが復元される。

---

## 変更履歴

### 2026-04-23

#### 修正

| 対象ファイル | 変更内容 |
|-------------|----------|
| `~/.config/ghostty/config.ghostty` | 無効フィールド `window-columns` / `window-rows` を削除。`font-size = 13` を明示追加。 |
| `~/.config/tmux/tmux.conf` | コピーモードを `prefix + [` に変更（tmux デフォルト準拠）。`prefix + ESC` / `prefix + Ctrl+c` でプレフィックスキャンセルを追加。`status-interval 2` でステータスバーを 2 秒ごとに更新。`window-status-format` に `bash ~/.local/bin/tm-claude-icon` を組み込み Claude 状態アイコンを表示。`pane-exited` フックで pane 終了時に `/tmp/claude-status/<pane_id>` を自動削除。 |
| `~/.local/bin/tm` | `_claude_icon` 関数: 変数名 `status` → `pane_status` に変更（zsh 読み取り専用変数エラー修正）。pane フォアグラウンドがシェル（zsh/bash/sh 等）の場合はスキップしてゴーストステータスを防ぐ対応を追加。 |
| `~/.local/bin/tm-claude-icon` | 新規作成。tmux `window-status-format` から `bash` 経由で呼び出される軽量 Claude 状態アイコンスクリプト。現存 pane のみ参照し、シェルがフォアグラウンドの場合はスキップする。 |
| `~/.local/bin/tm-wt` | (1) `_switch_session`: ACTIVE_SERVER_FILE の整合性チェックを追加（記録セッションの pane 1.2 が実際に node/npm を動かしていなければファイルをリセット）。実際の pane コマンドでサーバー起動状態を判定するよう変更（ファイルだけに依存しない）。(2) `_create_worktree`: developブランチのworktree作成時に `fetch origin develop` + `branch -f` で最新化。(3) MAIN_REPO検出失敗時（git外）に `~/.config/tm-wt/repos` からfzf選択。(4) `_mode_new` / `_mode_delete` の `read` 入力中に Ctrl+C でキャンセルできるよう SIGINT ハンドリングを追加。 |

#### Claude Code ステータスの仕組み

```
Claude Code hook     →  /tmp/claude-status/<pane_id>  に状態を書き込む
  PreToolUse         →  "running"
  Notification       →  "permission"
  Stop               →  "waiting"

pane 終了時          →  tmux pane-exited hook が /tmp/claude-status/<pane_id> を自動削除

tmux status bar      →  2秒ごとに bash tm-claude-icon <session> <window> を実行
  pane のフォアグラウンドがシェル → スキップ（Claude 終了済みとみなす）
  status = running   →  ⚡
  status = permission→  ❓
  status = waiting   →  ✅
  (なし)             →  表示なし
```

#### ステータスの齟齬が起きる原因と対処

| 原因 | 対処 |
|------|------|
| pane が死んでもファイルが残る（ゴースト） | `pane-exited` フックで自動削除 |
| Claude Code がクラッシュ（Stop hook 未実行） | pane コマンドがシェルになったらアイコンを非表示にする |
| ACTIVE_SERVER_FILE が古い（サーバー停止済み） | `_switch_session` 実行時に pane コマンドで実態チェックし自動リセット |

#### macOS 通知

Claude Code の hook で `osascript` を使い、作業完了・許可待ちのタイミングで macOS 通知を送る。
インストール不要（macOS 標準コマンド）。

| hook | タイミング | 通知内容 | 通知音 |
|------|-----------|---------|-------|
| Stop | 作業完了 | Claude Code ✅「作業が完了しました」 | Glass |
| Notification | 許可・質問 | Claude Code ❓「許可または回答が必要です」 | Ping |

設定箇所: `~/.claude/settings.json` の `hooks.Stop` / `hooks.Notification`

---

### 2026-04-23 (2)

#### 修正

| 対象ファイル | 変更内容 |
|-------------|----------|
| `~/.local/bin/tm-wt` | `--server-switch SESSION` モードを追加。MAIN_REPO 不要で repos ファイルからworktreeを検索してサーバー管理を実行する。git リポジトリ外からも動作。非worktreeセッション（main 等）は自動スキップ。 |
| `~/.local/bin/tm` | セッション切替後に `zsh ~/.local/bin/tm-wt --server-switch "$session" &` をバックグラウンド実行するよう追加。`prefix + s` 経由の切替でもサーバー管理が動くようになった。 |

#### フロントサーバー管理が動作するキー一覧

| キー | スクリプト | サーバー管理 |
|------|-----------|------------|
| `prefix + w` | `tm-wt --switch` | `_switch_session` 経由 ✅ |
| `prefix + W` | `tm-wt` (select) | `_switch_session` 経由 ✅ |
| `prefix + o` | `tm-wt --new` | `_create_worktree` 経由 ✅ |
| `prefix + p` / `P` | `tm-pr` | `_create_worktree` 経由 ✅ |
| `prefix + s` | `tm` (セッション一覧) | `--server-switch` 経由 ✅ |
| `prefix + m` | tmux `switch-client -l` | なし（直前セッションへ） |
| `prefix + g` | `tm-ghq` | なし |

---

### 2026-04-23 (3)

#### 追加

| 対象ファイル | 変更内容 |
|-------------|----------|
| `~/.config/ghostty/config` | `link-url = true` を明示追加。Ghostty が URL テキストを自動検出し Cmd+クリックで開く設定を有効化。 |
| `~/.config/tmux/tmux.conf` | `prefix + u` にスクロールバック URL リスト表示を追加（`tm-url` 呼び出し）。`prefix + b` の PR オープンコマンドのエラー時フィードバックを追加（`display-message -d 3000` で通知）。 |
| `~/.local/bin/tm-url` | 新規作成。現在 window の全ペインのスクロールバックから URL を収集し fzf で一覧表示してブラウザで開くスクリプト。OSC 8 ハイパーリンク（エスケープシーケンス埋め込み）とプレーンテキスト URL の両方に対応。 |

#### URL 収集の仕組み

```
prefix + u
  → display-popup で tm-url を起動
  → tmux list-panes で現在 window の全ペインを列挙
  → 各ペインに対して capture-pane -e（エスケープシーケンス込み）で取得
      ├─ perl で OSC 8 シーケンス (\e]8;params;URL\e\\) からURL抽出
      └─ grep で プレーンテキスト URL 抽出
  → 重複除去して fzf でリスト表示
  → 選択した URL を open コマンドでブラウザで開く
```

#### Ghostty + tmux でリンクを開けない原因（調査メモ）

tmux 内で Cmd+クリックによる URL オープンが動作しない問題を調査した。

- tmux は `hyperlinks` feature を認識済み（`client_termfeatures` で確認）
- `allow-passthrough on` も設定済み
- Ghostty 側の `link-url = true` も設定済み

ただし tmux のマウスモード（`set -g mouse on`）が有効なためクリックイベントは tmux が処理し、Ghostty の URL オープン機能が動作しない。現状は `prefix + u` による URL リスト方式で対応している。

#### `display-popup` でのフォーマット変数展開の制約

`display-popup` のコマンド文字列・`-e` オプション内では `#{pane_id}` 等の tmux フォーマット変数が展開されない（`run-shell` とは異なる挙動）。ペインIDをスクリプトに渡す場合はこの制約を回避する必要がある。

`tm-url` では引数でペインIDを渡すのをやめ、スクリプト内で `tmux list-panes` を使って現在 window のペインを自律的に取得することで回避している。

---

#### `--server-switch` の仕組み

```
prefix + s → tm スクリプト → fzf でセッション/window 選択
  → tmux switch-client       （セッション移動）
  → tm-wt --server-switch SESSION （バックグラウンド実行）
      repos ファイルで SESSION に対応する worktree ディレクトリを検索
      ├─ worktree でない → 何もしない（main, EC2 等）
      └─ worktree である
          ├─ ACTIVE_SERVER_FILE の整合性チェック（古ければリセット）
          ├─ 旧 worktree のサーバーを停止（別セッションが動いていれば）
          └─ 移動先 pane 1.2 のコマンドを確認
              ├─ node/npm → ファイルだけ同期
              └─ zsh 等  → npm run watch を起動

---

### 2026-04-24

#### worktree フック機構の導入・マルチリポジトリ対応

##### 背景

CFO-Alpha (develop ブランチ) 専用だったサーバー起動ロジックを汎用フック機構に切り出した。
他リポジトリ (main/master ブランチ) でも worktree 操作が正しく動作するように対応。

##### フックファイル

`~/.config/tm-wt/hooks/<リポジトリ名>/` 配下に置くことで、worktree 作成/接続時に自動実行される。

| フックファイル | 実行タイミング | 引数 |
|--------------|--------------|------|
| `on-create.zsh` | `git worktree add` 後・セッション作成直後 | `$1=session_name  $2=wtdir` |
| `on-attach.zsh` | worktree セッションに入る時（新規/既存問わず） | `$1=session_name  $2=wtdir` |

フックファイルが存在しないリポジトリは何も実行しない（サーバー起動なし）。

##### CFO-Alpha のフック (`~/.config/tm-wt/hooks/CFO-Alpha/`)

```
on-create.zsh
  front/ が存在する場合のみ実行
  └─ .code-workspace を生成して VSCode をマルチルートワークスペースで開く
      (メインリポジトリ + worktree の 2 フォルダ構成)
  └─ pane 1.2 を右分割で作成
  └─ node_modules がなければ npm i → npm run watch
  └─ node_modules があれば npm run watch のみ
  └─ active-server ファイルを更新

on-attach.zsh
  front/ が存在する場合のみ実行
  └─ pane 1.2 が存在しなければ作成
  └─ pane 1.2 が node/npm 起動中 → active-server ファイルだけ同期
  └─ 停止中 → npm run watch (node_modules なければ npm i も実行)
  └─ active-server ファイルを更新
```

将来バックエンドサーバーを追加する場合は `on-create.zsh` に pane 1.3 の作成と
`bundle exec rails server` 等を追記する。

##### デフォルトブランチの自動検出

`tm-wt` で新規 worktree を `origin/<default>` ベースで作成する際のブランチを動的に解決する。

```
git symbolic-ref refs/remotes/origin/HEAD → origin/HEAD が設定済みならそのブランチ名
フォールバック: origin/main → origin/master → origin/develop の順で存在確認
最終フォールバック: "main"
```

##### セッション削除・worktree 削除の改善 (`prefix + k` / `prefix + q`)

**prefix + k (セッション削除)**

- 現在のセッションも一覧に表示（`*` 付き）
- 現在のセッションを削除した場合 → `main` セッションに自動切り替え
- `main` セッションを削除した場合 → 削除後に `main` セッションを自動再作成
- `main` セッションが存在しない場合は `$HOME` で新規作成

**prefix + q (worktree 削除)**

- 現在表示中の worktree も削除対象に含まれるようになった
- 削除前にローカルブランチ削除の確認を行う（セッション削除前に全対話完了）
- 現在の worktree を削除した場合 → `main` セッションに自動切り替え（`tmux run-shell -d 1` で遅延実行）

---

### 2026-04-24 (2)

#### worktree で VSCode 拡張機能が動作しない問題の修正

##### 背景と原因

worktree のディレクトリを VSCode でフォルダとして直接開くと、以下の拡張機能が正しく動作しなかった。

- TypeScript/React の定義ジャンプ（tsserver がプロジェクトルートを誤認）
- GitHub Pull Requests and Issues（worktree の `.git` がディレクトリではなく `gitdir: ...` を指すファイルのため、拡張機能がリポジトリを認識できない）

根本原因は VSCode の GitHub Pull Requests 拡張機能が worktree の `.git` ファイル構造（`gitdir: <main>/.git/worktrees/<name>`）を正しく解釈できないこと。
**解決策**: メインリポジトリと worktree の両フォルダを含む `.code-workspace` ファイル経由で VSCode を開くことで、拡張機能がメインリポジトリを通じてリポジトリ情報を取得できるようになる。

##### .code-workspace の配置場所

```
<リポジトリ親>/<リポジトリ名>.worktrees/<ブランチ名>.code-workspace
```

例: `~/src/github.com/C-FO/CFO-Alpha.worktrees/torikawa-NDE-2032.code-workspace`

ファイルの中身:

```json
{
  "folders": [
    { "path": "/path/to/CFO-Alpha.worktrees/torikawa-NDE-2032" }
  ],
  "settings": {
    "git.scanRepositories": ["/path/to/CFO-Alpha"]
  }
}
```

`folders` にはworktreeのみを指定する（ファイルエクスプローラーに余分なフォルダを表示しないため）。
`git.scanRepositories` でメインリポジトリを git として登録することで、GitHub PR 拡張機能などが正常に動作する。

##### 変更ファイル

| 対象ファイル | 変更内容 |
|-------------|----------|
| `~/.config/tm-wt/hooks/CFO-Alpha/on-create.zsh` | worktree 新規作成時に `.code-workspace` を生成して VSCode をマルチルートワークスペースで開く処理を追加。`git worktree list --porcelain` でメインリポジトリのパスを自動取得。 |
| `~/.local/bin/tm-wt` (`_mode_delete`) | worktree 削除時に対応する `.code-workspace` ファイルも合わせて削除するよう追加。 |
| `~/.local/bin/tm-code` | 新規作成。`prefix + e` から呼ばれる VSCode 起動スクリプト。worktree 内では `.code-workspace` を生成して開き、メインリポジトリ内では従来通りフォルダとして開く。 |
| `~/.config/tmux/tmux.conf` (`bind e`) | `code .` を直接実行する実装から `zsh ~/.local/bin/tm-code` 呼び出しに変更。 |

##### ライフサイクル

```
prefix + o / p (worktree 作成)
  → on-create.zsh
      └─ .code-workspace を生成
      └─ VSCode をマルチルートワークスペースで自動オープン

prefix + e (VSCode を開く)
  → tm-code <pane_current_path>
      ├─ worktree 内 → .code-workspace を生成して open
      └─ メインリポジトリ内 → フォルダとして open

prefix + q (worktree 削除)
  → _mode_delete
      └─ git worktree remove
      └─ .code-workspace ファイルを削除
```

---

### 2026-05-01

#### worktree 作成時のウィンドウ構成を統一（server / nvim / cl）

##### 変更内容

すべてのリポジトリで worktree 作成時に以下の 3 ウィンドウを自動作成するようにした。

| ウィンドウ名 | 内容 |
|------------|------|
| `server` | サーバー用（on-create フックで pane 分割・サーバー起動） |
| `nvim` | Neovim をワークツリールートで起動（フォーカスはこちら） |
| `cl` | ワークツリーディレクトリの汎用シェル |

従来 `misc` だったウィンドウを廃止。`nvim` / `cl` の作成を `tm-wt` 本体に移し、`on-create.zsh` フックは `server` ウィンドウの pane 構成のみ担当する設計に変更した。

##### 対象ファイル

| ファイル | 変更内容 |
|---------|---------|
| `~/.local/bin/tm-wt` | `_create_worktree` / `_switch_session`: window 1 を `server` にリネーム、`nvim`・`cl` window を自動作成するよう変更。`misc` window の追加を廃止。 |
| `~/.config/tm-wt/hooks/CFO-Alpha/on-create.zsh` | nvim window の作成・フォーカス移動を削除（tm-wt 本体に移管）。server window の pane 分割・サーバー起動のみ担当。 |
| `~/.config/tm-wt/README.md` | 新規ウィンドウ構成・他リポジトリ向けフックテンプレート（Rails / Go / npm）を追記。 |

---

#### Claude Code 通知システムの刷新

##### 変更前の問題

- `osascript` による macOS 通知が Ghostty + tmux 環境で届かない
  - tmux 経由のプロセスからの通知は macOS が「Script Editor」として扱い、通知許可がないと届かない
- `preferredNotifChannel: "iterm2_with_bell"` が Ghostty に非対応

##### 変更後の通知フロー

Claude Code の Notification（許可待ち）/ Stop（作業完了）hook が `~/.local/bin/tm-claude-notify` を呼び出す。

```
tm-claude-notify waiting|permission
  1. tmux display-message   → tmux ステータスバーに 6 秒表示（常に確実）
  2. pane tty への BEL      → Ghostty がベル処理（printf '\007' > pane_tty）
  3. terminal-notifier      → macOS 通知センターに確実に届く
     -sender com.apple.Terminal を指定 → Terminal.app の通知として扱われ追加許可不要
     -group claude-code を指定 → 通知が積み上がらず上書き
  (fallback) osascript      → terminal-notifier 未インストール時
```

##### セットアップ

```sh
brew install terminal-notifier
chmod +x ~/.local/bin/tm-claude-notify
```

##### 対象ファイル

| ファイル | 変更内容 |
|---------|---------|
| `~/.local/bin/tm-claude-notify` | 新規作成。tmux 通知 + BEL + terminal-notifier の 3 段階通知スクリプト。 |
| `~/.claude/settings.json` | Notification / Stop hook の通知コマンドを `tm-claude-notify` 呼び出しに変更。`preferredNotifChannel` を `iterm2_with_bell` → `terminal_bell` に変更。 |

---

#### prefix + s セッション一覧の改善

##### 変更内容

`~/.local/bin/tm` スクリプトを全面改修。

**表示形式（ツリー表示・列揃え・グループ区切り）**

```
main                        1:server   ⚡
                            2:nvim
                            3:cl
────────────────────────────────────────
feature-implement-NDE-1234  1:server   ✅
                            2:nvim
                            3:cl
────────────────────────────────────────
torikawa-NDE-1200           1:server
                            2:nvim
```

- セッション名は最初のウィンドウにのみ表示、以降はスペースでインデント
- 全セッションで `max_len` を計算し `win_idx:win_name` の開始列を統一
- セッショングループ間に dim スタイルの水平線セパレータを挿入
- ヘッダーから「Ctrl-C: cancel」を削除

**フィールド区切り文字の変更（バグ修正）**

以前の `:` 区切り + awk 方式では、display 内に `:` が含まれる場合に位置計算がずれるバグがあった。
TAB (`$'\t'`) 区切りに変更し awk を排除した。

```
変更前: "session:win_idx:display"  →  awk で substr 位置計算
変更後: "session\twin_idx\tdisplay"  →  fzf --delimiter=$'\t' --with-nth=3
```

| 項目 | 変更内容 |
|------|---------|
| セパレータ行の選択 | session / win_idx が空の行を選択した場合は何もせず終了 |
| `--header` | 「Ctrl-C: cancel」を削除 |

##### 対象ファイル

| ファイル | 変更内容 |
|---------|---------|
| `~/.local/bin/tm` | ツリー表示・TAB 区切り・グループ区切り線・dynamic max_len を実装。 |

---

#### tmux ステータスバーの session 名動的幅

##### 変更前の問題

`status-left-length` のデフォルトは 10 文字。`torikawa-NDE-1200`（17 文字）など長いセッション名が切れていた。

##### 変更内容

セッション切替・作成・リネーム時に `~/.local/bin/tm-status-length` を実行し、
`status-left-length = セッション名の長さ + 3`（status-left の `' #S  '` フォーマット分）に動的更新する。

設定リロード（`prefix + r`）時に孤立した Claude ステータスファイル（死んだ pane の残留ファイル）を一括削除するフックも追加した。

##### 対象ファイル

| ファイル | 変更内容 |
|---------|---------|
| `~/.local/bin/tm-status-length` | 新規作成。現在のセッション名の長さから `status-left-length` を計算して設定。 |
| `~/.config/tmux/tmux.conf` | `client-session-changed` / `session-created` / `session-renamed` フックで `tm-status-length` を呼び出し。`after-source-file` フックで孤立ステータスファイルを一括削除。`prefix + s` の `display-popup` に `-S "fg=colour252,bg=colour232"` を追加してポップアップ背景を固定色に（Ghostty の透過による背景コンテンツのにじみ防止）。 |

---

#### Claude Code ステータスアイコンの仕組み（補足）

##### 複数 pane に Claude Code が起動している場合の動作

1 つのウィンドウに複数の pane で Claude Code が動作している場合、
`_claude_icon` は全 pane を走査して最も優先度の高いステータスを 1 つ返す。

```
優先度: running (⚡) > permission (❓) > waiting (✅) > (なし)
```

例: pane 1 が ❓（permission）、pane 2 が ⚡（running）→ ウィンドウには ⚡ を表示

##### Ghostty 透過による表示乱れ

Ghostty の `background-opacity = 0.9` 設定により、`display-popup` が半透明になる。
ポップアップ背後のペインのテキストが 10% 透けて表示されることがある。
`display-popup -S "bg=colour232"` でポップアップ背景を固定色にすることで解消。

##### ステータスファイルの孤立（ゴースト）

| 状況 | 対処 |
|------|------|
| pane が終了してもファイルが残る | `pane-exited` フックが自動削除 |
| tmux クラッシュ等でフック未実行のファイルが残る | `prefix + r`（設定リロード）時に `after-source-file` フックが一括削除 |
