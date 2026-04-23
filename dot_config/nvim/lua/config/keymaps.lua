vim.g.mapleader = " "

-- インサートモードを抜ける
vim.keymap.set('i', 'jj', '<Esc>', { silent = true })
-- キーシーケンスの待機時間を200ミリ秒に変更 (デフォルトは1000)
vim.opt.timeoutlen = 200

-- VSCode限定のキー設定があればここに書く
if vim.g.vscode then
    -- 例: スペース + f でファイル検索を開く(VSCodeの機能)
    -- vim.keymap.set('n', '<Leader>f', "<cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")
end
