local whichkey = require "which-key"

local conf = {
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
    F = { "<cmd>lua require('telescope.builtin').find_files{ find_command = {'rg', '--files', '--hidden', '-g', '!node_modules/**'} }<CR>",
      "Browser" },
    r = { "<cmd>Trouble lsp_references<cr>", "Find All References" },
    p = { "<cmd>Telescope git_files<cr>", "Git Files" },
    o = { "<cmd>Telescope oldfiles<cr>", "Old Files" },
    f = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    c = { "<cmd>Telescope commands<cr>", "Commands" },
    w = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer" },
  },

  b = {
    name = "Buffer",
    Q = { "<cmd>%bd|e#|bd#<CR>", "Delete all buffers" },
    l = { "<cmd>Telescope buffers<CR>", "All buffers" },
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
    k = { "<C-w>+", "Resize up" },
    j = { "<C-w>-", "Resize down" },
  },

  z = {
    name = "Plug",
    -- c = { "<cmd>PackerCompile<cr>", "Compile" },
    i = { "<cmd>PlugInstall<cr>", "Install" },
    S = { "<cmd>PlugStatus<cr>", "Status" },
    u = { "<cmd>PlugUpdate<cr>", "Update" },
    U = { "<cmd>PlugUpgrade<cr>", "Upgrade" },
  },

  G = {
    name = "Git",
    s = { "<cmd>Neogit<CR>", "Status" },
    b = { "<cmd>Git blame<CR>", "Blame" },
    d = { "<cmd>Git difftool -y<CR>", "Diff tool" },
    m = { "<cmd>Git mergetool<CR>", "Merge tool" },
    l = { "<cmd>Gclog<CR>", "Log" },
    p = { "<cmd>Git pull<CR>", "Pull" },
    P = { "<cmd>Git push<CR>", "Push" },
    f = { "<cmd>Git fetch<CR>", "Fetch" },
    c = { "<cmd>Git commit<CR>", "Commit" },
    g = { "<cmd>GitGutterQuickFix<CR>", "Hunks" },
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
}

whichkey.setup(conf)
whichkey.register(mappings, opts)
