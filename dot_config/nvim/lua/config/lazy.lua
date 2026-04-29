local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- plugins/ 配下の全 .lua ファイルを自動で読み込む
    -- 新しいプラグインを追加する時は plugins/ にファイルを置くだけでよい
    { import = "plugins" },
  },
  defaults = { lazy = false },
  install = { colorscheme = { "dracula" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
})
