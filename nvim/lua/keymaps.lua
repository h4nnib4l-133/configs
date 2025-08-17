-- lua/keymaps.lua - Core keymaps (LSP keymaps in lspconfig.lua)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to upper window" })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move lines up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page up and center" })

-- Better search result navigation
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- ===================================================================
-- GIT KEYMAPS (Gitsigns)
-- ===================================================================

-- Function to setup git keymaps (called from gitsigns on_attach)
function _G.setup_git_keymaps(gs, bufnr)
	local function map(mode, l, r, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	end

	-- Navigation
	map("n", "]c", function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			gs.next_hunk()
		end)
		return "<Ignore>"
	end, { expr = true, desc = "Next git hunk" })

	map("n", "[c", function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			gs.prev_hunk()
		end)
		return "<Ignore>"
	end, { expr = true, desc = "Previous git hunk" })

	-- Actions
	map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
	map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
	map("v", "<leader>hs", function()
		gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, { desc = "Stage hunk" })
	map("v", "<leader>hr", function()
		gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, { desc = "Reset hunk" })
	map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
	map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
	map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
	map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
	map("n", "<leader>hb", function()
		gs.blame_line({ full = true })
	end, { desc = "Blame line" })
	map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
	map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
	map("n", "<leader>hD", function()
		gs.diffthis("~")
	end, { desc = "Diff this ~" })
	map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })

	-- Text object
	map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
end

-- ===================================================================
-- TERMINAL KEYMAPS (ToggleTerm)
-- ===================================================================

-- Function to setup terminal keymaps (called from terminal plugin)
function _G.setup_terminal_keymaps()
	-- Terminal keymaps
	function _G.set_terminal_keymaps()
		local opts = { buffer = 0 }
		vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
		vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
		vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
		vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
		vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
	end

	vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

	-- Custom terminal commands
	local Terminal = require("toggleterm.terminal").Terminal

	-- Python REPL
	local python = Terminal:new({
		cmd = "python",
		dir = "git_dir",
		direction = "float",
		float_opts = {
			border = "double",
		},
		on_open = function(term)
			vim.cmd("startinsert!")
			vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
		end,
		on_close = function(term)
			vim.cmd("startinsert!")
		end,
	})

	function _PYTHON_TOGGLE()
		python:toggle()
	end

	-- Lazygit
	local lazygit = Terminal:new({
		cmd = "lazygit",
		dir = "git_dir",
		direction = "float",
		float_opts = {
			border = "double",
		},
		on_open = function(term)
			vim.cmd("startinsert!")
		end,
		on_close = function(term)
			vim.cmd("startinsert!")
		end,
	})

	function _LAZYGIT_TOGGLE()
		lazygit:toggle()
	end

	-- Keymaps for custom terminals
	vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Toggle Python terminal" })
	vim.keymap.set("n", "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Toggle Lazygit" })
end

-- ===================================================================
-- FOLDING KEYMAPS (UFO)
-- ===================================================================

-- Function to setup folding keymaps (called from editing plugin)
function _G.setup_folding_keymaps()
	vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
	vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
end

-- ===================================================================
-- SESSION KEYMAPS (Persistence)
-- ===================================================================

-- Session management keymaps
vim.keymap.set("n", "<leader>qs", function()
	require("persistence").load()
end, { desc = "Restore Session" })

vim.keymap.set("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end, { desc = "Restore Last Session" })

vim.keymap.set("n", "<leader>qd", function()
	require("persistence").stop()
end, { desc = "Don't Save Current Session" })

-- ===================================================================
-- MARKDOWN KEYMAPS (Inline Rendering Only)
-- ===================================================================

-- Inline markdown rendering keymaps
vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", { desc = "[M]arkdown [R]ender toggle" })
vim.keymap.set("n", "<leader>me", "<cmd>RenderMarkdown enable<CR>", { desc = "[M]arkdown render [E]nable" })
vim.keymap.set("n", "<leader>md", "<cmd>RenderMarkdown disable<CR>", { desc = "[M]arkdown render [D]isable" })
