vim.g.mapleader = " "

-- インサートモードを抜ける
vim.keymap.set('i', 'jj', '<Esc>', { silent = true })

-- VSCode限定のキー設定があればここに書く
if vim.g.vscode then
    -- 例: スペース + f でファイル検索を開く(VSCodeの機能)
    -- vim.keymap.set('n', '<Leader>f', "<cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")
    -- 挿入モード(i)で jj を Esc にマッピング
    vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
    -- VSCodeでjjをEscにマッピングするには、以下の遅延時間が限界
    vim.opt.timeoutlen = 500
end
