-- lua/plugins/telescope.lua - Enhanced with keymap search and advanced features
return {
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<c-enter>"] = "to_fuzzy_refine",
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
					},
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					sorting_strategy = "ascending",
					winblend = 0,
				},
				pickers = {
					find_files = {
						theme = "dropdown",
						previewer = false,
					},
					buffers = {
						theme = "dropdown",
						previewer = false,
						initial_mode = "normal",
					},
					keymaps = {
						theme = "ivy",
						layout_config = {
							height = 0.4,
						},
					},
					lsp_references = {
						theme = "ivy",
						layout_config = {
							height = 0.4,
						},
					},
					lsp_definitions = {
						theme = "ivy",
						layout_config = {
							height = 0.4,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			-- Enable Telescope extensions
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- Telescope builtin functions
			local builtin = require("telescope.builtin")

			-- File and buffer searching
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- Help and documentation
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sm", builtin.man_pages, { desc = "[S]earch [M]an pages" })

			-- Enhanced keymap search with categories
			vim.keymap.set("n", "<leader>sk", function()
				builtin.keymaps({
					prompt_title = "🗝️  Search Keymaps",
					layout_strategy = "vertical",
					layout_config = {
						width = 0.9,
						height = 0.9,
						preview_height = 0.6,
					},
				})
			end, { desc = "[S]earch [K]eymaps" })

			-- Search all mappings with custom function
			vim.keymap.set("n", "<leader>sK", function()
				local modes = { "n", "i", "v", "x", "s", "o", "t", "c" }
				local all_maps = {}

				for _, mode in ipairs(modes) do
					local maps = vim.api.nvim_get_keymap(mode)
					for _, map in ipairs(maps) do
						table.insert(all_maps, {
							mode = mode,
							lhs = map.lhs,
							rhs = map.rhs or map.callback and "[function]" or "",
							desc = map.desc or "",
							buffer = map.buffer or false,
						})
					end
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "🔍 All Keymaps",
						finder = require("telescope.finders").new_table({
							results = all_maps,
							entry_maker = function(entry)
								return {
									value = entry,
									display = string.format(
										"[%s] %-20s → %s",
										entry.mode,
										entry.lhs,
										entry.desc ~= "" and entry.desc or entry.rhs
									),
									ordinal = entry.mode .. " " .. entry.lhs .. " " .. entry.desc .. " " .. entry.rhs,
								}
							end,
						}),
						sorter = require("telescope.config").values.generic_sorter({}),
						previewer = require("telescope.previewers").new_buffer_previewer({
							title = "Keymap Details",
							define_preview = function(self, entry)
								local lines = {
									"Mode: " .. entry.value.mode,
									"Key: " .. entry.value.lhs,
									"Action: " .. (entry.value.rhs ~= "" and entry.value.rhs or "[function]"),
									"Description: " .. entry.value.desc,
									"Buffer-local: " .. tostring(entry.value.buffer),
								}
								vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
							end,
						}),
					})
					:find()
			end, { desc = "[S]earch All [K]eymaps" })

			-- Neovim and plugin searching
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })

			-- LSP and diagnostics
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sld", function()
				builtin.diagnostics({ bufnr = 0 })
			end, { desc = "[S]earch [L]ocal [D]iagnostics" })

			-- Git integration
			vim.keymap.set("n", "<leader>sgf", builtin.git_files, { desc = "[S]earch [G]it [F]iles" })
			vim.keymap.set("n", "<leader>sgc", builtin.git_commits, { desc = "[S]earch [G]it [C]ommits" })
			vim.keymap.set("n", "<leader>sgb", builtin.git_branches, { desc = "[S]earch [G]it [B]ranches" })
			vim.keymap.set("n", "<leader>sgs", builtin.git_status, { desc = "[S]earch [G]it [S]tatus" })

			-- Advanced searches
			vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
			vim.keymap.set("n", "<leader>sco", builtin.command_history, { desc = "[S]earch [C]ommand hist[O]ry" })
			vim.keymap.set("n", "<leader>sj", builtin.jumplist, { desc = "[S]earch [J]umplist" })
			vim.keymap.set("n", "<leader>sl", builtin.loclist, { desc = "[S]earch [L]ocation list" })
			vim.keymap.set("n", "<leader>sq", builtin.quickfix, { desc = "[S]earch [Q]uickfix" })
			vim.keymap.set("n", "<leader>sr", builtin.registers, { desc = "[S]earch [R]egisters" })
			vim.keymap.set("n", "<leader>st", builtin.tags, { desc = "[S]earch [T]ags" })

			-- Search in specific directories
			vim.keymap.set("n", "<leader>sp", function()
				builtin.find_files({
					prompt_title = "Find Plugin Files",
					cwd = vim.fn.stdpath("data") .. "/lazy",
				})
			end, { desc = "[S]earch [P]lugin files" })

			-- Buffer-specific searches
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Custom search for TODOs and FIXMEs
			vim.keymap.set("n", "<leader>st", function()
				builtin.live_grep({
					prompt_title = "Search TODOs/FIXMEs",
					default_text = "TODO|FIXME|HACK|BUG|NOTE",
				})
			end, { desc = "[S]earch [T]ODOs" })

			-- Search by file extension
			vim.keymap.set("n", "<leader>se", function()
				local ext = vim.fn.input("File extension (without dot): ")
				if ext ~= "" then
					builtin.find_files({
						prompt_title = "Find ." .. ext .. " files",
						find_command = { "find", ".", "-type", "f", "-name", "*." .. ext },
					})
				end
			end, { desc = "[S]earch by [E]xtension" })

			-- Function to search for function definitions
			vim.keymap.set("n", "<leader>sf", function()
				builtin.live_grep({
					prompt_title = "Search Function Definitions",
					default_text = "def |function |const.*=|class ",
				})
			end, { desc = "[S]earch [F]unction definitions" })
		end,
	},
}
