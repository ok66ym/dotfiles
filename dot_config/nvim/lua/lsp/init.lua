local M = {}

-- バッファローカルキーバインドを設定（LSP アタッチ時に実行）
-- 外部から参照できるよう M.on_attach として公開する
function M.on_attach(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  -- Telescope 経由で開く（reuse_win=true で既存ウィンドウを再利用）
  vim.keymap.set("n", "gd", function()
    require("telescope.builtin").lsp_definitions({ reuse_win = true })
  end, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  vim.keymap.set("n", "gi", function()
    require("telescope.builtin").lsp_implementations({ reuse_win = true })
  end, opts)
  vim.keymap.set("n", "K",          vim.lsp.buf.hover,        opts)
  vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action,  opts)
  vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename,       opts)
  vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,  opts)
  vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,  opts)
  vim.keymap.set("n", "<Leader>dl", vim.diagnostic.open_float, opts)
end

-- 全サーバー共通の設定を vim.lsp.config('*', ...) で適用する
-- ただし ts_ls は nvim-lspconfig 独自の on_attach を持つため typescript.lua で上書きする
M.setup = function()
  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities = ok
    and cmp_lsp.default_capabilities()
    or vim.lsp.protocol.make_client_capabilities()

  vim.lsp.config("*", {
    capabilities = capabilities,
    on_attach    = M.on_attach,
  })
end

M.setup_diagnostics = function()
  vim.diagnostic.config({
    virtual_text    = { prefix = "●" },
    signs           = true,
    underline       = true,
    update_in_insert = false,
    severity_sort   = true,
    float           = { border = "rounded", source = "always" },
  })

  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

return M
