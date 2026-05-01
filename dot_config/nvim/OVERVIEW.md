# Neovim 設定 概要・ドキュメントガイド

この環境（Ghostty + tmux + Neovim + Claude Code）の全体構成と、
設定を修正・拡張する方法をまとめたドキュメント。

`<Leader>` = `Space`

---

## ドキュメント一覧

### Neovim 内から開く（`<Leader>?` + キー）

| キー | ファイル | 内容 |
|------|---------|------|
| `<Leader>?o` | `OVERVIEW.md` | このファイル。構成・修正方法・セットアップガイド |
| `<Leader>?u` | `USAGE.md` | 全キーバインドの早見表 |
| `<Leader>?p` | `PLUGINS.md` | 導入プラグインの説明・設定・操作方法 |
| `<Leader>?b` | `OBSIDIAN.md` | Obsidian プラグインの操作ガイド |
| `<Leader>?c` | `CHEZMOI.md` | chezmoi dotfiles 管理の操作ガイド |
| `<Leader>?r` | `TUTORIAL.md` | チュートリアルのインデックス |
| `<Leader>?1` | `TUTORIAL_01_vim_basics.md` | Vim 基本（モード・移動・編集・保存） |
| `<Leader>?2` | `TUTORIAL_02_files.md` | ファイル操作（neo-tree・Telescope・バッファ） |
| `<Leader>?3` | `TUTORIAL_03_code.md` | コード操作（LSP・補完・検索・Git・PR） |
| `<Leader>?4` | `TUTORIAL_04_environment.md` | 環境操作（tmux・Claude Code・worktree） |
| `<Leader>?5` | `TUTORIAL_05_github_pr.md` | GitHub PR レビュー（octo.nvim） |
| `<Leader>?6` | `TUTORIAL_06_obsidian.md` | Obsidian ノート管理 |
| `<Leader>?x` | `TROUBLESHOOTING.md` | トラブルシューティング（エラー診断・解決） |
| `<Leader>?t` | `~/.config/ghostty/usage.md` | Ghostty + tmux 操作ガイド |
| `<Leader>?w` | `~/.config/tm-wt/README.md` | worktree 設定リファレンス |

### tmux 内から開く

```
prefix + ?  → fzf でドキュメントを選択して bat で表示
```

---

## 新しい環境でのセットアップ

別のマシンやクリーンな環境でこの Neovim 設定を動かす手順。

### ステップ 1: 前提ツールをインストール

```sh
# Neovim 本体（mise で管理）
mise install neovim@stable

# 必須: 全文検索に使用（Telescope live_grep）
brew install ripgrep

# 必須: ファイル検索の高速化（Telescope find_files）
brew install fd

# 必須: GitHub PR 操作（octo.nvim）
brew install gh
gh auth login     # ブラウザでの認証が必要

# 推奨: ファイル確認（tmux prefix+? でドキュメント表示）
brew install bat

# 推奨: fzf（tmux との連携で使用）
brew install fzf
```

> `stylua`（Lua フォーマッター）は Neovim 起動後に Mason が自動インストールするため不要。

### ステップ 2: Neovim 設定を配置

chezmoi を使っている場合:

```sh
chezmoi apply
```

手動の場合:

```sh
git clone <設定リポジトリ> ~/.config/nvim
```

### ステップ 3: Neovim を起動してプラグインをインストール

```sh
nvim
```

起動すると以下が自動実行される:

| タイミング | 自動処理 |
|-----------|---------|
| 初回起動時 | lazy.nvim が全プラグインをインストール |
| 起動 1.5 秒後 | 未インストールのツール（fd 等）を通知 |
| 起動 3 秒後 | mason-tool-installer が `stylua` をインストール |

プラグインインストール後に手動で確認:

```
:Lazy          → インストール状況の確認（全て ✓ になるまで待つ）
:Mason         → LSP サーバーの確認（ruby_lsp / ts_ls / lua_ls が ✓ か確認）
:checkhealth   → 環境全体のヘルスチェック
```

#### 初回起動時の既知のエラーについて

初回インストール前（`:Lazy sync` 完了前）に以下のエラーが出ることがあるが、
インストール完了後の再起動で消える:

