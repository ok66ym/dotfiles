return {
    -- colorscheme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,

    },

    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    -- },

    -- file browser
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            window = {
                position = "right",
            },
            event_handlers = {
                {
                    event = "file_open_requested",
                    handler = function()
                        require("neo-tree.command").execute({ action = "close" })
                    end,
                },
            },
        },
        cmd = "Neotree",
    },

    -- lualine
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
        event = "VeryLazy",
    },
    
    -- tabline
    -- TODO: research tabline
    {
        "kdheepak/tabline.nvim",
        opts = {},
        event = "BufWinEnter",
    },
    -- indent
    {
        "echasnovski/mini.indentscope",
        opts = {
            symbol = "▏",
        },
        event = "BufRead",
    },

    -- nvim-treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufRead", "BufNewFile", "InsertEnter" },
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "awk",
                    "bash",
                    "comment",
                    "c",
                    "html",
                    "css",
                    "csv",
                    "diff",
                    "gpg",
                    "html",
                    "htmldjango",
                    "javascript",
                    "json",
                    "lua",
                    "markdown",
                    "python",
                    "rust",
                    "ruby",
                    "typescript",
                    "javascript",
                    "go",
                    "sql",
                    "ssh_config",
                    "tmux",
                    "toml",
                    "vim",
                    "xml",
                    "yaml",
                    "regex",
                    "vimdoc",
                },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- noice
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            routes = {
                {
                    filter = { event = "msg_show", find = "E486: Pattern not found: .*" },
                    opts = { skip = true },
                },
            },
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
        },
    },

    -- git
    {
        "lewis6991/gitsigns.nvim",
        config = true,
        event = { "BufReadPre", "BufNewFile" },
    },
}
