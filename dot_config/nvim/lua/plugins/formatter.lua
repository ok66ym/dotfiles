return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<Leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "フォーマット",
      },
    },
    opts = {
      formatters_by_ft = {
        ruby  = { "rubocop" },
        eruby = { "rubocop" },
        typescript      = { "prettier" },
        typescriptreact = { "prettier" },
        javascript      = { "prettier" },
        javascriptreact = { "prettier" },
        json  = { "prettier" },
        css   = { "prettier" },
        lua   = { "stylua" },
      },
      -- 保存時に自動フォーマット（タイムアウト 5 秒、LSP にフォールバック）
      format_on_save = {
        timeout_ms   = 5000,
        lsp_fallback = true,
      },
      formatters = {
        -- bundle exec rubocop を使う（Gemfile があるディレクトリのみ実行）
        rubocop = {
          command = "bundle",
          args = {
            "exec", "rubocop",
            "--autocorrect-all",
            "--format", "quiet",
            "--stderr",
            "--stdin", "$FILENAME",
          },
          stdin = true,
          -- require を関数でラップして conform インストール後に評価させる
          cwd = function(self, ctx)
            return require("conform.util").root_file({ "Gemfile", ".rubocop.yml" })(self, ctx)
          end,
          require_cwd = true,
        },
      },
    },
  },
}
