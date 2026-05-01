-- mapleader / maplocalleader は init.lua で設定済み
local map = vim.keymap.set
local sidebar = require("utils.sidebar")

-- インサートモードを抜ける
map("i", "jj", "<Esc>", { silent = true })

-- Ctrl+a はtmux prefix に取られるため + でインクリメント
map("n", "+", "<C-a>", { desc = "インクリメント" })
-- tmux 内での Neovim サスペンドを防ぐ
map({ "n", "i", "v" }, "<C-z>", "<Nop>", { silent = true })

-- ウィンドウ移動（vim-tmux-navigator で上書きされる）
map("n", "<C-h>", "<C-w>h", { desc = "左ウィンドウへ" })
map("n", "<C-j>", "<C-w>j", { desc = "下ウィンドウへ" })
map("n", "<C-k>", "<C-w>k", { desc = "上ウィンドウへ" })
map("n", "<C-l>", "<C-w>l", { desc = "右ウィンドウへ" })

-- 検索ハイライト解除
map("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- バッファ操作
map("n", "<Leader>bn", ":bnext<CR>", { desc = "次のバッファ" })
map("n", "<Leader>bp", ":bprev<CR>", { desc = "前のバッファ" })

-- Neovim を終了する（全ウィンドウを保存して閉じる）
-- ZZ のデフォルト動作はカレントウィンドウだけ閉じるため、neo-tree が残って2回必要になる
-- wqa で全ウィンドウを一括終了することで VimLeavePre が正しいタイミングで発火し
-- セッションに「現在開いているファイル」が正確に保存される
map("n", "ZZ", function()
  local ok, err = pcall(vim.cmd, "wqa")
  if not ok then
    vim.notify(tostring(err), vim.log.levels.WARN)
  end
end, { desc = "全バッファを保存して終了" })

-- バッファを閉じる（:bd / <Leader>bd 共通ロジック）
local function close_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype == "neo-tree" then
    vim.notify("ファイルバッファにフォーカスしてから閉じてください", vim.log.levels.WARN)
    return
  end
  -- 未保存の変更があれば先に警告して中断（削除前にチェックすることで確実に検出）
  if vim.bo[bufnr].modified then
    vim.notify("未保存の変更があります。:w で保存してから閉じてください", vim.log.levels.WARN)
    return
  end
  -- 切り替え先: listed かつ名前あり かつ neo-tree でないバッファを探す
  local target = nil
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= bufnr
      and vim.fn.buflisted(b) == 1
      and vim.fn.bufname(b) ~= ""
      and vim.bo[b].filetype ~= "neo-tree"
    then
      target = b
      break
    end
  end
  if target then
    vim.api.nvim_set_current_buf(target)
  else
    vim.cmd("enew")
    vim.bo.buflisted = false
  end
  -- modified は上で確認済みなので force=true で確実に削除する
  pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
end

map("n", "<Leader>bd", close_buffer, { desc = "バッファを閉じる" })

-- :bd / :bdelete をスマート関数にリダイレクト
vim.api.nvim_create_user_command("Bd", close_buffer, {})
vim.cmd("cnoreabbrev bd Bd")
vim.cmd("cnoreabbrev bdelete Bd")

-- ウィンドウサイズ調整
map("n", "<Leader>w=", "<C-w>=", { desc = "ウィンドウを均等割り" })
map("n", "<Leader>wm", "<C-w>|<C-w>_", { desc = "ウィンドウを最大化" })

-- 行移動（折り返し考慮）
map({ "n", "v" }, "j", "gj", { silent = true })
map({ "n", "v" }, "k", "gk", { silent = true })

-- 選択範囲を上下に移動 (Meta + j/k)
map("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "選択範囲を下に移動" })
map("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "選択範囲を上に移動" })

-- ノーマルモードでも1行移動 (Meta + j/k)
map("n", "<M-j>", ":m .+1<CR>==", { desc = "1行下に移動" })
map("n", "<M-k>", ":m .-2<CR>==", { desc = "1行上に移動" })

-- インデント維持したままビジュアル選択を継続
map("v", "<", "<gv")
map("v", ">", ">gv")

-- 貼り付け時に選択範囲を捨てない
map("v", "p", '"_dP')

-- Telescope
map("n", "<Leader>ff", "<cmd>Telescope find_files<CR>", { desc = "ファイル検索" })
map("n", "<Leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "全文検索" })
map("n", "<Leader>fb", "<cmd>Telescope buffers<CR>", { desc = "バッファ一覧" })
map("n", "<Leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "最近のファイル" })
map("n", "<Leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "ヘルプ検索" })
map("n", "<Leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "バッファ内検索" })

-- ファイルエクスプローラー
-- <Leader>e: 「アクティブなサイドバー」↔ エディタのフォーカスをトグル
--   エディタにいる + snacks picker が開いている → snacks picker にフォーカス
--   エディタにいる + snacks picker が閉じている → neo-tree にフォーカス（なければ開く）
--   neo-tree にいる      → エディタに戻る
--   snacks picker にいる → エディタに戻る（picker は開いたまま）
map("n", "<Leader>e", function()
  local ft = vim.bo[vim.api.nvim_get_current_buf()].filetype
  if ft == "neo-tree" then
    -- neo-tree → エディタ側の最初のウィンドウへ移動
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local wft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
      local cfg = vim.api.nvim_win_get_config(win)
      if wft ~= "neo-tree" and cfg.relative == "" then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  elseif ft:match("^snacks_picker") then
    -- snacks picker → エディタ側の最初のウィンドウへ移動（picker は開いたまま）
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local wft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
      local cfg = vim.api.nvim_win_get_config(win)
      if not wft:match("^snacks_picker") and wft ~= "neo-tree" and cfg.relative == "" then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  else
    -- エディタ → snacks picker が開いていればそちらへフォーカス、なければ neo-tree を開く
    if sidebar.has_snacks_picker() then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
        if ok and vim.bo[buf].filetype == "snacks_picker_list" then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
    else
      local file = vim.fn.expand("%:p")
      local cwd  = vim.fn.getcwd()
      -- 現在のファイルが cwd 外にある時だけ dir を指定して
      -- follow_current_file の「File not in cwd」プロンプトを抑制する
      -- cwd 内の通常ファイルは標準の Neotree focus を使う（余分な navigate を避ける）
      if file ~= "" and vim.fn.isdirectory(file) == 0
          and not vim.startswith(file, cwd .. "/") and file ~= cwd then
        pcall(require("neo-tree.command").execute, { action = "focus", dir = cwd })
      else
        vim.cmd("Neotree focus")
      end
    end
  end
end, { desc = "アクティブなサイドバー ↔ エディタ フォーカス切り替え" })

-- <Leader>E: 編集中のファイルを neo-tree のツリー内でハイライト表示する
-- VS Code の「エクスプローラーで表示」相当。エディタにフォーカスがある時に使う。
map("n", "<Leader>E", ":Neotree reveal<CR>", { desc = "現在ファイルをツリーで表示" })

-- lazygit（snacks.nvim）
map("n", "<Leader>gg", function() require("snacks").lazygit() end, { desc = "lazygit" })
map("n", "<Leader>gl", function() require("snacks").lazygit.log() end, { desc = "lazygit log" })
map("n", "<Leader>gL", function() require("snacks").lazygit.log_file() end, { desc = "lazygit 現在ファイルのlog" })

-- ターミナル（snacks.nvim）
map("n", "<Leader>t", function() require("snacks").terminal() end, { desc = "ターミナルをトグル" })

-- 通知履歴（消えたエラー通知を再確認する）
map("n", "<Leader>n", function() require("snacks").notifier.show_history() end, { desc = "通知履歴" })

-- Trouble（診断リスト）
map("n", "<Leader>d",  ":Trouble diagnostics toggle<CR>", { desc = "診断リスト" })
map("n", "<Leader>dd", ":Trouble diagnostics toggle filter.buf=0<CR>", { desc = "現在ファイルの診断" })

-- ドキュメントをフロートウィンドウで表示（q で閉じる）
local function open_doc(path)
  local fpath = vim.fn.expand(path)
  if vim.fn.filereadable(fpath) == 0 then
    vim.notify("ファイルが見つかりません: " .. fpath, vim.log.levels.ERROR)
    return
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(fpath))
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  vim.keymap.set("n", "q", ":close<CR>", { buffer = buf, silent = true })
  require("snacks").win({ buf = buf, width = 0.8, height = 0.9, border = "rounded" })
end
map("n", "<Leader>?o", function() open_doc("~/.config/nvim/OVERVIEW.md") end,               { desc = "概要・設定修正ガイド" })
map("n", "<Leader>?r", function() open_doc("~/.config/nvim/TUTORIAL.md") end,               { desc = "チュートリアル インデックス" })
map("n", "<Leader>?1", function() open_doc("~/.config/nvim/TUTORIAL_01_vim_basics.md") end,  { desc = "チュートリアル 1: Vim 基本" })
map("n", "<Leader>?2", function() open_doc("~/.config/nvim/TUTORIAL_02_files.md") end,       { desc = "チュートリアル 2: ファイル操作" })
map("n", "<Leader>?3", function() open_doc("~/.config/nvim/TUTORIAL_03_code.md") end,        { desc = "チュートリアル 3: コード操作" })
map("n", "<Leader>?4", function() open_doc("~/.config/nvim/TUTORIAL_04_environment.md") end, { desc = "チュートリアル 4: 環境操作" })
map("n", "<Leader>?5", function() open_doc("~/.config/nvim/TUTORIAL_05_github_pr.md") end,    { desc = "チュートリアル 5: GitHub PR" })
map("n", "<Leader>?6", function() open_doc("~/.config/nvim/TUTORIAL_06_obsidian.md") end,     { desc = "チュートリアル 6: Obsidian" })
map("n", "<Leader>?u", function() open_doc("~/.config/nvim/USAGE.md") end,                    { desc = "Neovim USAGE.md" })
map("n", "<Leader>?p", function() open_doc("~/.config/nvim/PLUGINS.md") end,                  { desc = "Neovim PLUGINS.md" })
map("n", "<Leader>?b", function() open_doc("~/.config/nvim/OBSIDIAN.md") end,                 { desc = "Obsidian 操作ガイド" })
map("n", "<Leader>?x", function() open_doc("~/.config/nvim/TROUBLESHOOTING.md") end,          { desc = "トラブルシューティング" })
map("n", "<Leader>?t", function() open_doc("~/.config/ghostty/usage.md") end,                 { desc = "Ghostty + tmux 操作ガイド" })
map("n", "<Leader>?w", function() open_doc("~/.config/tm-wt/README.md") end,                  { desc = "worktree リファレンス" })
map("n", "<Leader>?c", function() open_doc("~/.config/nvim/CHEZMOI.md") end,                  { desc = "chezmoi 操作ガイド" })
