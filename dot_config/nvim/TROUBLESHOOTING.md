# Neovim トラブルシューティングガイド

エラーや通知が出た時の診断・解決手順をまとめたドキュメント。

`<Leader>` = `Space`  |  このドキュメントを開く: `<Leader>?x`

---

## Step 1: エラーの内容を確認する

### 通知が消えてしまった場合

右上のポップアップはすぐ消えるが、以下の方法で再確認できる:

```
<Leader>n  → 通知履歴を一覧表示（最新のエラーを含む全通知）
:messages  → Neovim の直近メッセージをすべて表示
```

> `<Leader>n` は snacks.nvim の通知履歴ウィンドウを開く。
> ウィンドウ内で `j/k` で移動、`q` で閉じる。

### エラーの種類を見分ける

| ポップアップのタイトル / 色 | 種類 |
|--------------------------|------|
| `lazy.nvim`（赤） | プラグインの設定・読み込みエラー |
| `lazy.nvim`（黄） | プラグインの警告（deprecation 等） |
| `Neovim: 依存ツール確認`（黄） | ripgrep / fd 等のシステムツール未インストール |
| タイトルなし（赤） | Neovim / Lua の実行時エラー |
| `Ruby LSP client: ...` | LSP サーバーのエラー |

---

## Step 2: エラータイプ別の診断フロー

### A. lazy.nvim のプラグインエラー

```
:Lazy
```

1. `:Lazy` を開く
2. エラーのあるプラグインは赤く表示される
3. そのプラグインにカーソルを合わせて `l` → ログ・スタックトレースを確認
4. `x` → プラグインを削除して `:Lazy sync` で再インストール

スタックトレースの読み方:

```
Failed to run config for nvim-treesitter      ← エラーが発生したプラグイン
  lua/plugins/treesitter.lua:7 in config      ← エラーが発生したファイルと行番号
  vim/_editor.lua:0 in cmd                    ← Neovim 内部の呼び出し
```

「ファイル名:行番号」に直接ジャンプする方法:

```
:e lua/plugins/treesitter.lua   → ファイルを開く（~/.config/nvim/ 起点）
7G                              → 7行目に移動
```

---

### B. LSP が動かない

```
:LspInfo    → 現在のファイルに対して起動している LSP を確認
:Mason      → インストール済みサーバーを確認（✓ = OK / ✗ = 未インストール）
:LspRestart → LSP サーバーを再起動
:LspLog     → LSP のエラーログを確認
```

確認フロー:

```
:LspInfo を実行
  ↓
「0 active clients」と表示される
  ↓
:Mason でサーバーが ✓ か確認
  → ✗ の場合: :MasonInstall lua_ls (or ruby_lsp / ts_ls)
  → ✓ の場合: root_dir が見つかっていない可能性
      tsconfig.json / package.json があるディレクトリで nvim . を開いているか確認
  ↓
それでも動かない場合
  → :LspLog でエラー内容を確認
  → :LspRestart で再起動を試みる
```

#### `gd` で `index.mjs` に飛ぶ / 「No LSP Definitions found」が出る

ts_ls が外部ライブラリのバンドルファイルをソース定義として返している状態。

`lua/lsp/typescript.lua` の `root_dir` の形式を確認する:

```lua
-- 正しい形式（Neovim 0.11 が要求するコールバック形式）
root_dir = function(bufnr, on_dir)
  on_dir(vim.fs.root(bufnr, { "tsconfig.json", "package.json", ".git" }))
end,

-- 誤り: on_dir を呼ばないため LSP がルートを認識できず起動しない
root_dir = function(fname)
  return vim.fs.root(fname, { "tsconfig.json" })
end,
```

`root_markers` は `nvim-lspconfig` のデフォルト `root_dir` が存在する場合は無視されるため、
`root_dir` をコールバック形式で明示的に上書きする必要がある。

---

### C. キーバインドが効かない

```
:verbose map <Leader>x   → そのキーに何が割り当てられているか確認
```

出力例:

```
n  <Space>ff    * <Cmd>Telescope find_files<CR>
        Last set from ~/.config/nvim/lua/config/keymaps.lua line 103
```

