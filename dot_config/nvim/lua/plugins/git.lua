return {
  -- Gitサイン（変更行・追加行・削除行をガターに表示）
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
          untracked    = { text = "┆" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- ハンク移動
          map("n", "]h", gs.next_hunk, { desc = "次の変更ハンク" })
          map("n", "[h", gs.prev_hunk, { desc = "前の変更ハンク" })

          -- ハンク操作
          map("n", "<Leader>gs", gs.stage_hunk,      { desc = "ハンクをステージ" })
          map("n", "<Leader>gr", gs.reset_hunk,      { desc = "ハンクをリセット" })
          map("n", "<Leader>gp", gs.preview_hunk,    { desc = "ハンクのプレビュー" })
          map("n", "<Leader>gb", gs.blame_line,      { desc = "行の Blame" })
          map("n", "<Leader>gd", gs.diffthis,        { desc = "Diff 表示" })
          map("n", "<Leader>gS", gs.stage_buffer,    { desc = "バッファ全体をステージ" })
          map("n", "<Leader>gR", gs.reset_buffer,    { desc = "バッファ全体をリセット" })

          -- ビジュアルモードでのハンク操作
          map("v", "<Leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "選択範囲をステージ" })
          map("v", "<Leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "選択範囲をリセット" })
        end,
      })
    end,
  },

  -- Git 操作（:Git コマンド）
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gwrite", "Gread", "Gdiffsplit", "GBrowse" },
    keys = {
      { "<Leader>gf", ":Git<CR>", desc = "Git status (fugitive)" },
    },
  },

  -- 変更差分・ファイル履歴のビューア
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<Leader>gv", "<cmd>DiffviewOpen<cr>",           desc = "差分ビュー（全変更ファイル）" },
      { "<Leader>gh", "<cmd>DiffviewFileHistory %<cr>",  desc = "現在ファイルの履歴" },
      { "<Leader>gH", "<cmd>DiffviewFileHistory<cr>",    desc = "リポジトリ全体の履歴" },
    },
    config = function()
      local actions = require("diffview.actions")
      require("diffview").setup({
        keymaps = {
          view = {
            { "n", "q", actions.close, { desc = "diffview を閉じる" } },
          },
          file_panel = {
            { "n", "q", actions.close, { desc = "diffview を閉じる" } },
          },
          file_history_panel = {
            { "n", "q", actions.close, { desc = "diffview を閉じる" } },
          },
        },
      })
    end,
  },
}
