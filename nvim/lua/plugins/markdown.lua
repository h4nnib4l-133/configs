return {
	{
		-- Live markdown preview in browser
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			-- Configuration for markdown-preview
			vim.g.mkdp_auto_start = 0 -- Don't auto-start preview
			vim.g.mkdp_auto_close = 1 -- Auto-close preview when leaving markdown buffer
			vim.g.mkdp_refresh_slow = 0 -- Fast refresh
			vim.g.mkdp_command_for_global = 0 -- Only available in markdown files
			vim.g.mkdp_open_to_the_world = 0 -- Don't make server available to others on network
			vim.g.mkdp_open_ip = "127.0.0.1"
			vim.g.mkdp_port = "8080"
			vim.g.mkdp_browser = "" -- Use system default browser
			vim.g.mkdp_echo_preview_url = 1 -- Echo preview URL
			vim.g.mkdp_browserfunc = ""
			vim.g.mkdp_preview_options = {
				mkit = {},
				katex = {},
				uml = {},
				maid = {},
				disable_sync_scroll = 0,
				sync_scroll_type = "middle",
				hide_yaml_meta = 1,
				sequence_diagrams = {},
				flowchart_diagrams = {},
				content_editable = false,
				disable_filename = 0,
				toc = {},
			}
			vim.g.mkdp_markdown_css = ""
			vim.g.mkdp_highlight_css = ""
			vim.g.mkdp_theme = "dark" -- Use dark theme

			-- Markdown keymaps are in main keymaps.lua
		end,
	},

	{
		-- Inline markdown rendering in buffer
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
		ft = { "markdown", "quarto", "rmd" },
		config = function()
			require("render-markdown").setup({
				-- Whether Markdown should be rendered by default or not
				enabled = true,
				-- Maximum file size (in MB) that this plugin will attempt to render
				-- Any file larger than this will skip rendering for performance
				max_file_size = 10.0,
				-- Milliseconds that must pass before updating marks, helps with performance
				debounce = 100,
				-- Pre configured settings that will attempt to mimic various applications
				-- Default: 'none'
				--   'obsidian': mimic Obsidian UI
				--   'lazy': mimic LazyVim UI
				--   'none': plain setup
				preset = "none",
				-- The level of logs to write to file: vim.fn.stdpath('state') .. '/render-markdown.log'
				-- Only intended to be used for plugin development / debugging
				log_level = "error",
				-- Filetypes this plugin will run on
				file_types = { "markdown", "quarto", "rmd" },
				-- Out of the box language injections, see Language Injections section
				injections = {},
				-- Characters that will replace the concealed part of the code block
				anti_conceal = {
					-- Turn on / off anti concealing behavior
					enabled = true,
				},
				-- Window options to use that change between rendered and raw view
				win_options = {
					-- See :h 'conceallevel'
					conceallevel = {
						-- Used when not being rendered, get user setting
						default = vim.api.nvim_get_option_value("conceallevel", {}),
						-- Used when being rendered, concealed text is completely hidden
						rendered = 3,
					},
					-- See :h 'concealcursor'
					concealcursor = {
						-- Used when not being rendered, get user setting
						default = vim.api.nvim_get_option_value("concealcursor", {}),
						-- Used when being rendered, concealed text is expanded in all modes
						rendered = "",
					},
				},
				-- Determines how tables are rendered
				pipe_table = {
					-- Turn on / off pipe table rendering
					enabled = true,
					-- Determines how the table as a whole is rendered:
					--  none: adds no formatting
					--  normal: adds padding to the table
					--  full: normal + a top & bottom border
					style = "full",
					-- Amount of space to put between cell contents and border
					cell_margin = 1,
					-- Minimum column width, affects both alignment and min width
					min_width = 0,
					-- Characters used to replace table border
					-- Correspond to top(3), delimiter(3), bottom(3), vertical, & corner characters
					border = {
						-- ┌─┬┐
						"┌",
						"─",
						"┬",
						"┐",
						-- ├─┼┤
						"├",
						"─",
						"┼",
						"┤",
						-- └─┴┘
						"└",
						"─",
						"┴",
						"┘",
						-- │
						"│",
						-- ┼
						"┼",
					},
					-- Highlight for table heading, delimiter, and the line above
					head = "RenderMarkdownTableHead",
					-- Highlight for everything else, main table rows and the line below
					row = "RenderMarkdownTableRow",
					-- Highlight for table footer (final row)
					filler = "RenderMarkdownTableFill",
				},
			})

			-- Markdown keymaps are loaded in the preview plugin config above
		end,
	},
}
