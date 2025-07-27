-- lua/plugins/markdown.lua - Inline markdown rendering only
return {
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
					style = "normal", -- Changed from "full" to "normal"
					-- Amount of space to put between cell contents and border
					cell_margin = 1,
					-- Minimum column width, affects both alignment and min width
					min_width = 0,
					-- Simpler ASCII characters that work everywhere
					border = {
						-- Top border: +---+
						"+",
						"-",
						"+",
						"+",
						-- Middle border: +---+
						"+",
						"-",
						"+",
						"+",
						-- Bottom border: +---+
						"+",
						"-",
						"+",
						"+",
						-- Vertical: |
						"|",
						-- Corner: +
						"+",
					},
					-- Highlight for table heading, delimiter, and the line above
					head = "RenderMarkdownTableHead",
					-- Highlight for everything else, main table rows and the line below
					row = "RenderMarkdownTableRow",
					-- Highlight for table footer (final row)
					filler = "RenderMarkdownTableFill",
				},
			})
		end,
	},
}
