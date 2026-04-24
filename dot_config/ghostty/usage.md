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
| `k` | セッションを fzf で選択して削除（現在のセッションは除外） |
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
| `q` / `Q` | worktree を fzf で選択して削除（display-popup） |

### その他（prefix + key）

| キー | 動作 |
|------|------|
| `u` | スクロールバック内の URL を fzf でリスト表示してブラウザで開く |
| `b` | 現在 window のブランチに紐づく PR をブラウザで開く（PR が無い場合はエラー通知） |
| `e` | カレントリポジトリを VS Code で開く |
| `Ctrl+g` | Neovim でプロンプトを編集して Claude Code に送信 |

---

## worktree 操作の詳細

### o: 新規 worktree 作成

1. ブランチ名を入力
2. 現在のペインのディレクトリから git のメインリポジトリを自動検出
   - worktree 内から実行しても正しくメインリポジトリを参照する
3. 現在起動中のフロントサーバーを停止する
4. worktree を作成（既存ブランチ・リモートブランチ・新規ブランチに対応）
5. ブランチ名で新規セッションを作成して切替（スラッシュはハイフンに変換）
   - Window 1: 左右等分割
     - 左ペイン: 汎用ターミナル（worktree ルート）
     - 右ペイン: `npm i` → 完了後に `npm run watch` 自動起動
   - Window 2 `misc`: その他操作用
6. worktree 削除時はセッションごと削除される

### w: ブランチ/worktree 切替

fzf でローカルブランチ一覧を表示する。
`[wt]` プレフィックスが付いているブランチは worktree 作成済みで、対応セッションに切替できる。
`[wt]` なしのブランチを選択すると新規 worktree を作成する。

worktree 間の切替時は現在のフロントサーバーを停止し、切替先のサーバーを起動する。
切替先の `node_modules` が存在しない場合は `npm i` を先に実行してから `npm run watch` を起動する。

`g`/`m`/`s` などで worktree でないセッション（`main` 等）へ移動した場合は、サーバーはそのまま動き続ける。

### p: PR から worktree 作成

1. PR 番号（例: `12345`）または URL を入力
2. `gh` コマンドで PR 情報（ブランチ名・タイトル）を自動取得
3. `o` と同じ手順で worktree を作成
4. セッション名はブランチ名ベース（`q`/`w` で選択・削除できる）
5. Window 1 の名前が `PR#12345` になりPR番号を識別できる

### q: worktree 削除

1. fzf で削除する worktree を選択（display-popup で矢印キー操作可）
2. `Y/n` で確認（Enter = yes）
3. 対応する tmux セッションをまるごと削除
4. git worktree を削除してプルーン
5. ローカルブランチも削除するか確認（Enter = yes）

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

| ファイル | 内容 |
|----------|------|
| `~/.config/ghostty/config` | Ghostty 設定（キーバインド・外観・起動コマンド） |
| `~/.config/ghostty/usage.md` | このガイド |
| `~/.config/tmux/tmux.conf` | tmux 設定（prefix・ペイン・worktree バインド） |
| `~/.local/bin/tm-new-session` | 新規セッション作成スクリプト |
| `~/.local/bin/tm-kill-session` | セッション削除スクリプト |
| `~/.local/bin/tm-wt` | worktree 作成/切替/削除スクリプト |
| `~/.local/bin/tm-pr` | PR から worktree 作成スクリプト |
| `~/.local/bin/tm-ghq` | ghq リポジトリセッション切替スクリプト |
| `~/.local/bin/tm` | Claude 状態付きセッション一覧スクリプト |
| `~/.config/tm-wt/active-server` | 現在起動中のフロントサーバーセッション名 |

---

## フロントサーバー管理の仕組み

バックエンドのポートが1つ（3000番）のため、フロントサーバーは同時に1つだけ起動する。
`~/.config/tm-wt/active-server` に現在起動中のセッション名を記録して管理する。

| タイミング | 動作 |
|------------|------|
| worktree 新規作成 | 既存サーバーを停止 → `npm i` → `npm run watch` 自動起動 |
| worktree 間の切替（`w`/`W`/`p`） | 既存サーバーを停止 → 切替先で `npm run watch` 起動（`node_modules` がなければ先に `npm i`） |
| worktree 以外のセッションへ移動（`g`/`m`/`s` 等） | サーバーはそのまま動き続ける |
| worktree 削除（`q`） | 削除対象がアクティブなら `active-server` ファイルを削除 |

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
```