| エラーメッセージ | 原因 | 対処 |
|----------------|------|------|
| `Failed to run config for nvim-treesitter` | treesitter 未インストール状態でセッション復元が実行された | `:Lazy sync` 後に再起動 |
| `module 'nvim-treesitter.configs' not found` | 同上 | 同上 |
| `You need to set vim.g.mapleader BEFORE loading lazy` | 設定ファイルの初期化順序の問題 | 通常は init.lua で修正済みのため出ないはず |
| `require('lspconfig') "framework" is deprecated` | nvim-lspconfig v2 で旧 API を使用している | 新 API（vim.lsp.config）を使っているため出ないはず |

### ステップ 4: LSP サーバーを確認

`:Mason` を開いて以下が ✓ になっているか確認:

| サーバー | 言語 |
|---------|------|
| `lua_ls` | Lua（Neovim 設定編集用） |
| `ruby_lsp` | Ruby / Rails |
| `ts_ls` | TypeScript / JavaScript / TSX |

なっていない場合は `:MasonUpdate` を実行してから再度確認。

### 自動インストールされるもの vs 手動インストールが必要なもの

| ツール | 自動 / 手動 | 方法 |
|--------|-----------|------|
| Neovim プラグイン | 自動 | lazy.nvim が初回起動時にインストール |
| LSP サーバー（ruby_lsp 等） | 自動 | mason-lspconfig が起動時にインストール |
| `stylua` | 自動 | mason-tool-installer が起動 3 秒後にインストール |
| `ripgrep` (`rg`) | 手動 | `brew install ripgrep` |
| `fd` | 手動 | `brew install fd` |
| `gh` CLI | 手動 | `brew install gh && gh auth login` |
| `prettier` | 手動 | `npm install -g prettier`（プロジェクト内でも可） |

---

## 設定ファイルの構成

```
~/.config/nvim/
├── init.lua                    ← エントリーポイント（最初に読み込まれる）
└── lua/
    ├── config/                 ← Neovim 本体の設定
    │   ├── options.lua         ← 基本設定（行番号・インデント・PATH 等）
    │   ├── keymaps.lua         ← キーバインド定義
    │   ├── autocmds.lua        ← 自動コマンド（依存ツール通知含む）
    │   └── lazy.lua            ← プラグインマネージャーの設定
    ├── lsp/                    ← LSP 設定（言語別に分割）
    │   ├── init.lua            ← 共通設定（on_attach / capabilities / 診断）
    │   ├── lua_ls.lua          ← Lua 言語サーバー
    │   ├── ruby.lua            ← Ruby 言語サーバー
    │   └── typescript.lua      ← TypeScript / JavaScript 言語サーバー
    └── plugins/                ← プラグインの設定（1ファイル = 1テーマ）
        ├── colorscheme.lua     ← テーマ（Dracula）
        ├── treesitter.lua      ← シンタックスハイライト
        ├── snacks.lua          ← lazygit / ターミナル / 通知
        ├── telescope.lua       ← ファジーファインダー（要: ripgrep / fd）
        ├── lsp.lua             ← LSP プラグイン定義（Mason / mason-tool-installer）
        ├── cmp.lua             ← 自動補完
        ├── ui.lua              ← lualine / bufferline / which-key
        ├── explorer.lua        ← ファイルエクスプローラー（neo-tree）
        ├── git.lua             ← gitsigns / fugitive / diffview / octo.nvim
        ├── editor.lua          ← autopairs / Comment / surround / flash / trouble
        ├── formatter.lua       ← conform.nvim（保存時自動フォーマット）
        ├── session.lua         ← セッション管理（persistence.nvim）
        ├── obsidian.lua        ← Obsidian ノート管理
        └── tmux.lua            ← vim-tmux-navigator
```

### 読み込みの流れ

```
init.lua
  ├── vim.g.mapleader = " "     ← lazy.nvim より前に設定する必要がある（重要）
  ├── require("config.lazy")    → lazy.nvim を初期化し plugins/ を全て読み込む
  ├── require("config.options") → 基本設定・PATH 設定を適用
  ├── require("config.keymaps") → キーバインドを登録
  └── require("config.autocmds")→ 自動コマンドを登録
```

