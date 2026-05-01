return {
  {
    "folke/persistence.nvim",
    lazy = false,
    opts = {
      -- buffers: 開いていた全バッファを保存・復元する（これがないと最後の1ファイルしか復元されない）
      -- globals は除外: プラグインのグローバル状態が意図せず復元されるのを防ぐ
      options = { "buffers", "curdir", "folds", "tabpages", "winpos", "winsize" },
    },
    keys = {
      { "<Leader>qs", function() require("persistence").load() end,                desc = "セッション復元（現在ディレクトリ）" },
      { "<Leader>ql", function() require("persistence").load({ last = true }) end, desc = "最後のセッションを復元" },
      { "<Leader>qd", function() require("persistence").stop() end,                desc = "セッション保存を停止（このセッション）" },
      { "<Leader>qc", function()
          -- 壊れたセッションや不要なファイルが残った時のリセット用
          -- persistence.nvim の正しい API は current()（get() は存在しない）
          local session = require("persistence").current()
          if session and vim.fn.filereadable(session) == 1 then
            vim.fn.delete(session)
            vim.notify("セッションをクリアしました", vim.log.levels.INFO)
          else
            vim.notify("セッションファイルが見つかりません", vim.log.levels.WARN)
          end
        end, desc = "セッションファイルをクリア" },
    },
    init = function()
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup("persistence_cleanup", { clear = true }),
        callback = function()
          -- 特定ファイルを引数に起動された場合（claude-prompt-edit の一時ファイル等）は
          -- セッションを保存しない。上書きされると直前の作業セッションが失われる。
          local argc = vim.fn.argc(-1)
          local is_dir_arg = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
          if argc ~= 0 and not is_dir_arg then
            pcall(require("persistence").stop)
            return
          end

          -- 1. neo-tree を閉じる（neo-tree バッファをセッションに含めない）
          pcall(function()
            require("neo-tree.command").execute({ action = "close" })
          end)

          -- 2. ディレクトリバッファを削除（nvim . で開いた際の残留バッファ）
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.fn.isdirectory(vim.fn.bufname(buf)) == 1 then
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end
          end

          -- 3. 存在しないファイル・一時ファイル・Obsidian Vault をセッションから除外
          --    /tmp/ 以下の一時ファイル（claude-prompt-edit 等）や Obsidian ノートが
          --    プロジェクトのタブに残るのを防ぐ
          local tmp_patterns = {
            "/tmp/", "/private/tmp/", "/var/folders/",
            "/Users/yumac/src/github.com/ok66ym/obsidian/",
          }
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.fn.buflisted(buf) == 1 then
              local fname = vim.fn.fnamemodify(vim.fn.bufname(buf), ":p")
              if fname ~= "" and vim.fn.isdirectory(fname) == 0 then
                -- ディスク上に存在しないファイルは除外
                local should_remove = vim.fn.filereadable(fname) == 0
                -- 一時ディレクトリのファイルは除外
                if not should_remove then
                  for _, pat in ipairs(tmp_patterns) do
                    if vim.startswith(fname, pat) then
                      should_remove = true
                      break
                    end
                  end
                end
                if should_remove then
                  pcall(vim.api.nvim_buf_delete, buf, { force = true })
                end
              end
            end
          end
        end,
      })

      -- 起動時のセッション復元と neo-tree 表示
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("persistence_auto_restore", { clear = true }),
        callback = function()
          local argc = vim.fn.argc(-1)
          local is_dir_arg = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
          if argc ~= 0 and not is_dir_arg then return end

          require("persistence").load()

          vim.defer_fn(function()
            local has_file = false
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.fn.buflisted(buf) == 1
                and vim.fn.bufname(buf) ~= ""
                and vim.fn.isdirectory(vim.fn.bufname(buf)) == 0
              then
                has_file = true
                break
              end
            end
            if has_file then
              require("neo-tree.command").execute({
                action = "show",
                source = "filesystem",
                dir    = vim.fn.getcwd(),
              })
            end
            vim.cmd("redraw!")
          end, 100)
        end,
        nested = true,
      })
    end,
  },
}
