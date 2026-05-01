local M = {}

-- snacks picker のサイドバーウィンドウ（list / preview / input）をすべて閉じる
function M.close_snacks_picker()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
    if ok then
      local ft = vim.bo[buf].filetype
      if ft:match("^snacks_picker") then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end
end

-- snacks picker のサイドバーが開いているか確認
function M.has_snacks_picker()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
    if ok and vim.bo[buf].filetype == "snacks_picker_list" then
      return true
    end
  end
  return false
end

-- snacks picker を閉じて neo-tree を表示する（サイドバー切り替え用）
-- dir を明示することで follow_current_file の「File not in cwd」プロンプトを抑制する
function M.restore_neotree()
  M.close_snacks_picker()
  vim.schedule(function()
    require("neo-tree.command").execute({ action = "show", dir = vim.fn.getcwd() })
  end)
end

return M