> `vim.g.mapleader` は `require("config.lazy")` より前に設定しなければならない。
> lazy.nvim はセットアップ時にプラグインの `keys` トリガー（`<Leader>*`）を登録するため、
> この順序が逆になると全プラグインのキーバインドが壊れる。
> `keymaps.lua` ではなく `init.lua` の冒頭で設定しているのはこのためである。

LSP の読み込み（Neovim がファイルを開いた時）:

```
plugins/lsp.lua
  └── mason-lspconfig の config 関数
        ├── require("lsp").setup()           → vim.lsp.config("*", {capabilities, on_attach})
        ├── require("lsp.lua_ls")()          → vim.lsp.config("lua_ls", {settings})
        ├── require("lsp.typescript")()      → vim.lsp.config("ts_ls", {filetypes, root_dir})
        ├── mason-lspconfig handlers         → vim.lsp.enable(server_name) で各サーバーを有効化
        └── require("lsp").setup_diagnostics() → 診断・ホバーの見た目設定
```

> nvim-lspconfig v2 以降は `require("lspconfig").server.setup()` が非推奨となり、
> `vim.lsp.config()` + `vim.lsp.enable()` の組み合わせが推奨 API になった。
> 旧 API を使うと起動時に警告が表示される。

---

## 設定の修正方法

### キーバインドを追加・変更する

**ファイル**: `lua/config/keymaps.lua`

```lua
local map = vim.keymap.set

-- ノーマルモードでのキーバインド
map("n", "<Leader>x", ":SomeCommand<CR>", { desc = "説明テキスト" })

-- 複数モードに対応させる場合
map({ "n", "v" }, "<Leader>x", ":SomeCommand<CR>", { desc = "説明テキスト" })

-- 関数を呼び出す場合
map("n", "<Leader>x", function()
  -- 処理
end, { desc = "説明テキスト" })
```

**モードの指定**:

| 文字 | モード |
|------|--------|
| `"n"` | Normal |
| `"i"` | Insert |
| `"v"` | Visual |
| `"x"` | Visual（行・ブロック含む） |
| `"o"` | Operator-pending |

**which-key のグループ名を追加する場合**は `lua/plugins/ui.lua` の `wk.add({})` にも追記する:

```lua
wk.add({
  { "<Leader>x", group = "新しいグループ名" },
})
```

> キープレフィックスが既存のマッピングと1文字だけ重なる場合（例: `<Leader>o` と `<Leader>ob`）、
> 1文字のほうを別のキーに変更しないと timeout 問題が発生する。
> 例: `<Leader>o`（Neotree）→ `<Leader>oe` に変更して `<Leader>o*`（Obsidian）と分離。

---

### プラグインを追加する

**ファイル**: `lua/plugins/` 配下に新しい `.lua` ファイルを作成する

`lua/config/lazy.lua` は `plugins/` 配下の全ファイルを自動で読み込むため、
ファイルを作成するだけで次回 Neovim 起動時に自動インストールされる。

**ファイルの形式**:

```lua
-- lua/plugins/my-plugin.lua
return {
  {
    "author/plugin-name",      -- GitHub の author/repo 形式
    event = "VeryLazy",        -- 遅延読み込みのタイミング（省略可）
    dependencies = {           -- 依存プラグイン（省略可）
      "other/plugin",
    },
    keys = {                   -- このプラグインのキーバインド（省略可）
      { "<Leader>x", ":PluginCommand<CR>", desc = "説明" },
    },
    opts = {                   -- setup() に渡すオプション（config の代替）
      option_key = "value",
    },
    -- または config 関数で細かく設定する場合:
    config = function()
      require("plugin-name").setup({
        option_key = "value",
      })
    end,
  },
}
```

**遅延読み込みの指定**（パフォーマンス向上）:

| 指定方法 | 読み込みタイミング |
|---------|----------------|
| `event = "VeryLazy"` | Neovim 起動後（ほとんどのプラグインに適用） |
| `event = "BufReadPost"` | ファイルを開いた時 |
| `event = "InsertEnter"` | Insert モードに入った時 |
| `cmd = "CommandName"` | そのコマンドが実行された時 |
| `keys = { ... }` | そのキーが押された時 |
| `ft = "typescript"` | 特定のファイルタイプを開いた時 |
| `lazy = false` | 起動時に即ロード（デフォルト） |

