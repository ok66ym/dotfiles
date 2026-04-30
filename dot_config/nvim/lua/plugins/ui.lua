return {
  -- アイコン（各プラグインの依存）
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "dracula",
          globalstatus = true,
          component_separators = "|",
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "neo-tree", "lazy", "mason" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- バッファライン（タブ表示）
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
      { "<S-h>", ":BufferLineCyclePrev<CR>", desc = "前のバッファ" },
      { "<S-l>", ":BufferLineCycleNext<CR>", desc = "次のバッファ" },
    },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          show_buffer_close_icons = true,
          show_close_icon = false,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, _, diag)
            local icons = { error = " ", warning = " " }
            local ret = {}
            for sev, icon in pairs(icons) do
              if diag[sev] and diag[sev] > 0 then
                table.insert(ret, icon .. diag[sev])
              end
            end
            return table.concat(ret, " ")
          end,
          -- 不要なバッファをタブ一覧に表示しない
          custom_filter = function(buf_number, _)
            local ft   = vim.bo[buf_number].filetype
            local name = vim.fn.bufname(buf_number)
            -- NO NAME（名前なし空バッファ）を非表示
            if name == "" and vim.fn.getbufvar(buf_number, "&modified") == 0 then
              return false
            end
            return ft ~= "neo-tree"
              and ft ~= "netrw"
              and vim.fn.isdirectory(name) == 0
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorer",
              highlight = "Directory",
              text_align = "center",
            },
          },
        },
      })
    end,
  },

  -- キーバインドガイド
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        delay = 500,
        win = { border = "rounded" },
      })
      wk.add({
        { "<Leader>f",  group = "Find (Telescope)" },
        { "<Leader>g",  group = "Git" },
        { "<Leader>c",  group = "Code / Format" },
        { "<Leader>b",  group = "Buffer" },
        { "<Leader>d",  group = "Diagnostics" },
        { "<Leader>w",  group = "Window" },
        { "<Leader>q",  group = "Session" },
        { "<Leader>o",  group = "Obsidian" },
        { "<Leader>?",  group = "Docs (o=概要 / r=tutorial-index / 1-4=tutorial / u=USAGE / p=PLUGINS / b=obsidian / t=tmux / w=worktree)" },
      })
    end,
  },
}
