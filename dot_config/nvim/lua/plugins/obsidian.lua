return {
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		-- Vault 内のファイルを開いた時に自動ロード
		event = {
			"BufReadPre /Users/yumac/src/github.com/ok66ym/obsidian/**.md",
			"BufNewFile /Users/yumac/src/github.com/ok66ym/obsidian/**.md",
		},
		-- cmd トリガーを追加することで、別リポジトリから作業中でも
		-- キーバインドやコマンドでプラグインをロードできる
		cmd = {
			"ObsidianBacklinks",
			"ObsidianExtractNote",
			"ObsidianFollowLink",
			"ObsidianLink",
			"ObsidianLinkNew",
			"ObsidianNew",
			"ObsidianOpen",
			"ObsidianPasteImg",
			"ObsidianQuickSwitch",
			"ObsidianRename",
			"ObsidianSearch",
			"ObsidianTags",
			"ObsidianTemplate",
			"ObsidianToday",
			"ObsidianTomorrow",
			"ObsidianWorkspace",
			"ObsidianYesterday",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "<Leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "Obsidian: バックリンク" },
			{ "<Leader>od", "<cmd>ObsidianToday<CR>", desc = "Obsidian: 今日のノート" },
			-- <Leader>of: Vault をディレクトリツリーで開く（snacks explorer）
			--   - ディレクトリ構造を見ながらノートを探せる
			--   - ノートは real buffer で開く → obsidian.nvim のリンク追跡等が有効
			--   - ノートを閉じると Explorer にフォーカスが戻る
			--   - <Leader>e でエクスプローラー ↔ エディタをトグル
			{
				"<Leader>of",
				function()
					local sidebar = require("utils.sidebar")
					-- picker にフォーカスがある → 閉じて neo-tree を復元
					-- エディタ/neo-tree にフォーカスがある → picker を開く（既存は閉じてから）
					if vim.bo[vim.api.nvim_get_current_buf()].filetype:match("^snacks_picker") then
						sidebar.restore_neotree()
						return
					end
					sidebar.close_snacks_picker()
					local vault = "/Users/yumac/src/github.com/ok66ym/obsidian"
					pcall(function()
						require("neo-tree.command").execute({ action = "close" })
					end)
					require("snacks").picker.explorer({
						cwd = vault,
						title = " Obsidian Vault ",
					})
				end,
				desc = "Obsidian: Vault をディレクトリツリーで開く（トグル）",
			},
			{ "<Leader>og", "<cmd>ObsidianSearch<CR>", desc = "Obsidian: 全文検索" },
			{ "<Leader>ol", "<cmd>ObsidianFollowLink<CR>", desc = "Obsidian: リンクを開く" },
			{ "<Leader>on", "<cmd>ObsidianNew<CR>", desc = "Obsidian: 新規ノート" },
			{ "<Leader>oo", "<cmd>ObsidianOpen<CR>", desc = "Obsidian: GUI アプリで開く" },
			{ "<Leader>op", "<cmd>ObsidianPasteImg<CR>", desc = "Obsidian: 画像を貼り付け" },
			{ "<Leader>os", "<cmd>ObsidianTags<CR>", desc = "Obsidian: タグ検索" },
			{ "<Leader>ot", "<cmd>ObsidianTemplate<CR>", desc = "Obsidian: テンプレート挿入" },
			{ "<Leader>ow", "<cmd>ObsidianWorkspace<CR>", desc = "Obsidian: ワークスペース切替" },
		},
		opts = {
			workspaces = {
				{
					name = "obsidian",
					path = "/Users/yumac/src/github.com/ok66ym/obsidian",
				},
			},

			-- 補完（Telescope ベース）
			completion = {
				nvim_cmp = true,
				min_chars = 2,
			},

			-- ノートのデフォルト保存場所（vault ルートからの相対パス）
			notes_subdir = "020_Inbox",

			-- 日次ノート
			daily_notes = {
				folder = "020_Inbox",
				date_format = "%Y-%m-%d",
				alias_format = "%Y-%m-%d",
			},

			-- テンプレート（000_Setting/templates/ 配下に格納）
			templates = {
				folder = "000_Setting/templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},

			-- リンクスタイル（wiki リンク）
			preferred_link_style = "wiki",

			-- 新規ノートのデフォルト ID（タイトルをそのままファイル名に）
			note_id_func = function(title)
				if title ~= nil then
					return title:gsub(" ", "-"):gsub("[^A-Za-z0-9%-_]", "")
				else
					return tostring(os.time())
				end
			end,

			-- UI: チェックボックスなど
			ui = {
				enable = true,
				checkboxes = {
					[" "] = { char = "☐", hl_group = "ObsidianTodo" },
					["x"] = { char = "✔", hl_group = "ObsidianDone" },
					[">"] = { char = "▶", hl_group = "ObsidianRightArrow" },
					["~"] = { char = "≈", hl_group = "ObsidianTilde" },
				},
				bullets = { char = "•", hl_group = "ObsidianBullet" },
				external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
				reference_text = { hl_group = "ObsidianRefText" },
				highlight_text = { hl_group = "ObsidianHighlightText" },
				tags = { hl_group = "ObsidianTag" },
				block_ids = { hl_group = "ObsidianBlockID" },
				hl_groups = {
					ObsidianTodo = { bold = true, fg = "#f78c6c" },
					ObsidianDone = { bold = true, fg = "#89ddff" },
					ObsidianRightArrow = { bold = true, fg = "#fc9867" },
					ObsidianTilde = { bold = true, fg = "#ff5370" },
					ObsidianBullet = { bold = true, fg = "#89ddff" },
					ObsidianRefText = { underline = true, fg = "#c792ea" },
					ObsidianExtLinkIcon = { fg = "#c792ea" },
					ObsidianTag = { italic = true, fg = "#89ddff" },
					ObsidianBlockID = { italic = true, fg = "#89ddff" },
					ObsidianHighlightText = { bg = "#75662e" },
				},
			},

			-- 添付ファイル保存先
			attachments = {
				img_folder = "000_Assets",
			},

			-- URL は OS のデフォルトブラウザで開く
			follow_url_func = function(url)
				vim.fn.jobstart({ "open", url })
			end,
		},
	},
}