> `keys` トリガーを設定すると、プラグインが未ロードでもそのキーを押した瞬間にロードされる。
> 別リポジトリから Obsidian コマンドを使いたい場合などに有効。
> `cmd` トリガーでも同様に「そのコマンドを実行した時にロード」できる。

**プラグイン追加後の操作**:

```
:Lazy          → プラグイン管理 UI を開く
:Lazy sync     → インストール・更新・クリーンを一括実行
:Lazy update   → 全プラグインを更新
:Lazy clean    → 不要なプラグインを削除
```

---

### LSP の設定を変更する

LSP 設定は `lua/lsp/` ディレクトリで言語別に管理している。

#### 新しい言語サーバーを追加する

1. `:Mason` を開いて言語サーバー名を確認（例: `pyright`, `gopls` 等）
2. `lua/plugins/lsp.lua` の `ensure_installed` に追加:

```lua
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ruby_lsp",
    "ts_ls",
    "pyright",    -- 追加
  },
})
```

3. `lua/lsp/python.lua` を新規作成:

```lua
-- Python 言語サーバー
return function()
  vim.lsp.config("pyright", {
    -- 必要なら pyright 固有の設定を追加
    settings = {
      python = {
        analysis = { typeCheckingMode = "basic" },
      },
    },
  })
end
```

4. `lua/plugins/lsp.lua` の config 関数内で呼び出す（`require("lsp").setup()` の後）:

```lua
require("lsp.python")()
```

追加設定が不要なサーバー（ruby_lsp 等）は `lua/lsp/` ファイルを作らなくてよい。
handlers のデフォルト関数（`vim.lsp.enable(server_name)`）が自動で有効化してくれる。
グローバル設定（`vim.lsp.config("*", {...})`）の on_attach・capabilities が自動適用される。

#### TypeScript LSP の定義ジャンプ（gd）の仕組み

`lua/lsp/typescript.lua` で TypeScript 専用の `gd` を設定している。
通常の `textDocument/definition` は `import` 文や `.d.ts` ではなくバンドルファイルに飛ぶことがあるため、
TypeScript Language Server 固有の `_typescript.goToSourceDefinition` を使って実装元を探す。

```
gd を押す
  ↓
_typescript.goToSourceDefinition を呼ぶ
  ↓
プロジェクト内の .tsx → 直接ジャンプ
外部ライブラリ（@c-fo/standard-ui 等） → index.mjs（バンドル）が返る
  ↓ is_bundle フィルターで除外
textDocument/definition を同じカーソル位置の params で直接呼ぶ
  ↓
SplitPanel.d.ts 等の型定義ファイルに飛ぶ（VSCode と同じ挙動）
  ↓ それでも失敗した場合
dist/index.mjs → dist/index.d.ts に変換して開く（最終フォールバック）
```

#### root_dir の設定（Neovim 0.11 の注意点）

`vim.lsp.config` の `root_dir` には必ずコールバック形式を使う:

```lua
-- 正しい形式（on_dir コールバックを呼ぶ）
root_dir = function(bufnr, on_dir)
  on_dir(vim.fs.root(bufnr, { "tsconfig.json", "package.json", ".git" }))
end,
```

以下の形式は `on_dir` が呼ばれず LSP が起動しないため使わない:

```lua
-- 誤り（古い形式・LSP が起動しない）
root_dir = function(fname)
  return vim.fs.root(fname, { "tsconfig.json" })  -- return しても on_dir が呼ばれない
end,
```

また `root_markers` は `root_dir` が設定されている場合は無視される
（`nvim-lspconfig` のデフォルト `root_dir` が存在すると `root_markers` は効かない）。
`nvim-lspconfig` のデフォルトを上書きする場合は必ず `root_dir` をコールバック形式で明示指定する。

#### 全 LSP 共通のキーバインドを変更する

`lua/lsp/init.lua` の `on_attach` 関数内を変更する:

