-- lua/plugins/which-key.lua - Keymap hints and documentation
return {
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

			-- Register key groups using NEW which-key spec
			wk.add({
				{ "<leader>b", group = "Debug/Breakpoints" },
				{ "<leader>c", group = "Code" },
				{ "<leader>d", group = "Document/Debug" },
				{ "<leader>f", group = "Format" },
				{ "<leader>g", group = "Git" },
				{ "<leader>h", group = "Git Hunks" },
				{ "<leader>m", group = "Markdown" },
				{ "<leader>q", group = "Session" },
				{ "<leader>r", group = "Rename" },
				{ "<leader>s", group = "Search" },
				{ "<leader>sg", group = "Git Search" },
				{ "<leader>t", group = "Terminal/Toggle" },
				{ "<leader>w", group = "Workspace" },
			})
		end,
	},
}