よくある原因:

| 原因 | 確認方法 | 対処 |
|------|---------|------|
| プラグインが未ロード | `:Lazy` で該当プラグインを確認 | `keys` または `cmd` トリガーを設定 |
| neo-tree にフォーカスがある | 画面左のエクスプローラーがアクティブ | `Ctrl+l` でエディタ側に移動してから操作 |
| 別のキーと競合している | `:verbose map <Leader>x` | 片方を別のキーに変更する |
| Obsidian キーが別リポジトリで動かない | `:Lazy` で obsidian.nvim の状態確認 | `<Leader>of` を押して手動ロード |

---

### D. フォーマットが動かない

```
:ConformInfo   → フォーマッターの状態確認（使用中のフォーマッターと問題点が表示される）
```

言語別の確認:

| 言語 | フォーマッター | 確認コマンド |
|------|-------------|------------|
| Lua | stylua | `:Mason` で stylua が ✓ か確認 |
| Ruby | rubocop | `bundle exec rubocop --version` |
| TypeScript | prettier | `prettier --version` |

```
Lua（stylua）が動かない
  → :Mason を開いて stylua が ✓ か確認
  → ✗ の場合: :MasonInstall stylua

Ruby（rubocop）が動かない
  → カレントディレクトリに Gemfile があるか確認（require_cwd = true のため）
  → bundle install を実行してから再試行

TypeScript（prettier）が動かない
  → npm install -g prettier でグローバルインストール
  → またはプロジェクト内の node_modules/.bin/prettier が使われる
```

---

### E. 「依存ツール確認」の通知が出る

起動 1.5 秒後に出る通知。表示されたコマンドをターミナルで実行する:

| ツール | インストールコマンド | 用途 |
|--------|-------------------|------|
| `rg`（ripgrep）| `brew install ripgrep` | `<Leader>fg` 全文検索 |
| `fd` | `brew install fd` | `<Leader>ff` ファイル検索の高速化 |
| `gh` | `brew install gh && gh auth login` | `<Leader>po` PR レビュー |

インストール後は Neovim を再起動すると通知は出なくなる。

---

## Step 3: 全体ヘルスチェック

```
:checkhealth          → 環境全体（Neovim・プラグイン・システム）のヘルスチェック
:checkhealth lazy     → lazy.nvim の状態確認
:checkhealth nvim     → Neovim 本体の状態確認
:checkhealth lsp      → LSP の状態確認
:checkhealth obsidian → obsidian.nvim の状態確認
```

`:checkhealth` の結果の見方:

```
OK   : 問題なし
WARNING : 警告（動作するが推奨状態ではない）
ERROR : エラー（その機能が動作しない）
```

ERROR が出ている項目の名前で検索すると対処法が見つかることが多い。

---

## Step 4: よくある起動時エラーと対処法

### `You need to set vim.g.mapleader BEFORE loading lazy`

**原因**: `init.lua` で `vim.g.mapleader` の設定が `require("config.lazy")` より後になっている。

**確認**: `init.lua` の先頭を確認する:

```lua
-- 正しい順序（mapleader が lazy より前）
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"
require("config.lazy")   ← この順序
```

`keymaps.lua` に `vim.g.mapleader` を書くと遅すぎる（lazy の後に読み込まれる）。

---

### `Failed to run config for nvim-treesitter` / `module 'nvim-treesitter.configs' not found`

**原因**: セッション復元（persistence.nvim）がファイルを開いた時、
treesitter の config が実行されるが、初回インストール前はモジュールが存在しない。

**対処**:

```
:Lazy sync   → プラグインをインストール
ZZ           → Neovim を再起動
```

再起動後は `pcall` ガードにより出なくなる。

---

### `require('lspconfig') "framework" is deprecated`

**原因**: nvim-lspconfig v2 で `require("lspconfig").server.setup()` が非推奨になった。

**確認**: `lua/lsp/` 配下のファイルに旧 API が使われていないか確認する:

```lua
-- 旧 API（非推奨・この書き方が残っていると警告が出る）
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({ ... })   -- ← これが警告の原因

-- 新 API（推奨）
vim.lsp.config("lua_ls", { ... })
vim.lsp.enable("lua_ls")
```

