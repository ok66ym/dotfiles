return {
  {
    "folke/persistence.nvim",
    lazy = false,
    opts = {
      -- buffers と globals を除外:
      --   buffers: ウィンドウに表示していないバッファも保存してしまう
      --   globals: プラグインのグローバル状態が意図せず復元される
      options = { "curdir", "folds", "tabpages", "winpos", "winsize" },
    },
    keys = {
      { "<Leader>qs", function() require("persistence").load() end,                desc = "セッション復元（現在ディレクトリ）" },
      { "<Leader>ql", function() require("persistence").load({ last = true }) end, desc = "最後のセッションを復元" },
      { "<Leader>qd", function() require("persistence").stop() end,                desc = "セッション保存を停止（このセッション）" },
      { "<Leader>qc", function()
          -- 壊れたセッションや不要なファイルが残った時のリセット用
          local session = require("persistence").get()
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
          -- 1. neo-tree を閉じる（neo-tree バッファをセッションに含めない）
          pcall(function()
            require("neo-tree.command").execute({ action = "close" })
          end)

          -- 2. 現在ウィンドウに表示中のバッファを収集する
          local win_bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            win_bufs[vim.api.nvim_win_get_buf(win)] = true
          end

          -- 3. ウィンドウに表示されていない listed バッファを全て削除する
          --    :bd / close_buffer の失敗などで listed のまま残ったバッファを除去し
          --    セッションに「現在表示中のファイルのみ」が保存されるようにする
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if not win_bufs[buf] and vim.fn.buflisted(buf) == 1 then
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end
          end

          -- 4. ディレクトリバッファを削除（nvim . で開いた際の残留バッファ）
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.fn.isdirectory(vim.fn.bufname(buf)) == 1 then
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
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
