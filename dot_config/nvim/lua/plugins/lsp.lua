return {
  { "neovim/nvim-lspconfig", lazy = true },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending   = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",    -- Lua（Neovim 設定用）
          "ruby_lsp",  -- Ruby
          "ts_ls",     -- TypeScript / JavaScript
        },
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        -- Telescope 経由にすることで、候補選択後にウィンドウが自動で閉じる
        -- reuse_win=true で既存ウィンドウを再利用（不要な分割を防ぐ）
        vim.keymap.set("n", "gd", function()
          require("telescope.builtin").lsp_definitions({ reuse_win = true })
        end, opts)
        vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,                         opts)
        vim.keymap.set("n", "gr",         "<cmd>Telescope lsp_references<CR>",             opts)
        vim.keymap.set("n", "gi", function()
          require("telescope.builtin").lsp_implementations({ reuse_win = true })
        end, opts)
        vim.keymap.set("n", "K",          vim.lsp.buf.hover,                               opts)
        vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action,                         opts)
        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename,                              opts)
        vim.keymap.set("n", "<Leader>cf", function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,                        opts)
        vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,                        opts)
        vim.keymap.set("n", "<Leader>dl", vim.diagnostic.open_float,                       opts)
      end

      -- Lua（Neovim API の型チェック）
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      -- Ruby（ruby-lsp）
      lspconfig.ruby_lsp.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- TypeScript / JavaScript / React
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {
          "typescript", "typescriptreact",
          "javascript", "javascriptreact",
        },
        -- worktree 環境でもプロジェクトルートを正しく検出する
        root_dir = lspconfig.util.root_pattern(
          "tsconfig.json", "jsconfig.json", "package.json", ".git"
        ),
        single_file_support = true,
      })

      -- 診断表示設定
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "always" },
      })

      -- ホバー・シグネチャのボーダー
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    end,
  },
}
