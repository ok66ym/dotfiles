# Neovim 設定 概要・ドキュメントガイド

この環境（Ghostty + tmux + Neovim + Claude Code）の全体構成と、
設定を修正・拡張する方法をまとめたドキュメント。

`<Leader>` = `Space`

---

## ドキュメント一覧

### Neovim 内から開く（`<Leader>?` + キー）

| キー | ファイル | 内容 |
|------|---------|------|
| `<Leader>?o` | `OVERVIEW.md` | このファイル。構成・修正方法のガイド |
| `<Leader>?u` | `USAGE.md` | 全キーバインドの早見表 |
| `<Leader>?p` | `PLUGINS.md` | 導入プラグインの説明・設定・操作方法 |
| `<Leader>?r` | `TUTORIAL.md` | チュートリアルのインデックス |
| `<Leader>?1` | `TUTORIAL_01_vim_basics.md` | Vim 基本（モード・移動・編集・保存） |
| `<Leader>?2` | `TUTORIAL_02_files.md` | ファイル操作（neo-tree・Telescope・バッファ） |
| `<Leader>?3` | `TUTORIAL_03_code.md` | コード操作（LSP・補完・検索・Git） |
| `<Leader>?4` | `TUTORIAL_04_environment.md` | 環境操作（tmux・Claude Code・worktree） |
| `<Leader>?t` | `~/.config/ghostty/usage.md` | Ghostty + tmux 操作ガイド |
| `<Leader>?w` | `~/.config/tm-wt/README.md` | worktree 設定リファレンス |

### tmux 内から開く

```
prefix + ?  → fzf でドキュメントを選択して bat で表示
```

---

## 設定ファイルの構成

```
~/.config/nvim/
├── init.lua                    ← エントリーポイント（最初に読み込まれる）
└── lua/
    ├── config/                 ← Neovim 本体の設定
    │   ├── options.lua         ← 基本設定（行番号・インデント・表示等）
    │   ├── keymaps.lua         ← キーバインド定義
    │   ├── autocmds.lua        ← 自動コマンド
    │   └── lazy.lua            ← プラグインマネージャーの設定
    └── plugins/                ← プラグインの設定（1ファイル = 1テーマ）
        ├── colorscheme.lua     ← テーマ（Dracula）
        ├── treesitter.lua      ← シンタックスハイライト
        ├── snacks.lua          ← lazygit / ターミナル / 通知
        ├── telescope.lua       ← ファジーファインダー
        ├── lsp.lua             ← LSP（言語サーバー）
        ├── cmp.lua             ← 自動補完
        ├── ui.lua              ← lualine / bufferline / which-key
        ├── explorer.lua        ← ファイルエクスプローラー（neo-tree）
        ├── git.lua             ← gitsigns / fugitive
        ├── editor.lua          ← autopairs / Comment / surround / flash / trouble
        └── tmux.lua            ← vim-tmux-navigator
```

### 読み込みの流れ

```
init.lua
  ├── require("config.lazy")    → lazy.nvim を初期化し plugins/ を全て読み込む
  ├── require("config.options") → 基本設定を適用
  ├── require("config.keymaps") → キーバインドを登録
  └── require("config.autocmds")→ 自動コマンドを登録
```

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

**プラグイン追加後の操作**:

```
:Lazy          → プラグイン管理 UI を開く
:Lazy sync     → インストール・更新・クリーンを一括実行
:Lazy update   → 全プラグインを更新
:Lazy clean    → 不要なプラグインを削除
```

---

### LSP の設定を変更する

**ファイル**: `lua/plugins/lsp.lua`

#### 新しい言語サーバーを追加する

1. `:Mason` を開いて言語サーバー名を確認（例: `pyright`, `gopls` 等）
2. `ensure_installed` に追加:

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

3. `lspconfig.サーバー名.setup({})` を追加:

```lua
lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
```

#### 全 LSP 共通のキーバインドを変更する

`on_attach` 関数内のキーバインド定義を変更する:

```lua
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  -- ここに追加・変更する
end
```

#### LSP の動作確認コマンド

```
:LspInfo      → 現在のファイルに対して起動している LSP を確認
:Mason        → LSP サーバーのインストール状況
:LspRestart   → LSP を再起動
:LspLog       → LSP のログを確認（エラー調査に使う）
```

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

---

### プラグインの見た目・動作を変更する

**例: neo-tree の幅を変更する**（ファイル: `lua/plugins/explorer.lua`）

```lua
window = {
  width = 70,  -- 列数で指定（デフォルト: 30）
},
```

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

### neo-tree で `<Leader>` キーが効かない

neo-tree にフォーカスがある時は `<Leader>` キーが効かない。
`Ctrl+l` でエディタ側にフォーカスを移してから操作する。

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
