local whichkey = require("which-key")

local conf = {
	ignore_missing = true,
	window = {
		border = "single", -- none, single, double, shadow
		position = "bottom", -- bottom, top
	},
}

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
	["h"] = { "<cmd>ls<CR>", "List Buffers" },
	["l"] = { "<C-^>", "Go to Last Buffers" },

	p = {
		name = "Project",
		v = { "<Cmd>Vex<CR>", "Split Project Folder" },
		o = { "<Cmd>Explore<CR>", "Open Project Folder" },
	},

	f = {
		name = "Find",
		b = { "<cmd>Telescope buffers<cr>", "Buffers" },
		F = {
			"<cmd>lua require('telescope.builtin').find_files{ find_command = {'rg', '--files', '--hidden', '-g', '!node_modules/**'} }<CR>",
			"Browser",
		},
		p = { "<cmd>Telescope git_files<cr>", "Git Files" },
		o = { "<cmd>Telescope oldfiles<cr>", "Old Files" },
		f = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
		c = { "<cmd>Telescope commands<cr>", "Commands" },
		w = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer" },
	},

	A = {
		name = "Fold",
		c = { "zf%", "Fold matching character" },
		b = { "zfi{", "Fold bracket block" },
	},

	b = {
		name = "Buffer",
		Q = { "<cmd>%bd|e#|bd#<CR>", "Delete all buffers" },
        l = { "<cmd>lua require('giankd.telescope').buffers()<CR>", "Show open buffers"},
		L = { "<cmd>buffers<CR>", "List buffers" },
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
		h = { "<C-w><", "Resize left" },
		l = { "<C-w>>", "Resize right" },
		L = { "<C-w>|", "Fold vertical window" },
		k = { "<C-w>+", "Resize up" },
		j = { "<C-w>-", "Resize down" },
		J = { "<C-w>_", "Fold horizontal window" },
	},

	z = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},

	G = {
		name = "Git",
		m = { "<cmd>Git mergetool<CR>", "Merge tool" },
		l = { "<cmd>Gclog<CR>", "Log" },
		f = { "<cmd>Git fetch<CR>", "Fetch" },
		c = { "<cmd>Git commit<CR>", "Commit" },
		a = { "<cmd>Gitsigns set_qflist<CR>", "Changes" },
	},
	D = {
		name = "Debug",
		G = { "<cmd>lua require('config.vimspector').generate_debug_profile()<cr>", "Generate Debug Profile" },
		I = { "<cmd>VimspectorInstall<cr>", "Install" },
		U = { "<cmd>VimspectorUpdate<cr>", "Update" },
		R = { "<cmd>call vimspector#RunToCursor()<cr>", "Run to Cursor" },
		c = { "<cmd>call vimspector#Continue()<cr>", "Continue" },
		i = { "<cmd>call vimspector#StepInto()<cr>", "Step Into" },
		o = { "<cmd>call vimspector#StepOver()<cr>", "Step Over" },
		s = { "<cmd>call vimspector#Launch()<cr>", "Start" },
		t = { "<cmd>call vimspector#ToggleBreakpoint()<cr>", "Toggle Breakpoint" },
		u = { "<cmd>call vimspector#StepOut()<cr>", "Step Out" },
		S = { "<cmd>call vimspector#Stop()<cr>", "Stop" },
		r = { "<cmd>call vimspector#Restart()<cr>", "Restart" },
		x = { "<cmd>VimspectorReset<cr>", "Reset" },
		H = { "<cmd>lua require('config.vimspector').toggle_human_mode()<cr>", "Toggle HUMAN mode" },
	},
	x = {
		name = "QuickFixList",
		x = { "<cmd>copen<CR>", "Open Quickfix" },
		j = { "<cmd>cnext<CR>", "Next in Quickfix" },
		k = { "<cmd>cprev<CR>", "Prev in Quickfix" },
		X = { "<cmd>ccl<CR>", "Close Quickfix" },
	},
}

whichkey.setup(conf)
whichkey.register(mappings, opts)
