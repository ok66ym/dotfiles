-- netrw を最初に無効化（どのプラグインよりも先に設定する必要あり）
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- mapleader / maplocalleader は lazy.nvim の setup より前に設定する必要がある
-- （プラグインの keys トリガーが <Leader> を参照するため）
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