```lua
local function on_attach(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", ..., opts)
  -- ここに追加・変更する
end
```

#### nvim-lspconfig v2 以降の API について

nvim-lspconfig v2 からは `require("lspconfig").server.setup()` が非推奨になり、
代わりに Neovim 0.11+ 組み込みの `vim.lsp.config` / `vim.lsp.enable` を使う:

```lua
-- 非推奨（v3 で削除予定）
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({ ... })

-- 推奨（nvim 0.11+ / lspconfig v2+）
vim.lsp.config("lua_ls", { ... })   -- サーバー設定を登録
vim.lsp.enable("lua_ls")            -- サーバーを有効化
```

全サーバー共通の設定はワイルドカードで適用できる:

```lua
vim.lsp.config("*", {
  capabilities = capabilities,  -- nvim-cmp との連携
  on_attach    = on_attach,      -- バッファごとのキーバインド登録
})
```

#### LSP の動作確認コマンド

```
:LspInfo      → 現在のファイルに対して起動している LSP を確認
:Mason        → LSP サーバーのインストール状況
:LspRestart   → LSP を再起動
:LspLog       → LSP のログを確認（エラー調査に使う）
```

---

### Mason でツールを自動インストールする

LSP 以外のツール（フォーマッター・リンター）は `mason-tool-installer.nvim` で管理する。

**ファイル**: `lua/plugins/lsp.lua` の `mason-tool-installer` セクション

```lua
require("mason-tool-installer").setup({
  ensure_installed = {
    "stylua",      -- Lua フォーマッター
    "prettier",    -- JS/TS フォーマッター（Mason 経由で管理する場合）
  },
  run_on_start = true,
  start_delay  = 3000,
})
```

`:Mason` で `stylua` 等が表示され ✓ になっていればインストール済み。

---

### 基本設定を変更する

**ファイル**: `lua/config/options.lua`

よく変更する設定:

```lua
-- タブ幅を4に変更（デフォルト2）
opt.shiftwidth = 4
opt.tabstop = 4

-- 折り返し表示を有効にする
opt.wrap = true

-- スクロールオフセットを変更（カーソル上下の余白行数）
opt.scrolloff = 5

-- 相対行番号を無効にする
opt.relativenumber = false
```

PATH の追加（システムツールが見つからない場合）:

```lua
-- Homebrew の PATH を確実に追加（tmux/GUI 起動時に欠落する場合がある）
local homebrew = "/opt/homebrew/bin"
if vim.fn.isdirectory(homebrew) == 1 and not vim.env.PATH:find(homebrew, 1, true) then
  vim.env.PATH = homebrew .. ":" .. vim.env.PATH
end
```

---

### エクスプローラー（neo-tree）の幅を変更する

**ファイル**: `lua/plugins/explorer.lua`

```lua
window = {
  width = 30,  -- 列数で指定（現在: 70）
},
```

幅を小さくするほどエディタ領域が広くなる。推奨値は 25〜40。

---

### エディタの背景透明度を調整する

透明度は **Ghostty の設定ファイル** で管理している。
Neovim の Dracula テーマは `transparent_bg = true` が有効なので、
Ghostty 側の値がそのままエディタ背景に反映される。

**ファイル**: `~/.config/ghostty/config.ghostty`

```ini
background-opacity = 0.9   # 0.0（完全透明）〜 1.0（不透明）
```

変更後は Ghostty を `super+r`（設定再読込）または再起動すると即反映される。

透明度の目安:
| 値 | 見た目 |
|----|-------|
| `1.0` | 完全不透明（背景なし） |
| `0.9` | 少し透ける（デフォルト） |
| `0.8` | 背景が見える |
| `0.5` | かなり透明 |
| `0.0` | 完全透明 |

---

### Treesitter で言語を追加する

**ファイル**: `lua/plugins/treesitter.lua`

`ensure_installed` のリストに追加する:

```lua
ensure_installed = {
  "lua", "vim", "ruby", "typescript", "tsx",
  "python",    -- 追加
  "go",        -- 追加
},
```

または Neovim 内から直接インストール:

```
:TSInstall python
```

---

### テーマを変更する

**ファイル**: `lua/plugins/colorscheme.lua`

