-- lua/plugins/dashboard.lua - Enhanced with recent files and keymap search
return {
	{
		"goolord/alpha-nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Set header
			dashboard.section.header.val = {
				"                                                     ",
				"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
				"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
				"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
				"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
				"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
				"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
				"                                                     ",
				"                  🚀 Ready for Code                  ",
				"                                                     ",
			}

			-- Set menu
			dashboard.section.buttons.val = {
				dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("f", "󰈞  Find file", ":Telescope find_files<CR>"),
				dashboard.button("g", "󰊄  Live grep", ":Telescope live_grep<CR>"),
				dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
				dashboard.button("k", "🗝️   Search keymaps", ":Telescope keymaps<CR>"),
				dashboard.button(
					"K",
					"🔍  All keymaps",
					":lua require('telescope.builtin').keymaps({ prompt_title = '🔍 All Keymaps', layout_strategy = 'vertical', layout_config = { width = 0.9, height = 0.9, preview_height = 0.6 } })<CR>"
				),
				dashboard.button(
					"h",
					"🎯  Harpoon",
					":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>"
				),
				dashboard.button("p", "📦  Plugins", ":Lazy<CR>"),
				dashboard.button("m", "🔧  Mason", ":Mason<CR>"),
				dashboard.button("c", "⚙️   Config", ":e ~/.config/nvim/init.lua<CR>"),
				dashboard.button("s", "💾  Restore session", ":lua require('persistence').load()<CR>"),
				dashboard.button("q", "󰗼  Quit", ":qa<CR>"),
			}

			-- Function to get recent files
			local function get_recent_files()
				local oldfiles = {}
				local oldfiles_list = vim.v.oldfiles or {}

				for _, file in ipairs(oldfiles_list) do
					if vim.fn.filereadable(file) == 1 then
						local filename = vim.fn.fnamemodify(file, ":t")
						local filepath = vim.fn.fnamemodify(file, ":~")

						-- Skip files that are too long or from plugin directories
						if #filepath < 70 and not filepath:match("lazy") and not filepath:match("mason") then
							table.insert(oldfiles, {
								filename = filename,
								filepath = filepath,
								fullpath = file,
							})

							-- Limit to 8 recent files
							if #oldfiles >= 8 then
								break
							end
						end
					end
				end

				return oldfiles
			end

			-- Create recent files section
			local function create_recent_files_section()
				local recent_files = get_recent_files()
				local recent_files_section = {
					type = "group",
					val = {},
					opts = {
						spacing = 1,
					},
				}

				if #recent_files > 0 then
					-- Add header for recent files
					table.insert(recent_files_section.val, {
						type = "text",
						val = "📁 Recent Files",
						opts = {
							position = "center",
							hl = "SpecialComment",
						},
					})

					-- Add spacing
					table.insert(recent_files_section.val, {
						type = "padding",
						val = 1,
					})

					-- Add each recent file
					for i, file in ipairs(recent_files) do
						local file_button = {
							type = "button",
							val = string.format("  %-25s %s", file.filename, file.filepath),
							on_press = function()
								vim.cmd("edit " .. file.fullpath)
							end,
							opts = {
								position = "center",
								shortcut = tostring(i),
								cursor = 3,
								width = 60,
								align_shortcut = "right",
								hl_shortcut = "Keyword",
								hl = "Comment",
							},
						}
						table.insert(recent_files_section.val, file_button)
					end
				else
					table.insert(recent_files_section.val, {
						type = "text",
						val = "📁 No recent files",
						opts = {
							position = "center",
							hl = "Comment",
						},
					})
				end

				return recent_files_section
			end

			-- Stats section
			local function get_stats()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				return {
					type = "text",
					val = "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. "ms",
					opts = {
						position = "center",
						hl = "Number",
					},
				}
			end

			-- Custom layout
			local config = {
				layout = {
					dashboard.section.header,
					{ type = "padding", val = 1 },
					dashboard.section.buttons,
					{ type = "padding", val = 2 },
					create_recent_files_section(),
					{ type = "padding", val = 2 },
					get_stats(),
					{ type = "padding", val = 1 },
					{
						type = "text",
						val = {
							"💡 Quick Tips:",
							"• <leader>sk - Search keymaps",
							"• <leader>sK - Search ALL keymaps",
							"• <leader>a  - Add to Harpoon",
							"• <C-e>      - Harpoon menu",
							"• <leader>y  - Copy to clipboard",
							"• <leader>p  - Paste from clipboard",
						},
						opts = {
							position = "center",
							hl = "Comment",
						},
					},
				},
				opts = {
					margin = 5,
				},
			}

			-- Disable folding on alpha buffer
			vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

			-- Custom highlight groups
			vim.api.nvim_set_hl(0, "AlphaShortcut", { ctermfg = 208, fg = "#ff8700" })
			vim.api.nvim_set_hl(0, "AlphaHeader", { ctermfg = 98, fg = "#875fd7" })
			vim.api.nvim_set_hl(0, "AlphaHeaderLabel", { ctermfg = 98, fg = "#875fd7" })
			vim.api.nvim_set_hl(0, "AlphaButtons", { ctermfg = 110, fg = "#87afd7" })
			vim.api.nvim_set_hl(0, "AlphaFooter", { ctermfg = 98, fg = "#875fd7" })

			-- Custom keymaps for dashboard
			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function()
					-- Quick access to keymap search from dashboard
					vim.keymap.set("n", "k", ":Telescope keymaps<CR>", { buffer = true, desc = "Search keymaps" })
					vim.keymap.set(
						"n",
						"K",
						":lua require('telescope.builtin').keymaps({ prompt_title = '🔍 All Keymaps', layout_strategy = 'vertical', layout_config = { width = 0.9, height = 0.9, preview_height = 0.6 } })<CR>",
						{ buffer = true, desc = "Search all keymaps" }
					)

					-- Quick access to recent files by number
					for i = 1, 8 do
						vim.keymap.set("n", tostring(i), function()
							local recent_files = get_recent_files()
							if recent_files[i] then
								vim.cmd("edit " .. recent_files[i].fullpath)
							end
						end, { buffer = true, desc = "Open recent file " .. i })
					end

					-- Quick Harpoon access
					vim.keymap.set(
						"n",
						"h",
						":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>",
						{ buffer = true, desc = "Harpoon menu" }
					)

					-- Refresh dashboard
					vim.keymap.set("n", "R", ":Alpha<CR>", { buffer = true, desc = "Refresh dashboard" })
				end,
			})

			alpha.setup(config)
		end,
	},
}
