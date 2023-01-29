return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- ColorScheme
	use({ "catppuccin/nvim", as = "catppuccin", run = ":CatppuccinCompile" })
	use({ "kyazdani42/nvim-web-devicons" })

	-- Lualine
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- Git
	use("tpope/vim-fugitive")
	use("lewis6991/gitsigns.nvim")
	-- Github
	use("tpope/vim-rhubarb")
	-- Netrw
	use("tpope/vim-vinegar")

	-- Lot of utils
	use("nvim-lua/plenary.nvim")
	use("nvim-lua/popup.nvim")
	use("nvim-telescope/telescope.nvim")
	use({
		"sudormrfbin/cheatsheet.nvim",
		requires = {
			{ "nvim-telescope/telescope.nvim" },
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
		},
	})
	use("numToStr/Comment.nvim")
	use("folke/which-key.nvim")
	use({ "mhartington/formatter.nvim" })
	use("windwp/nvim-autopairs")
	use("windwp/nvim-ts-autotag")
	use("rcarriga/nvim-notify")

	-- LSP Plugs
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Configuration Manager
			{ "williamboman/mason.nvim" }, -- Installer
			{ "williamboman/mason-lspconfig.nvim" }, -- Installer with config

			-- For Lua
			{ "folke/neodev.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Completion
			{ "hrsh7th/cmp-nvim-lsp" }, -- Working completion
			{ "hrsh7th/cmp-buffer" }, -- Completion from buffer
			{ "hrsh7th/cmp-path" }, -- Completion from path
			{ "hrsh7th/cmp-cmdline" }, -- Completion from cmdline
			{ "hrsh7th/cmp-nvim-lsp-signature-help" }, -- Signature Help
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },

			-- UI
			{
				"glepnir/lspsaga.nvim",
				branch = "main",
				requires = { { "nvim-tree/nvim-web-devicons" } },
			},
			{ "j-hui/fidget.nvim" }, -- LSP Progress UI
		},
	})

	-- Treesitter
	use("nvim-treesitter/nvim-treesitter", {
		run = ":TSUpdate",
	})
	use("nvim-treesitter/nvim-treesitter-context")
	use("leafOfTree/vim-svelte-plugin")

	-- Debugger
	use("mfussenegger/nvim-dap")
	use("rcarriga/nvim-dap-ui")
	use("theHamsta/nvim-dap-virtual-text")
end)
