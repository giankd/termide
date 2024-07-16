local conf = {
	preset = "modern",
	win = {
		border = "single", -- none, single, double, shadow
	},
}

local mappings = {
	{ "<leader>s", "<cmd>update!<CR>", desc = "Save" },
	{ "<leader>q", "<cmd>q<CR>", desc = "Quit" },
	{ "<leader>w", "<cmd>bd<CR>", desc = "Close" },
	{ "<leader>Q", "<cmd>q!<CR>", desc = "Force Quit" },
	{ "<leader>W", "<cmd>bd!<CR>", desc = "Force Close" },
	{ "<leader>n", "<cmd>nohlsearch<CR>", desc = "No Search Highlight" },
	{ "<leader>j", "<cmd>bnext<CR>", desc = "Next Buffer" },
	{ "<leader>k", "<cmd>bprevious<CR>", desc = "Previous Buffer" },
	{ "<leader>l", "<C-^>", desc = "Go to Last Buffers" },

	{ "<leader>p", group = "project" },
	{ "<leader>pv", "<Cmd>Vex<CR>", desc = "Split Project Folder" },
	{ "<leader>po", "<Cmd>Explore<CR>", desc = "Open Project Folder" },

	{ "<leader>b", group = "buffer" },
	{ "<leader>bQ", "<cmd>%bd|e#|bd#<CR>", desc = "Delete all buffers" },
	{ "<leader>bl", "<cmd>Telescope buffers<CR>", desc = "Show open buffers" },
	{ "<leader>bL", "<cmd>buffers<CR>", desc = "List buffers" },
	{ "<leader>bc", "<cmd>TSContextToggle<CR>", desc = "Toggle Context" },

	{ "<leader>t", group = "tabs" },
	{ "<leader>tq", "<cmd>tabonly<Cr>", desc = "Delete all tabs" },
	{ "<leader>tw", "<cmd>tabclose<Cr>", desc = "Close current tab" },
	{ "<leader>tl", "<cmd>tabs<CR>", desc = "List tabs" },
	{ "<leader>tj", "<cmd>tabnext<CR>", desc = "Next tab" },
	{ "<leader>tk", "<cmd>tabprevious<CR>", desc = "Prev tab" },
	{ "<leader>tn", "<cmd>tabnew<CR>", desc = "New empty tab" },
	{ "<leader>te", "<cmd>tabfind<CR>", desc = "Open file in new tab" },

	{ "<leader>v", group = "window" },
	{ "<leader>vv", "<cmd>vsplit<CR>", desc = "Vertical Split" },
	{ "<leader>vs", "<cmd>split<CR>", desc = "Horizontal Split" },
	{ "<leader>vh", "<C-w><", desc = "Decrease width" },
	{ "<leader>vl", "<C-w>>", desc = "Increase width" },
	{ "<leader>vL", "<C-w>|", desc = "Maximize width" },
	{ "<leader>vk", "<C-w>+", desc = "Decrease height" },
	{ "<leader>vj", "<C-w>-", desc = "Increase height" },
	{ "<leader>vJ", "<C-w>_", desc = "Maximize height" },

	{ "<leader>z", group = "lazy" },
	{ "<leader>zc", "<cmd>Lazy clean<cr>", desc = "Clean" },
	{ "<leader>zi", "<cmd>Lazy install<cr>", desc = "Install" },
	{ "<leader>zS", "<cmd>Lazy sync<cr>", desc = "Sync" },
	{ "<leader>zs", "<cmd>Lazy check<cr>", desc = "Check" },
	{ "<leader>zu", "<cmd>Lazy update<cr>", desc = "Update" },
	{ "<leader>zh", "<cmd>Lazy home<cr>", desc = "Home" },
	{ "<leader>zH", "<cmd>Lazy help<cr>", desc = "Help" },

	{ "<leader>x", desc = "Quickfix" },
	{ "<leader>xx", "<cmd>copen<CR>", desc = "Open" },
	{ "<leader>xX", "<cmd>cll<CR>", desc = "Close" },
	{ "<leader>xj", "<cmd>cnext<CR>", desc = "Next" },
	{ "<leader>xk", "<cmd>cprevious<CR>", desc = "Prev" },
	{ "<leader>xc", "<cmd>call setqflist([])<CR>", desc = "Clear" },
}

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{ "echasnovski/mini.nvim", version = false },
		},
		opts = conf,
		keys = mappings,
	},
}
