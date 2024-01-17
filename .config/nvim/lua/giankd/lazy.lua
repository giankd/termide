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
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
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
	{ "windwp/nvim-autopairs", lazy = true },
	{ "windwp/nvim-ts-autotag", lazy = true },
	{ "rcarriga/nvim-notify" },

	-- LSP
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},

	-- LSP Support
	{ "williamboman/mason.nvim", lazy = false, config = true },
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neodev.nvim", opts = {} },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "mhartington/formatter.nvim", config = require("giankd.plugins.formatter").config },
			{ "j-hui/fidget.nvim", config = require("giankd.plugins.fidget").config }, -- LSP Progress UI
			{ "aznhe21/actions-preview.nvim", config = require("giankd.plugins.actions-preview").config }, -- Code Actions UI
		},
		config = require("giankd.plugins.lsp").config,
	},

	{
		"mfussenegger/nvim-lint",
		event = "BufWritePost",
		config = function()
			require("giankd.plugins.linter").config()
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
			{
				"dnlhc/glance.nvim",
				config = function()
					require("giankd.plugins.glance").config()
				end,
			}, -- LSP goto UI
		},
		config = function()
			require("giankd.plugins.cmp").config()
		end,
	},

	-- Treesitter
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "nvim-treesitter/nvim-treesitter-context" },

	-- Debugger
	{ "mfussenegger/nvim-dap", lazy = true },
	{ "rcarriga/nvim-dap-ui", lazy = true },
	{ "theHamsta/nvim-dap-virtual-text", lazy = true },
})
