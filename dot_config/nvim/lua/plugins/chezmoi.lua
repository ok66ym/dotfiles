return {
  {
    "xvzc/chezmoi.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    -- ソースディレクトリのファイルを開いた時に自動ロード
    event = {
      "BufReadPre " .. vim.fn.expand("~/.local/share/chezmoi") .. "/**",
      "BufNewFile "  .. vim.fn.expand("~/.local/share/chezmoi") .. "/**",
    },
    -- キーバインドでもロード可能にする
    keys = {
      { "<Leader>czf", desc = "chezmoi: 管理ファイル一覧（Telescope）" },
      { "<Leader>czd", desc = "chezmoi: diff（全体）" },
      { "<Leader>czD", desc = "chezmoi: 現在ファイルの diff" },
      { "<Leader>cza", desc = "chezmoi: 現在ファイルを add" },
      { "<Leader>czp", desc = "chezmoi: apply" },
      { "<Leader>czs", desc = "chezmoi: status" },
      { "<Leader>czo", desc = "chezmoi: ソースディレクトリを開く" },
    },
    config = function()
      require("chezmoi").setup({
        edit = { watch = false },
        notification = {
          on_open  = true,
          on_apply = true,
          on_watch = false,
        },
        telescope = { select = { "<CR>" } },
      })
      require("telescope").load_extension("chezmoi")

      local map = vim.keymap.set

      -- diff / status の結果をフロートバッファに表示するヘルパー
      local function show_float(title, content, ft)
        local lines = vim.split(content, "\n")
        while #lines > 0 and lines[#lines] == "" do
          table.remove(lines)
        end
        if #lines == 0 then
          vim.notify(title .. ": 差分なし", vim.log.levels.INFO)
          return
        end
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].filetype = ft or "diff"
        vim.bo[buf].modifiable = false
        vim.keymap.set("n", "q", ":close<CR>", { buffer = buf, silent = true })
        require("snacks").win({
          buf    = buf,
          title  = " " .. title .. " ",
          width  = 0.85,
          height = 0.85,
          border = "rounded",
        })
      end

      -- 管理ファイル一覧（Telescope ピッカー）
      map("n", "<Leader>czf", function()
        require("telescope").extensions.chezmoi.find_files()
      end, { desc = "chezmoi: 管理ファイル一覧（Telescope）" })

      -- 全体 diff をフロートバッファで表示
      map("n", "<Leader>czd", function()
        local out = vim.fn.system("chezmoi diff --color=false 2>&1")
        show_float("chezmoi diff", out, "diff")
      end, { desc = "chezmoi: diff（全体）" })

      -- 現在ファイルの diff
      map("n", "<Leader>czD", function()
        local file = vim.fn.expand("%:p")
        local name = vim.fn.fnamemodify(file, ":t")
        local out  = vim.fn.system("chezmoi diff --color=false " .. vim.fn.shellescape(file) .. " 2>&1")
        show_float("chezmoi diff: " .. name, out, "diff")
      end, { desc = "chezmoi: 現在ファイルの diff" })

      -- 現在ファイルをソース状態に取り込む（destination → source）
      map("n", "<Leader>cza", function()
        local file = vim.fn.expand("%:p")
        local name = vim.fn.fnamemodify(file, ":t")
        local out  = vim.fn.system("chezmoi add " .. vim.fn.shellescape(file) .. " 2>&1")
        if vim.v.shell_error == 0 then
          vim.notify("chezmoi add: " .. name .. " を追加しました", vim.log.levels.INFO)
        else
          vim.notify("chezmoi add 失敗:\n" .. out, vim.log.levels.ERROR)
        end
      end, { desc = "chezmoi: 現在ファイルを add" })

      -- ソース状態をホームに反映（source → destination）
      map("n", "<Leader>czp", function()
        local out = vim.fn.system("chezmoi apply -v 2>&1")
        if vim.v.shell_error == 0 then
          local changed = vim.tbl_filter(
            function(l) return l ~= "" end,
            vim.split(out, "\n")
          )
          if #changed > 0 then
            vim.notify("chezmoi apply:\n" .. table.concat(changed, "\n"), vim.log.levels.INFO)
          else
            vim.notify("chezmoi apply: 変更なし", vim.log.levels.INFO)
          end
        else
          vim.notify("chezmoi apply 失敗:\n" .. out, vim.log.levels.ERROR)
        end
      end, { desc = "chezmoi: apply" })

      -- 変更サマリーをフロートバッファで表示
      map("n", "<Leader>czs", function()
        local out = vim.fn.system("chezmoi status 2>&1")
        if vim.v.shell_error ~= 0 then
          vim.notify("chezmoi status 失敗:\n" .. out, vim.log.levels.ERROR)
          return
        end
        show_float("chezmoi status", out, "diff")
      end, { desc = "chezmoi: status" })

      -- ソースディレクトリをトグル
      -- picker にフォーカスがある → 閉じて neo-tree を復元
      -- エディタ/neo-tree にフォーカスがある → picker を開く（既存は閉じてから）
      map("n", "<Leader>czo", function()
        local sidebar = require("utils.sidebar")
        if vim.bo[vim.api.nvim_get_current_buf()].filetype:match("^snacks_picker") then
          sidebar.restore_neotree()
          return
        end
        sidebar.close_snacks_picker()
        pcall(function()
          require("neo-tree.command").execute({ action = "close" })
        end)
        local source = vim.fn.system("chezmoi source-path"):gsub("\n$", "")
        require("snacks").picker.explorer({
          cwd   = source,
          title = " chezmoi source ",
        })
      end, { desc = "chezmoi: ソースディレクトリをトグル" })
    end,
  },
}
