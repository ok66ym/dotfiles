return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- 初回インストール前（:Lazy sync 前）に呼ばれた場合はスキップ
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then return end

      configs.setup({
        ensure_installed = {
          "lua", "vim", "vimdoc",
          "ruby",
          "javascript", "typescript", "tsx",
          "json", "jsonc",
          "html", "css",
          "yaml", "toml",
          "markdown", "markdown_inline",
          "bash",
        },
        highlight    = { enable = true },
        indent       = { enable = true },
        auto_install = true,
      })
    end,
  },
}
