local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")

if not ok then
	print("Unable to find a lazy installation!")
	return
end

lazy.setup({
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		-- config = function()
		-- 	require("catppuccin").setup({
		-- 		flavour = "macchiato",
		-- 		transparent_background = true,
		-- 	})
		-- 	vim.cmd([[colorscheme catppuccin]])
		-- end,
	},
	{
		"nvim-lualine/lualine.nvim",
		requires = {
			"nvim-tree/nvim-web-devicons",
			lazy = true,
			config = function()
				require("nvim-web-devicons").setup({
					-- your personnal icons can go here (to override)
					-- DevIcon will be appended to `name`
					override = {},
					-- globally enable default icons (default to false)
					-- will get overriden by `get_icons` option
					default = true,
				})
			end,
		},
	},

	-- Git
	{
		"tpope/vim-fugitive",
		cmd = "Git",
		lazy = true,
	},
	{ "lewis6991/gitsigns.nvim", lazy = true },

	-- Netrw
	{ "tpope/vim-vinegar", lazy = false },

	-- Utils
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
	},
	{
		"numToStr/Comment.nvim",
		lazy = false,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section
		},
	},
	{ "mhartington/formatter.nvim", lazy = true },
	{ "windwp/nvim-autopairs" },
	{ "windwp/nvim-ts-autotag" },
	{ "rcarriga/nvim-notify" },

	-- LSP
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },

	-- LSP Support
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },

	-- Autocompletion
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "hrsh7th/cmp-nvim-lua" },
	{ "L3MON4D3/LuaSnip" },
	{ "rafamadriz/friendly-snippets" },
	{ "dnlhc/glance.nvim" }, -- LSP goto UI
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			require("actions-preview").setup({
				backend = { "telescope" },
				-- options related to telescope.nvim
				telescope = vim.tbl_extend(
					"force",
					require("telescope.themes").get_cursor(),
					-- a table for customizing content
					{
						-- a function to make a table containing the values to be displayed.
						-- fun(action: Action): { title: string, client_name: string|nil }
						-- make_value = nil,

						-- a function to make a function to be used in `display` of a entry.
						-- see also `:h telescope.make_entry` and `:h telescope.pickers.entry_display`.
						-- fun(values: { index: integer, action: Action, title: string, client_name: string }[]): function
						-- make_make_display = nil,
					}
				),
			})
		end,
	}, -- Code Actions UI
	{ "j-hui/fidget.nvim" }, -- LSP Progress UI

	-- Treesitter
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "nvim-treesitter/nvim-treesitter-context" },
	{ "leafOfTree/vim-svelte-plugin" },

	-- Debugger
	{ "mfussenegger/nvim-dap" },
	{ "rcarriga/nvim-dap-ui" },
	{ "theHamsta/nvim-dap-virtual-text" },
})
