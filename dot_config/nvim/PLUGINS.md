# Neovim プラグイン一覧・説明・設定・操作ガイド

設定ファイルは `~/.config/nvim/lua/plugins/` 配下に分類して管理している。

---

## プラグインマネージャー

### lazy.nvim

- 設定: `lua/config/lazy.lua`
- 役割: プラグインの遅延読み込み・自動インストール・更新管理

| コマンド | 動作 |
|---------|------|
| `:Lazy` | プラグイン管理 UI を開く |
| `:Lazy update` | 全プラグインを更新 |
| `:Lazy sync` | インストール・更新・クリーンを一括実行 |
| `:Lazy clean` | 未使用プラグインを削除 |

---

## テーマ

### Mofiqul/dracula.nvim（`plugins/colorscheme.lua`）

Ghostty の Dracula テーマと色調を統一している。
`transparent_bg = true` で Ghostty の背景透明度（`background-opacity = 0.9`）を活かす。

---

## シンタックスハイライト

### nvim-treesitter（`plugins/treesitter.lua`）

コードを構文木として解析し、精度の高いハイライトとインデントを提供する。
以下の言語を自動インストール:

- Lua, Vim, VimDoc
- Ruby
- JavaScript, TypeScript, TSX
- JSON, YAML, TOML
- HTML, CSS
- Markdown, Bash

| コマンド | 動作 |
|---------|------|
| `:TSUpdate` | 全パーサーを更新 |
| `:TSInstall {lang}` | 特定言語のパーサーをインストール |

---

## 多機能統合プラグイン

### folke/snacks.nvim（`plugins/snacks.lua`）

lazygit・ターミナル・通知・インデントガイド・ダッシュボードを統合した高機能プラグイン。

#### lazygit

ターミナル TUI の Git クライアント。フロートウィンドウで起動する。

| キー | 動作 |
|------|------|
| `<Leader>gg` | lazygit を開く |
| `<Leader>gl` | lazygit でリポジトリ全体のログを開く |
| `<Leader>gL` | lazygit で現在ファイルのログを開く |

lazygit 内での主要操作:

| キー | 動作 |
|------|------|
| `q` / `Esc` | lazygit を閉じる |
| `1`〜`5` | パネル切替（Status / Files / Branches / Commits / Stash） |
| `Space` | ファイルをステージ/アンステージ |
| `c` | コミット |
| `P` | Push |
| `p` | Pull |
| `b` | ブランチ操作 |
| `?` | ヘルプ |

#### フロートターミナル

