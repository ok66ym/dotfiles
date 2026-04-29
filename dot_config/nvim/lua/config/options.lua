local opt = vim.opt

-- 行番号
opt.number = true
opt.relativenumber = true

-- クリップボード（システムと同期）
opt.clipboard = "unnamedplus"

-- インデント
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- 表示
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.showmode = false  -- lualine で代替
opt.pumheight = 10
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- 検索
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- 分割方向
opt.splitbelow = true
opt.splitright = true

-- ファイル
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- パフォーマンス（tmux と合わせた設定）
opt.updatetime = 300
opt.timeoutlen = 300

-- フォールドは手動（Treesitter で上書き可）
opt.foldmethod = "manual"
opt.foldenable = false
