return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      -- focus: 閉じていれば開いてフォーカス / 開いていればフォーカスを移す（閉じない）
      -- 閉じたい場合は neo-tree 内で q を押す
      { "<Leader>e", ":Neotree focus<CR>",   desc = "エクスプローラーにフォーカス" },
      { "<Leader>o", ":Neotree reveal<CR>",  desc = "現在ファイルをエクスプローラーで表示" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          width = 70,
          mappings = {
            -- Leader との衝突を避けるため Space を無効化
            ["<Space>"] = "none",
            -- vim スタイルの操作
            ["h"] = "close_node",
            ["l"] = "open",
          },
        },
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
        },
        event_handlers = {
          -- ファイルを開いたらエクスプローラーにフォーカスを戻さない
          {
            event = "file_opened",
            handler = function()
              require("neo-tree.command").execute({ action = "close" })
            end,
          },
        },
      })
    end,
  },
}
