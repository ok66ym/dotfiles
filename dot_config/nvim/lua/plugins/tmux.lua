return {
  {
    "christoomey/vim-tmux-navigator",
    -- Neovim 起動直後から使えるようにする
    event = "VeryLazy",
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>",  desc = "左ペインへ（Neovim/tmux 統合）" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>",  desc = "下ペインへ（Neovim/tmux 統合）" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>",    desc = "上ペインへ（Neovim/tmux 統合）" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "右ペインへ（Neovim/tmux 統合）" },
    },
    init = function()
      -- tmux 側の is_vim チェックで正しく認識させる
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },
}