```lua
return {
  {
    "別のテーマ/プラグイン名",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme 別のテーマ名")
    end,
  },
}
```

---

### 自動コマンドを追加する

**ファイル**: `lua/config/autocmds.lua`

```lua
local autocmd = vim.api.nvim_create_autocmd

-- 特定のファイルタイプで設定を変える例
autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true     -- markdown では折り返し有効
    vim.opt_local.spell = true    -- スペルチェック有効
  end,
})

-- ファイルを開いた時に何かを実行する例
autocmd("BufReadPost", {
  callback = function()
    -- 処理
  end,
})
```

---

## chezmoi 管理の手順

設定を変更したら chezmoi でソースを更新してコミットする。

### 既存ファイルを変更した場合

```sh
chezmoi re-add ~/.config/nvim/lua/plugins/lsp.lua
chezmoi git -- add -A
chezmoi git -- commit -m "LSP設定を変更: pythonを追加"
```

### 新しいファイルを追加した場合

```sh
chezmoi add ~/.config/nvim/lua/plugins/my-plugin.lua
chezmoi git -- add -A
chezmoi git -- commit -m "プラグイン追加: my-plugin"
```

### ディレクトリごと追加する場合

```sh
chezmoi add --recursive ~/.config/nvim/lua/lsp/
chezmoi git -- add -A
chezmoi git -- commit -m "lsp/ ディレクトリを追加"
```

### 実行可能スクリプトを追加した場合

```sh
chezmoi add ~/.local/bin/my-script
chezmoi chattr +x ~/.local/bin/my-script
chezmoi git -- add -A
chezmoi git -- commit -m "スクリプト追加: my-script"
```

### まとめて確認・コミット

```sh
chezmoi status          # 差分があるファイルを確認
chezmoi diff            # 変更内容を確認
chezmoi git -- status   # git の状態を確認
chezmoi git -- log --oneline -5  # 直近のコミットを確認
```

---

## トラブルシューティング

### エラーが消えてしまって内容を確認できない

起動時の通知ポップアップはすぐ消えるが、以下の方法で再確認できる:

```
<Leader>n   → 通知履歴ウィンドウを開く（全エラー・警告が一覧表示）
:messages   → Neovim の直近メッセージをすべて表示
:Lazy       → lazy.nvim のエラー確認（赤いプラグインにカーソルを当てて l でログ）
```

詳細な診断手順は `<Leader>?x` でトラブルシューティングガイドを参照。

---

### 起動時に `You need to set vim.g.mapleader BEFORE loading lazy` が出る

`init.lua` で `vim.g.mapleader` の設定が `require("config.lazy")` より後になっている。
正しい順序は `init.lua` の冒頭で設定すること:

```lua
-- init.lua の先頭部分（この順序が必須）
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"
require("config.lazy")   -- この後に lazy を初期化
```

`keymaps.lua` に `vim.g.mapleader` を書くと遅すぎて同じエラーになる。

---

### 起動時に `Failed to run config for nvim-treesitter` が出る

セッション復元（persistence.nvim）が `VimEnter` でファイルを開くと
`BufReadPost` イベントが発火し、treesitter の config 関数が呼ばれる。
しかし初回インストール前は `nvim-treesitter.configs` モジュールが存在しないためエラーになる。

対処:
1. `:Lazy sync` でプラグインをインストールする
2. Neovim を再起動する

`treesitter.lua` の config 関数は `pcall` でガードされているため、
インストール後は再発しない。

---

### 起動時に `require('lspconfig') "framework" is deprecated` が出る

nvim-lspconfig v2 以降では `require("lspconfig").server.setup()` パターンが非推奨になった。
`vim.lsp.config()` + `vim.lsp.enable()` を使う新 API に移行すると警告が消える。

この設定では既に新 API に移行済みのため通常は出ない。
もし出る場合は `lua/lsp/` 配下のファイルが旧 API を使っていないか確認する:

```lua
-- 旧 API（非推奨・警告が出る）
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({ ... })

-- 新 API（推奨）
vim.lsp.config("lua_ls", { ... })
vim.lsp.enable("lua_ls")
```

---

### 起動時に「依存ツール確認」の通知が出る

