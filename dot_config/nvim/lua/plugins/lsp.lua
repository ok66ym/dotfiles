return {
  -- nvim-lspconfig: サーバー定義（コマンド・デフォルト設定）を提供
  { "neovim/nvim-lspconfig" },

  -- stylua など LSP 以外の Mason ツールを自動インストールする
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",  -- Lua フォーマッター（conform.nvim で使用・LSP サーバーではない）
        },
        auto_update  = false,
        run_on_start = true,
        start_delay  = 3000,
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd   = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons  = {
            package_installed   = "✓",
            package_pending     = "➜",
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
      -- 1. 全サーバー共通の capabilities / on_attach を設定
      require("lsp").setup()

      -- 2. サーバー別の追加設定（on_attach の明示的な上書きを含む）
      require("lsp.lua_ls")()
      require("lsp.typescript")()

      -- 3. mason-lspconfig セットアップ
      --    automatic_enable にホワイトリストを渡すことで、
      --    stylua など LSP でないツールを誤って有効化しない。
      --    ※ handlers はこのバージョンの mason-lspconfig では未サポートのため使わない
      local lsp_servers = { "lua_ls", "ruby_lsp", "ts_ls" }

      require("mason-lspconfig").setup({
        ensure_installed      = lsp_servers,
        automatic_installation = true,
        -- whitelist 形式: このリストのサーバーだけを vim.lsp.enable() する
        automatic_enable      = lsp_servers,
      })

      -- 4. 診断表示の設定
      require("lsp").setup_diagnostics()

      -- 5. BufReadPre 中に enable が走っても当該バッファの FileType が
      --    まだ設定されていない場合があるため、スケジュール後に再トリガーする
      vim.schedule(function()
        local buf = vim.api.nvim_get_current_buf()
        local ft  = vim.bo[buf].filetype
        if ft ~= "" then
          vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
        end
      end)
    end,
  },
}
