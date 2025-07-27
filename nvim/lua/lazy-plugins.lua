-- lua/lazy-plugins.lua - Enhanced with all new plugins
require("lazy").setup({
	-- Core functionality
	require("plugins/telescope"),
	require("plugins/lspconfig"),
	require("plugins/cmp"),
	require("plugins/conform"),
	require("plugins/treesitter"),

	-- Navigation and file management
	require("plugins/harpoon"), -- 🆕 Quick file navigation
	require("plugins/neotree"), -- ✅ Your existing file explorer

	-- Python development
	require("plugins/venv-selector"),
	require("plugins/debug"), -- Enhanced with better Python DAP

	-- UI and appearance (your existing ones)
	require("plugins/oxocarbon"), -- ✅ Your existing color scheme
	require("plugins/autopairs"), -- ✅ Your existing autopairs
	require("plugins/indentline"), -- ✅ Your existing indent guides
	require("plugins/noice"), -- ✅ Your existing enhanced UI
	require("plugins/dashboard"), -- ✅ Your existing alpha dashboard
	require("plugins/statusline"), -- ✅ Your existing lualine

	-- Fun/extras
	require("plugins/leetcode"), -- ✅ Your existing leetcode plugin

	-- 🆕 Additional quality-of-life plugins
	{
		-- Better quickfix window
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		config = function()
			require("bqf").setup({
				auto_enable = true,
				auto_resize_height = true,
				preview = {
					win_height = 12,
					win_vheight = 12,
					delay_syntax = 80,
					border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
				},
			})
		end,
	},

	{
		-- Git integration
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				current_line_blame = true,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol",
					delay = 1000,
					ignore_whitespace = false,
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

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
				end,
			})
		end,
	},

	{
		-- Better commenting
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},

	{
		-- Surround text objects
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					insert = "<C-g>s",
					insert_line = "<C-g>S",
					normal = "ys",
					normal_cur = "yss",
					normal_line = "yS",
					normal_cur_line = "ySS",
					visual = "S",
					visual_line = "gS",
					delete = "ds",
					change = "cs",
				},
			})
		end,
	},

	{
		-- Better UI for LSP
		"stevearc/dressing.nvim",
		opts = {},
	},

	{
		-- Highlight other uses of word under cursor
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({
				providers = { "lsp", "treesitter", "regex" },
				delay = 200,
				filetypes_denylist = {
					"dirvish",
					"fugitive",
					"alpha",
					"NvimTree",
					"lazy",
					"neogitstatus",
					"Trouble",
					"lir",
					"Outline",
					"spectre_panel",
					"toggleterm",
					"DressingSelect",
					"TelescopePrompt",
				},
			})
		end,
	},

	{
		-- Better fold text
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		config = function()
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})

			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		end,
	},

	{
		-- Better terminal integration
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<c-\>]],
				hide_numbers = true,
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
					winblend = 0,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
			})

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
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
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
		end,
	},

	{
		-- Session management
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			options = vim.opt.sessionoptions:get(),
		},
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Current Session",
			},
		},
	},

	{
		-- Which-key for keymap hints
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		config = function()
			local wk = require("which-key")
			wk.setup({
				plugins = {
					marks = true,
					registers = true,
					spelling = {
						enabled = true,
						suggestions = 20,
					},
				},
				presets = {
					operators = false,
					motions = true,
					text_objects = true,
					windows = true,
					nav = true,
					z = true,
					g = true,
				},
			})

			-- Register key groups
			wk.register({
				["<leader>"] = {
					b = { name = "Debug/Breakpoints" },
					c = { name = "Code" },
					d = { name = "Document/Debug" },
					f = { name = "Format" },
					g = { name = "Git" },
					h = { name = "Git Hunks" },
					q = { name = "Session" },
					r = { name = "Rename" },
					s = { name = "Search" },
					t = { name = "Terminal/Toggle" },
					w = { name = "Workspace" },
				},
			})
		end,
	},
}, {
	-- Lazy.nvim configuration
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