Neovim 起動 1.5 秒後に未インストールのツールを通知する仕組みが入っている。
通知に表示されたコマンドをターミナルで実行してインストールする:

| ツール | インストールコマンド | 用途 |
|--------|-------------------|------|
| `rg` | `brew install ripgrep` | `<Leader>fg` 全文検索 |
| `fd` | `brew install fd` | `<Leader>ff` ファイル検索の高速化 |
| `gh` | `brew install gh && gh auth login` | `<Leader>po` PR レビュー |

インストール後は Neovim を再起動すれば通知は出なくなる。

### Telescope live_grep（`<Leader>fg`）が動かない

ripgrep が PATH に存在しないことが原因。確認と対処:

```sh
rg --version          # インストール確認
which rg              # バイナリの場所確認
brew install ripgrep  # インストール
```

Homebrew でインストール済みでも PATH に `/opt/homebrew/bin` がない場合は
`lua/config/options.lua` の以下の設定が自動で補完する:

```lua
local homebrew = "/opt/homebrew/bin"
if vim.fn.isdirectory(homebrew) == 1 and not vim.env.PATH:find(homebrew, 1, true) then
  vim.env.PATH = homebrew .. ":" .. vim.env.PATH
end
```

### Neovim 起動時にエラーが出る

```
:checkhealth         → 環境全体のヘルスチェック
:Lazy                → プラグインの状態確認
:messages            → 直近のエラーメッセージを確認
```

### LSP が動かない

```
:LspInfo             → LSP が起動しているか確認
:Mason               → サーバーがインストールされているか確認（✓ = OK）
:LspRestart          → LSP を再起動
:LspLog              → エラーログを確認
```

### `:LspInfo` で "No active clients" と表示される

以下のいずれかが原因の可能性がある:

1. **ファイルタイプが一致していない** — `:LspInfo` をダッシュボードや空バッファから開いている。`.lua`・`.rb`・`.ts` ファイルを開いてから実行する。

2. **stylua が LSP として誤登録されている** — `lsp.lua` の handlers に `stylua` フィルターが入っていない古い設定が残っている。Neovim を再起動して解消するか `:Lazy sync` を実行する。

3. **root_dir が見つからない** — TypeScript LSP は `tsconfig.json` や `package.json` を起点にする。`front/` ディレクトリからファイルを開いているか確認する。worktree の場合は `cd front && npm install` も確認する。

**診断手順**:
```
:LspLog   → エラーログでサーバー起動失敗の原因を確認
:LspInfo  → 開いているファイルに対してアクティブなクライアントを確認
```

---

### `@c-fo/vibes` や `@c-fo/standard-ui` で `gd` が効かない

内部ライブラリの定義にジャンプするには `node_modules` のインストールが必要。

```sh
cd front && npm install   # front/ ディレクトリで実行
```

インストール後に `:LspRestart` で ts_ls を再起動する。

worktree 環境では、新しく作成した worktree ごとに `npm install` が必要（symlink ではなく実体が必要）。

インストール済みでもジャンプできない場合:
1. `tsconfig.json` の `paths` または `compilerOptions.baseUrl` を確認する
2. `@c-fo/vibes` がワークスペースパッケージの場合は `front/package.json` の `workspaces` 設定を確認する
3. `:LspLog` でモジュール解決のエラーを確認する

### `gd` で `index.mjs` に飛んでしまう / 「No LSP Definitions found」が出る

ts_ls が外部ライブラリのバンドルファイルをソース定義として返している状態。

まず `:LspInfo` を開いて `Active Clients` に `ts_ls` が表示されているか確認する。

表示されていない場合: `lua/lsp/typescript.lua` の `root_dir` が誤った形式になっている可能性がある。

```lua
-- 正しい形式（Neovim 0.11 の vim.lsp.config が要求するコールバック形式）
root_dir = function(bufnr, on_dir)
  on_dir(vim.fs.root(bufnr, { "tsconfig.json", "package.json", ".git" }))
end,

-- 誤り: return するだけで on_dir を呼ばないため LSP が起動しない
root_dir = function(fname)
  return vim.fs.root(fname, { "tsconfig.json" })
end,
```

