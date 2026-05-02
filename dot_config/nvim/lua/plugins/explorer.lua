return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		-- cmd で :Neotree コマンドが呼ばれた時にロードする
		-- keymaps.lua の <Leader>e トグル関数が vim.cmd("Neotree focus") を呼ぶため必要
		cmd = { "Neotree" },
		keys = {
			-- focus: 閉じていれば開いてフォーカス / 開いていればフォーカスを移す（閉じない）
			-- 閉じたい場合は neo-tree 内で q を押す
			-- <Leader>e はトグル関数として keymaps.lua で定義している
			-- ここでは <Leader>E のみをプラグインのロードトリガーに使用
			{ "<Leader>E", ":Neotree reveal<CR>", desc = "現在ファイルをツリーで表示" },
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = false,
				window = {
					width = 50,
					mappings = {
						-- Leader との衝突を避けるため Space を無効化
						["<Space>"] = "none",
						-- vim スタイルの操作
						["h"] = "close_node",
						["l"] = "open",
						-- フィルター（/ や f で入力した後）を ESC でキャンセル
						["<esc>"] = "clear_filter",
						-- neo-tree 内では <Leader> = Space が他のキーと競合するため単キーで定義
						-- O → Obsidian Vault（<Leader>of の neo-tree 内代替）
						-- Z → chezmoi source（<Leader>czo の neo-tree 内代替、小文字 z = close_all_nodes と区別）
						["O"] = function(_state)
							pcall(require("neo-tree.command").execute, { action = "close" })
							require("snacks").picker.explorer({
								cwd = "/Users/yumac/src/github.com/ok66ym/obsidian",
								title = " Obsidian Vault ",
							})
						end,
						["Z"] = function(_state)
							local source = vim.fn.system("chezmoi source-path"):gsub("\n$", "")
							pcall(require("neo-tree.command").execute, { action = "close" })
							require("snacks").picker.explorer({
								cwd = source,
								title = " chezmoi source ",
							})
						end,
					},
					fuzzy_finder_mappings = {
						-- fuzzy_finder 入力中に ESC または q でキャンセル
						["<esc>"] = "close",
						["q"] = "close",
					},
				},
				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
					},
					follow_current_file = { enabled = true },
					use_libuv_file_watcher = true,
				},
			})
		end,
	},
}
