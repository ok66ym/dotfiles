local vim = vim

-- Neotree
vim.keymap.set("n", "nn", ":Neotree toggle<cr>", { noremap = true, silent = true, desc = "Neotree Toggle" })
vim.keymap.set(
    "n",
    "no",
    ":Neotree reveal<cr>:Neotree ~/dotfiles/nvim/<cr>",
    { noremap = true, silent = true, desc = "Neotree reveal" }
)

-- custom keymap
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true })

-- Neotree
vim.keymap.set("n", "nn", ":Neotree toggle<cr>", { noremap = true, silent = true, desc = "Neotree Toggle" })
vim.keymap.set(
    "n",
    "no",
    ":Neotree reveal<cr>:Neotree ~/.config/nvim/<cr>",
    { noremap = true, silent = true, desc = "Neotree reveal" }
)

-- custom keymap
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true })
