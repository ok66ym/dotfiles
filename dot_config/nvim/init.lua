-- netrw を最初に無効化（どのプラグインよりも先に設定する必要あり）
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
