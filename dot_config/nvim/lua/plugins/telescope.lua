return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    cmd = "Telescope",
    keys = {
      { "<Leader>ff", "<cmd>Telescope find_files<CR>",                  desc = "ファイル検索" },
      { "<Leader>fg", "<cmd>Telescope live_grep<CR>",                   desc = "全文検索" },
      { "<Leader>fb", "<cmd>Telescope buffers<CR>",                     desc = "バッファ一覧" },
      { "<Leader>fr", "<cmd>Telescope oldfiles<CR>",                    desc = "最近のファイル" },
      { "<Leader>fh", "<cmd>Telescope help_tags<CR>",                   desc = "ヘルプ検索" },
      { "<Leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<CR>",   desc = "バッファ内検索" },
      { "<Leader>fs", "<cmd>Telescope lsp_document_symbols<CR>",        desc = "シンボル検索" },
      { "<Leader>fd", "<cmd>Telescope diagnostics<CR>",                 desc = "診断一覧" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          -- Ctrl+j/k でリスト移動（vim スタイル）
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
              ["<C-u>"] = false,  -- デフォルトのプレビュースクロールを解除
            },
          },
          file_ignore_patterns = {
            "node_modules/", ".git/", "%.lock$", "sorbet/rbi/",
          },
          layout_strategy = "horizontal",
          layout_config = { preview_width = 0.55 },
        },
      })

      telescope.load_extension("fzf")
    end,
  },
}
