-- Lua 言語サーバー（Neovim 設定ファイル向け）
return function()
  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace   = { checkThirdParty = false },
        telemetry   = { enable = false },
      },
    },
  })
end
