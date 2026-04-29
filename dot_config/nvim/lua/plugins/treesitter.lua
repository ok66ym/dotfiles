return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
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
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
      })
    end,
  },
}
