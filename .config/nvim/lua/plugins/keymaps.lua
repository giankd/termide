local function config()
	local whichkey = require("which-key")

	local conf = {
		ignore_missing = true,
		spelling = {
			enabled = true,
			suggestions = 10,
		},
		window = {
			border = "single", -- none, single, double, shadow
			position = "bottom", -- bottom, top
		},
	}

	local isOpen = false
	local function toggle_qflist()
		if isOpen then
			vim.cmd({ cmd = "cclose" })
			isOpen = false
		else
			vim.cmd({ cmd = "copen" })
			isOpen = true
		end
	end

	local opts = {
		mode = "n", -- Normal mode
		prefix = "<leader>",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = false, -- use `nowait` when creating keymaps
	}

	local mappings = {
		["s"] = { "<cmd>update!<CR>", "Save" },
		["q"] = { "<cmd>q<CR>", "Quit" },
		["w"] = { "<cmd>bd<CR>", "Close" },
		["Q"] = { "<cmd>q!<CR>", "Force Quit" },
		["W"] = { "<cmd>bd!<CR>", "Force Close" },
		["n"] = { "<cmd>nohlsearch<CR>", "No Search Highlight" },
		["j"] = { "<cmd>bnext<CR>", "Next Buffer" },
		["k"] = { "<cmd>bprevious<CR>", "Previous Buffer" },
		["l"] = { "<C-^>", "Go to Last Buffers" },

		p = {
			name = "Project",
			v = { "<Cmd>Vex<CR>", "Split Project Folder" },
			o = { "<Cmd>Explore<CR>", "Open Project Folder" },
		},

		b = {
			name = "Buffer",
			Q = { "<cmd>%bd|e#|bd#<CR>", "Delete all buffers" },
			l = { "<cmd>Telescope buffers<CR>", "Show open buffers" },
			L = { "<cmd>buffers<CR>", "List buffers" },
			c = { "<cmd>TSContextToggle<CR>", "Toggle Context" },
		},

		t = {
			name = "Tabs",
			q = { "<cmd>tabonly<Cr>", "Delete all tabs" },
			w = { "<cmd>tabclose<Cr>", "Close current tab" },
			l = { "<cmd>tabs<CR>", "List tabs" },
			j = { "<cmd>tabnext<CR>", "Next tab" },
			k = { "<cmd>tabprevious<CR>", "Prev tab" },
			n = { "<cmd>tabnew<CR>", "New empty tab" },
			e = { "<cmd>tabfind<CR>", "Open file in new tab" },
		},

		v = {
			name = "Window",
			v = { "<cmd>vsplit<CR>", "Vertical Split" },
			s = { "<cmd>split<CR>", "Horizontal Split" },
			h = { "<C-w><", "Decrease width" },
			l = { "<C-w>>", "Increase width" },
			L = { "<C-w>|", "Maximize width" },
			k = { "<C-w>+", "Decrease height" },
			j = { "<C-w>-", "Increase height" },
			J = { "<C-w>_", "Maximize height" },
		},

		z = {
			name = "Lazy",
			c = { "<cmd>Lazy clean<cr>", "Clean" },
			i = { "<cmd>Lazy install<cr>", "Install" },
			S = { "<cmd>Lazy sync<cr>", "Sync" },
			s = { "<cmd>Lazy check<cr>", "Check" },
			u = { "<cmd>Lazy update<cr>", "Update" },
			h = { "<cmd>Lazy home<cr>", "Home" },
			H = { "<cmd>Lazy help<cr>", "Help" },
		},

		x = {
			name = "QuickFixList",
			x = { toggle_qflist, "Toggle" },
			j = { "<cmd>cnext<CR>", "Next" },
			k = { "<cmd>cprevious<CR>", "Prev" },
			c = { "<cmd>call setqflist([])<CR>", "Clear" },
		},
	}

	whichkey.setup(conf)
	whichkey.register(mappings, opts)
end

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		config = config,
	},
}