---

### `Ruby LSP client: Couldn't create connection to server`

**原因**: ruby-lsp gem が未インストール、または bundle exec が通らない状態。

**対処**:

```sh
gem install ruby-lsp          # グローバル
# または
bundle add ruby-lsp --group development  # プロジェクト内
bundle install
```

---

### snacks.nvim / 通知プラグインのエラー

snacks.nvim は `lazy = false`（起動時即ロード）のため、
snacks 自体のエラーはほぼ設定ミスが原因。

```
:messages   → エラーメッセージを確認
```

---

## Step 5: リセット・最終手段

### プラグインをクリーンインストールする

```
:Lazy clean   → 未使用プラグインを削除
:Lazy sync    → インストール・更新・クリーンを一括実行
```

### 特定プラグインを一時的に無効化する

問題の切り分けに使う。`lua/plugins/` の該当ファイルに `enabled = false` を追加:

```lua
return {
  {
    "author/plugin-name",
    enabled = false,   -- これを追加して再起動
    ...
  },
}
```

### 存在しないファイルや関係ないファイルがタブに表示される

**代表的な原因1: Claude Code のプロンプト一時ファイル**

`prefix + Ctrl+g` でプロンプトを編集するとき、スクリプトが Neovim を `/tmp/claude-prompt-*.md` を引数に起動する。プロンプト送信後にこの一時ファイルは削除されるが、Neovim 終了時にセッションが上書き保存されてしまうと次回起動時に「存在しないファイル」として復元される。

**修正済みの動作**: `session.lua` の VimLeavePre に以下の対策が実装されている:
- ファイルを引数に起動した場合（一時ファイル含む）はセッションを保存しない
- `/tmp/` `/private/tmp/` のファイルは保存前にバッファから除外
- ディスク上に存在しないファイルは保存前にバッファから除外

**代表的な原因2: 前回のセッションが既に壊れている**

上記の修正が適用される前に壊れたセッションが保存されている場合は手動でクリアが必要:

```
<Leader>qc   → 現在のセッションを削除（修正後は current() で動作）
ZZ           → 再起動してクリーンな状態で始める
```

**セッションファイルを直接確認・削除したい場合**:

```sh
ls ~/.local/state/nvim/sessions/   # セッションファイル一覧
rm ~/.local/state/nvim/sessions/<ファイル名>   # 特定のセッションを削除
```

セッションファイル名はパスの `/` が `%` に置換されたもの（例: `%Users%name%project%%branch.vim`）。

---

### セッションをクリアする

セッション復元が原因でエラーが出続ける場合:

```
<Leader>qc   → セッションファイルを削除
ZZ           → 再起動（クリーンな状態で起動）
```

### Neovim の設定を最小構成でテストする

特定のファイルだけを読み込んで起動することで問題を切り分けられる:

```sh
nvim --clean         # プラグイン・設定なしで起動（素の Neovim）
nvim -u NONE         # init.lua を読まずに起動
```

`nvim --clean` で問題が出ない場合 → 設定ファイル・プラグインに原因がある。

---

## 診断コマンド早見表

| コマンド | 用途 |
|---------|------|
| `<Leader>n` | 通知履歴を表示（消えた通知を再確認） |
| `:messages` | Neovim の直近メッセージをすべて表示 |
| `:checkhealth` | 環境全体のヘルスチェック |
| `:Lazy` | プラグイン状態確認（`l` でログ表示） |
| `:Lazy sync` | プラグインの再インストール・更新 |
| `:Lazy log` | lazy.nvim の操作ログ |
| `:Mason` | LSP・フォーマッターのインストール状況 |
| `:LspInfo` | 現在のファイルに対応した LSP の状態 |
| `:LspRestart` | LSP サーバーを再起動 |
| `:LspLog` | LSP のエラーログ |
| `:ConformInfo` | フォーマッターの状態 |
| `:verbose map <key>` | キーバインドの割り当て確認 |
| `nvim --clean` | プラグインなしで起動（問題の切り分け） |