`root_markers` は `nvim-lspconfig` のデフォルト `root_dir` が存在すると無視されるため、
`root_dir` をコールバック形式で明示的に上書きしないと効かない。

ts_ls は起動しているのに外部ライブラリの `gd` が「No LSP Definitions found」になる場合:
Telescope 経由の `lsp_definitions` ではなく `client:request("textDocument/definition", params, ...)` で
同じカーソル位置の params を直接渡すと `.d.ts` が返る（`typescript.lua` の実装参照）。

### プラグインが動かない

```
:Lazy                → プラグインがインストールされているか確認
:Lazy sync           → 再インストール・更新
```

### キーバインドが効かない

```
:verbose map <Leader>x   → そのキーに何が割り当てられているか確認
:checkhealth which-key   → which-key の状態確認
```

プラグインの `lazy = true` 設定によって未ロードの場合、
`keys` または `cmd` トリガーを使えばキーを押した時にロードされる。

### `<Leader>ob` 等の Obsidian キーが効かない

Obsidian プラグインが CFO-Alpha などの別リポジトリでロードされていない可能性がある。
`obsidian.lua` の `cmd = { ... }` に対象コマンドが列挙されていれば、
`:ObsidianNew` 等を実行するか `<Leader>ob` を押した時に自動でロードされる。
動かない場合は `:checkhealth obsidian` で確認する。

### `<Leader>po` 等の GitHub PR キーが動かない

`gh` CLI のインストールとログインが必要:

```sh
brew install gh
gh auth login
```

ログイン後に Neovim を再起動すると octo.nvim が正常に動作する。

### プラグインが競合・エラーを起こす

1. `:Lazy` を開いてエラーが出ているプラグインを確認する（赤くなっている）
2. `l` を押すとエラーログを確認できる
3. 競合するプラグインの設定ファイルを特定して修正する
4. `:Lazy reload プラグイン名` で単体再読み込みを試みる
5. それでも解決しない場合は `:Lazy clean` → `:Lazy sync` でクリーンインストール

### 特定プラグインを一時的に無効化したい

`lua/plugins/` 内の該当ファイルを開き、プラグイン定義に `enabled = false` を追加する:

```lua
return {
  {
    "author/plugin-name",
    enabled = false,   -- 追加
    ...
  },
}
```

Neovim を再起動すると無効化される。

### conform.nvim（フォーマット）が動かない

```
:ConformInfo   → フォーマッターの状態確認
```

Ruby（rubocop）が動かない場合:
- カレントディレクトリに `Gemfile` がないと rubocop は起動しない（require_cwd = true のため）
- `bundle exec rubocop --version` でインストール確認
- `bundle install` で依存関係を解決してから再試行

TypeScript（prettier）が動かない場合:
- `npm install -g prettier` でグローバルインストール
- またはプロジェクト内 `./node_modules/.bin/prettier` が使われる

Lua（stylua）が動かない場合:
- `:Mason` を開いて `stylua` が ✓ になっているか確認
- なっていない場合は `:MasonInstall stylua` を実行

### obsidian.nvim が動かない

```
:checkhealth obsidian   → 詳細な状態確認
```

Vault 外からでも `<Leader>of` 等を押せばプラグインがロードされる。
動かない場合はそのキーに `cmd` トリガーが正しく設定されているか確認する。

### neo-tree で `<Leader>` キーが効かない

neo-tree にフォーカスがある時は `<Leader>` キーが効かない。
`Ctrl+l` でエディタ側にフォーカスを移してから操作する。

### neo-tree のフィルターが解除できない

`/` で fuzzy_finder を起動後、`Esc` または `q` でキャンセルできる。
フィルター適用後（ノーマル状態）に `Esc` を押すとフィルターがクリアされる。

---

## このドキュメント自体を更新する場合

このドキュメント（`OVERVIEW.md`）は設定を変更するたびに更新が必要。
更新後は chezmoi で管理する。

```sh
# 更新したドキュメントを chezmoi に反映
chezmoi re-add ~/.config/nvim/OVERVIEW.md
chezmoi git -- add -A
chezmoi git -- commit -m "OVERVIEW.md を更新"
```
