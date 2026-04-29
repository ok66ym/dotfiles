return {
  -- 括弧の自動補完（Treesitter と連携）
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({ check_ts = true })
      -- nvim-cmp との連携
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- コメントトグル（gcc: 行コメント / gbc: ブロックコメント）
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("Comment").setup()
    end,
  },

  -- surround 操作
  --   ys{motion}{char}: 追加  cs{old}{new}: 変更  ds{char}: 削除
  --   例: ysiw" → 単語を " で囲む / cs"' → " を ' に変更
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- 高速ジャンプ（s + 2文字でジャンプ先をハイライト）
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,            desc = "Flash: ジャンプ" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,      desc = "Flash: Treesitter ノード選択" },
      { "r", mode = "o",               function() require("flash").remote() end,           desc = "Flash: リモート操作" },
    },
    opts = {},
  },

  -- 診断リスト（LSP エラー・警告の一覧）
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<Leader>d",  ":Trouble diagnostics toggle<CR>",                desc = "診断リスト（全体）" },
      { "<Leader>dd", ":Trouble diagnostics toggle filter.buf=0<CR>",   desc = "診断リスト（現在ファイル）" },
      { "<Leader>ds", ":Trouble symbols toggle focus=false<CR>",        desc = "シンボル一覧" },
      { "<Leader>dl", ":Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP 参照・定義" },
    },
    opts = {},
  },
}
