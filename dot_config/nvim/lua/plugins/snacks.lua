return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- lazygit 統合
      lazygit = {
        configure = true,
        win = { style = "lazygit" },
      },
      -- フロートターミナル
      terminal = {
        win = {
          position = "float",
          border = "rounded",
          height = 0.8,
          width = 0.8,
        },
      },
      -- 通知
      notifier = {
        enabled = true,
        timeout = 4000,
        style   = "compact",
        level   = vim.log.levels.INFO,
      },
      -- 通知履歴ウィンドウのキーバインド（q / ESC で閉じる）
      styles = {
        notification_history = {
          border = "rounded",
          keys   = {
            ["q"]     = "close",
            ["<Esc>"] = "close",
          },
        },
      },
      -- インデントガイド
      indent = {
        enabled = true,
        indent = { char = "│" },
        scope = { enabled = true, char = "│" },
      },
      -- スタートスクリーン
      dashboard = {
        sections = {
          { section = "header" },
          {
            section = "keys",
            gap = 1,
            padding = 1,
          },
          { section = "startup" },
        },
      },
      -- snacks explorer（Obsidian vault ブラウズに使用）
      -- replace_netrw = false: neo-tree が nvim . を処理するため置換しない
      explorer = { replace_netrw = false },
      -- 大ファイルを開いた時にプラグインを無効化してパフォーマンスを確保
      bigfile = { enabled = true },
      -- ファイルを高速に開く
      quickfile = { enabled = true },
      -- カーソル下の単語をハイライト
      words = { enabled = true },
      -- スクロール改善
      scroll = { enabled = false },  -- tmux のスクロールと干渉する場合は false
    },
    -- キーマップは keymaps.lua で一元管理
  },
}