| キー | 動作 |
|------|------|
| `<Leader>t` | ターミナルをトグル（フロートウィンドウ） |
| `Ctrl+\` → `Ctrl+n` | ターミナルからノーマルモードへ |

#### その他の機能

- notifier: LSP 通知・エラーを右下にポップアップ表示
- indent: インデントガイドを `│` で表示
- dashboard: 起動画面（最近のファイル・ショートカット一覧）
- words: カーソル下の単語をハイライト
- bigfile: 大ファイルを開いた時に重いプラグインを自動無効化

---

## ファジーファインダー

### nvim-telescope/telescope.nvim（`plugins/telescope.lua`）

VSCode の `Cmd+P`（ファイル検索）・`Cmd+Shift+F`（全文検索）相当の機能を提供する。

| キー | 動作 |
|------|------|
| `<Leader>ff` | ファイル検索（プロジェクト内） |
| `<Leader>fg` | 全文検索（live grep） |
| `<Leader>fb` | 開いているバッファ一覧 |
| `<Leader>fr` | 最近開いたファイル |
| `<Leader>fh` | Neovim ヘルプ検索 |
| `<Leader>/`  | 現在ファイル内の文字検索 |
| `<Leader>fs` | LSP シンボル検索 |
| `<Leader>fd` | 診断（エラー・警告）一覧 |

Telescope 内の操作:

| キー | 動作 |
|------|------|
| `Ctrl+j/k` | リストを移動 |
| `Enter` | 選択 |
| `Ctrl+x` | 水平分割で開く |
| `Ctrl+v` | 垂直分割で開く |
| `Ctrl+t` | 新しいタブで開く |
| `Esc` | 閉じる |

---

## LSP（言語サーバー）

### mason.nvim + mason-lspconfig.nvim + nvim-lspconfig（`plugins/lsp.lua`）

VSCode の IntelliSense 相当の補完・診断・定義ジャンプを提供する。

以下の言語サーバーを自動インストール:

| 言語サーバー | 対象 |
|------------|------|
| `lua_ls` | Lua（Neovim 設定用） |
| `ruby_lsp` | Ruby / Ruby on Rails |
| `ts_ls` | TypeScript / JavaScript / TSX |

| コマンド | 動作 |
|---------|------|
| `:Mason` | インストール済みサーバー管理 UI |
| `:MasonUpdate` | サーバー定義を更新 |
| `:LspInfo` | 現在のファイルに対応した LSP の状態確認 |
| `:LspRestart` | LSP サーバーを再起動 |

#### LSP キーバインド（ファイルを開いた時のみ有効）

| キー | 動作 |
|------|------|
| `gd` | 定義へジャンプ |
| `gD` | 宣言へジャンプ |
| `gr` | 参照一覧（Telescope） |
| `gi` | 実装へジャンプ |
| `K` | ホバー情報を表示 |
| `<Leader>ca` | コードアクション |
| `<Leader>rn` | シンボルのリネーム |
| `<Leader>cf` | フォーマット |
| `<Leader>dl` | 診断の詳細をポップアップ表示 |
| `[d` | 前の診断へ移動 |
| `]d` | 次の診断へ移動 |

---

## 自動補完

### hrsh7th/nvim-cmp（`plugins/cmp.lua`）

LSP・スニペット・バッファ・パスから補完候補を提供する。

| キー | 動作 |
|------|------|
| `Ctrl+j/k` | 補完候補を上下移動 |
| `Tab` | 候補を選択 / スニペットの次のフィールドへ |
| `Shift+Tab` | 候補を逆方向移動 / スニペットの前フィールドへ |
| `Enter` | 候補を確定 |
| `Ctrl+Space` | 補完を強制表示 |
| `Ctrl+e` | 補完を閉じる |
| `Ctrl+d/u` | ドキュメントをスクロール |

スニペットは LuaSnip + friendly-snippets（VSCode 互換スニペット集）を使用。

---

## UI

### nvim-lualine/lualine.nvim（`plugins/ui.lua`）

下部ステータスラインに以下を表示:
- 編集モード / ブランチ名 / Git 差分 / 診断数
- ファイル名（相対パス）/ エンコーディング / ファイルタイプ / 行・列位置

### akinsho/bufferline.nvim（`plugins/ui.lua`）

開いているバッファをタブとして上部に表示する。

| キー | 動作 |
|------|------|
| `Shift+h` | 前のバッファへ |
| `Shift+l` | 次のバッファへ |
| `<Leader>bd` | 現在のバッファを閉じる |

### folke/which-key.nvim（`plugins/ui.lua`）

`<Leader>` キー等を押した後、0.5 秒待つと利用可能なキーバインド一覧がポップアップ表示される。
キーを覚えていなくても操作を探せる。

---

## ファイルエクスプローラー

### nvim-neo-tree/neo-tree.nvim（`plugins/explorer.lua`）

VSCode のサイドバー（ファイルツリー）相当。幅は `window.width` で変更できる（現在: 70列）。
小さくする場合は 25〜40 が目安。`plugins/explorer.lua` の `width = 70` を編集する。

#### エクスプローラーの開閉

| 操作 | キー | 動作 |
|------|------|------|
| 開く | `<Leader>e` | エクスプローラーを開いてフォーカスを移す（既に開いていればフォーカスだけ移す） |
| 閉じる | `q`（neo-tree 内） | エクスプローラーを閉じる |
| フォーカスをエディタへ戻す | `Ctrl+l`（neo-tree 内） | エクスプローラーを閉じずにエディタ側へ移動 |

#### ファイルを開く

ファイルを選択して開いた後も、エクスプローラーは**開いたまま**フォーカスがエディタに移る。
エクスプローラーを閉じたい場合は neo-tree 内で `q` を押す。

| キー | 動作 |
|------|------|
| `l` または `Enter` | ファイルを開く（エクスプローラーは開いたまま） |
| `h` | ディレクトリを閉じる |

#### エクスプローラー内のその他の操作

| キー | 動作 |
|------|------|
| `a` | ファイル / ディレクトリを作成 |
| `d` | 削除 |
| `r` | リネーム |
| `y` | パスをコピー |
| `p` | 貼り付け |
| `?` | ヘルプ表示（全キー一覧） |

幅を変更する場合は `plugins/explorer.lua` の `window.width` を編集する:

```lua
window = {
  width = 30,  -- この値を変更する（推奨: 25〜40）
}
```

---

## Git

### lewis6991/gitsigns.nvim（`plugins/git.lua`）

ガター（行番号の左）に Git の変更状態を表示し、ハンク単位の操作を提供する。

| 表示 | 意味 |
|------|------|
| `│`（緑） | 追加行 |
| `│`（黄） | 変更行 |
| `_` / `‾` | 削除行 |

| キー | 動作 |
|------|------|
| `]h` | 次の変更ハンクへ移動 |
| `[h` | 前の変更ハンクへ移動 |
| `<Leader>gp` | ハンクのプレビュー |
| `<Leader>gs` | ハンクをステージ |
| `<Leader>gr` | ハンクをリセット |
| `<Leader>gS` | バッファ全体をステージ |
| `<Leader>gR` | バッファ全体をリセット |
| `<Leader>gb` | 行の Git Blame を表示 |
| `<Leader>gd` | 現在ファイルの Diff を表示 |

### tpope/vim-fugitive（`plugins/git.lua`）

`:Git` コマンドで Git 操作全般を行う。

| コマンド | 動作 |
|---------|------|
| `<Leader>gf` または `:Git` | Git status を開く |
| `:Gwrite` | `git add %`（現在ファイルをステージ） |
| `:Gread` | `git checkout %`（変更を破棄） |
| `:Gdiffsplit` | Diff を分割表示 |

### sindrets/diffview.nvim（`plugins/git.lua`）

変更差分とファイル履歴をタブ UI で確認する。ファイルツリー付きで複数ファイルの差分を一覧できる。

| キー | 動作 |
|------|------|
| `<Leader>gv` | 差分ビューを開く（全変更ファイル一覧 + diff） |
| `<Leader>gh` | 現在ファイルのコミット履歴を開く |
| `<Leader>gH` | リポジトリ全体のコミット履歴を開く |
| `q` | diffview を閉じる（ビュー・ファイルパネル・履歴パネル共通） |

diffview は「ファイルパネル（左）」と「diff ビュー（右）」の 2 ペインで構成される。

ファイルパネル（左）での操作:

| キー | 動作 |
|------|------|
| `j / k` | ファイルを上下に移動 |
| `Enter` / `l` | 選択ファイルの diff を表示 |
| `s` または `-` | 選択ファイルをステージ / アンステージ |
| `S` | 全ファイルをステージ |
| `U` | 全ファイルをアンステージ |
| `X` | 選択ファイルの変更を破棄（left 側の状態に戻す） |
| `Tab` / `Shift+Tab` | 次/前のファイルへ移動 |
| `R` | ファイル一覧を更新 |

diff ビュー（右）での操作:

| キー | 動作 |
|------|------|
| `]c / [c` | 次/前の変更ハンクへジャンプ（Vim 標準） |
| `Tab` / `Shift+Tab` | 次/前のファイルへ移動 |
| `<Leader>e` | ファイルパネルにフォーカスを移す |
| `<Leader>b` | ファイルパネルの表示をトグル |
| `g?` | キーバインド一覧を表示 |

---

## エディタ便利機能

### windwp/nvim-autopairs（`plugins/editor.lua`）

括弧・クォートを自動で閉じる。Treesitter と連携して言語に応じた補完を行う。

### numToStr/Comment.nvim（`plugins/editor.lua`）

| キー | 動作 |
|------|------|
| `gcc` | 現在行をコメントトグル |
| `gc{motion}` | 範囲をコメントトグル（例: `gc3j` で3行） |
| `gbc` | ブロックコメントトグル |
| （ビジュアル）`gc` | 選択範囲をコメントトグル |

### kylechui/nvim-surround（`plugins/editor.lua`）

テキストを括弧やクォートで囲む・変更・削除する。

| 操作 | コマンド | 例 |
|------|---------|-----|
| 追加 | `ys{motion}{char}` | `ysiw"` → 単語を `"` で囲む |
| 変更 | `cs{old}{new}` | `cs"'` → `"` を `'` に変更 |
| 削除 | `ds{char}` | `ds"` → 周囲の `"` を削除 |
| ビジュアル | `S{char}` | 選択範囲を囲む |

### folke/flash.nvim（`plugins/editor.lua`）

画面内の任意の場所に高速ジャンプする（easymotion の後継）。

| キー | 動作 |
|------|------|
| `s` + 2文字 | 画面内をジャンプ（2文字でラベルが表示される） |
| `S` | Treesitter ノード単位で選択 |

### folke/trouble.nvim（`plugins/editor.lua`）

LSP 診断（エラー・警告）を一覧表示する。VSCode の「問題」パネル相当。

| キー | 動作 |
|------|------|
| `<Leader>d` | 診断リスト（プロジェクト全体）をトグル |
| `<Leader>dd` | 診断リスト（現在ファイルのみ）をトグル |
| `<Leader>ds` | シンボル一覧をトグル |
| `<Leader>dl` | LSP 参照・定義リストをトグル |

---

## tmux 連携

### christoomey/vim-tmux-navigator（`plugins/tmux.lua`）

Neovim 内のウィンドウ移動と tmux のペイン移動を同じキーで操作できる。

| キー | Neovim 内 | Neovim 外（tmux） |
|------|---------|------------|
| `Ctrl+h` | 左ウィンドウへ | 左ペインへ |
| `Ctrl+j` | 下ウィンドウへ | 下ペインへ |
| `Ctrl+k` | 上ウィンドウへ | 上ペインへ |
| `Ctrl+l` | 右ウィンドウへ | 右ペインへ |

tmux.conf に以下を追記済み（自動検出で Neovim を判定）:

```tmux
is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE ..."
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
...
```

---

## フォーマッター

### stevearc/conform.nvim（`plugins/formatter.lua`）

保存時に自動でコードを整形する。`<Leader>cf` で手動実行も可能。

| 言語 / ファイルタイプ | 使用フォーマッター | 備考 |
|---------------------|----------------|------|
| Ruby, ERB | `rubocop` | `bundle exec rubocop --autocorrect-all` を使用 |
| TypeScript, TSX | `prettier` | グローバルまたはプロジェクトローカルの prettier |
| JavaScript, JSX | `prettier` | 同上 |
| JSON, CSS | `prettier` | 同上 |
| Lua | `stylua` | Lua 専用フォーマッター |

| キー | 動作 |
|------|------|
| `<Leader>cf` | 現在ファイルをフォーマット（保存時も自動実行） |

`ConformInfo` コマンドで現在ファイルに対するフォーマッターの状態を確認できる:

```
:ConformInfo
```

#### Ruby のフォーマットについて

- `"` → `'` への変換、末尾スペース除去、メソッドの整形などを自動実行
- Gemfile があるディレクトリでのみ動作する（worktree 環境対応）
- 行の折り返し（LineLength）は rubocop が自動修正できないため手動対応が必要

#### prettier が見つからない場合

```sh
npm install -g prettier        # グローバルインストール
# または プロジェクト内に prettier がある場合は自動的に使われる
```

---

## セッション管理

### folke/persistence.nvim（`plugins/session.lua`）

Neovim を終了した時点でウィンドウに表示中のファイルを保存し、
同じディレクトリで再起動した時に自動復元する。

#### 起動方法

| 起動コマンド | 動作 |
|------------|------|
| `nvim` | 前回のセッションを自動復元（セッションがなければダッシュボードを表示） |
| `nvim .` | 前回のセッションを自動復元 + neo-tree でカレントディレクトリを表示 |
| `nvim file.rb` | ファイルを直接開く（セッション復元は行わない） |

#### 終了方法

| キー | 動作 |
|------|------|
| `ZZ` | 全バッファを保存して Neovim を終了（セッション保存される） |

`ZZ` = `:wqa`（全ウィンドウ一括終了）。**これが唯一推奨の終了方法。**
`:q!` で強制終了した場合もセッションは保存されるが、未保存の変更は失われる。

#### ファイルを閉じる

| キー / コマンド | 動作 |
|--------------|------|
| `<Leader>bd` | 現在のファイルバッファを閉じる（未保存なら警告） |
| `:bd` | 同上（`cnoreabbrev` により `<Leader>bd` と同じ関数を呼ぶ） |

閉じたファイルは次回起動時に復元されない。
ただし neo-tree にフォーカスがある状態で実行すると何もしない（警告が出る）。

#### キー

| キー | 動作 |
|------|------|
| `<Leader>qs` | 現在ディレクトリのセッションを手動復元 |
| `<Leader>ql` | 最後に使ったセッションを復元 |
| `<Leader>qd` | 今回の Neovim セッションを保存しない |
| `<Leader>qc` | セッションファイルを削除してリセット（不具合時に使用） |

#### セッションの仕組み

- セッションファイルは終了時の「ウィンドウに表示中のファイル」のみを保存する
- `<Leader>bd` で閉じたファイルはウィンドウから消えるため、次回起動時に復元されない
- 終了直前に neo-tree・ディレクトリバッファ・非表示バッファを自動クリーンアップしてからセッションを保存する
- セッションの保存先: `~/.local/state/nvim/sessions/`
- セッションが壊れた場合は `<Leader>qc` でリセットする

---

## Obsidian 連携

### epwalsh/obsidian.nvim（`plugins/obsidian.lua`）

Neovim から Obsidian Vault を参照・編集できる。
Vault パス: `/Users/yuma-oka/src/github.com/ok66ym/obsidian`

Vault 内の Markdown ファイルを開いた時のみ読み込まれる（遅延読み込み）。
CFO-Alpha の作業中は干渉しない。

| キー | 動作 |
|------|------|
| `<Leader>of` | ノートを名前で検索・切替（Telescope） |
| `<Leader>og` | Vault 内の全文検索 |
| `<Leader>on` | 新規ノートを作成 |
| `<Leader>od` | 今日の日次ノートを開く |
| `<Leader>ol` | カーソル下のリンクを開く |
| `<Leader>ob` | バックリンク一覧を表示 |
| `<Leader>os` | タグで検索 |
| `<Leader>ot` | テンプレートを挿入 |
| `<Leader>oo` | Obsidian GUI アプリで開く |
| `<Leader>op` | クリップボードの画像を貼り付け |
| `<Leader>ow` | ワークスペースを切替 |

詳細な操作ガイドは `OBSIDIAN.md` を参照（`<Leader>?b` で開く）。

---

## Claude Code 連携

### claude-prompt-edit（`~/.local/bin/claude-prompt-edit`）

tmux の `prefix + Ctrl+g` で起動する。Neovim でプロンプトを編集し、
Claude Code が動いているペインに送信する。

| 操作 | 動作 |
|------|------|
| `prefix + Ctrl+g` | Neovim でプロンプト編集画面を開く（フロートポップアップ） |
| `:wq` | 編集を確定して Claude Code に送信 |
| `:q!` | 編集をキャンセル |

送信先の特定順序:
1. 呼び出し元と同じウィンドウ内の Claude Code プロセス
2. `/tmp/claude-status/` で waiting 状態のペイン

複数行プロンプトは `Shift+Enter`（`\x1b\r`）で改行されて送信される。

---

## ドキュメント参照

### フロートウィンドウで表示（`lua/config/keymaps.lua`）

作業中のバッファを汚さずにドキュメントを参照できる。`q` で閉じると元のバッファに即戻る。

| キー | 動作 |
|------|------|
| `<Leader>?u` | Neovim USAGE.md をフロートウィンドウで表示 |
| `<Leader>?p` | Neovim PLUGINS.md をフロートウィンドウで表示 |
| `<Leader>?b` | Obsidian 操作ガイドをフロートウィンドウで表示 |
| `<Leader>?t` | Ghostty + tmux 操作ガイドをフロートウィンドウで表示 |
| `<Leader>?w` | worktree 設定リファレンスをフロートウィンドウで表示 |
| `q` | フロートを閉じる |

`<Leader>?` まで押すと which-key に `Docs` グループとして候補が表示される。

tmux 内（Neovim 外）では `prefix + ?` で fzf からドキュメントを選択して bat で表示できる。
