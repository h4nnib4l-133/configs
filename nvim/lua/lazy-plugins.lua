-- lua/lazy-plugins.lua - Clean plugin configurations without keymaps
require("lazy").setup({
	-- Core functionality  
	require("plugins/telescope"),
	require("plugins/lspconfig"),
	require("plugins/cmp"),
	require("plugins/conform"),
	require("plugins/treesitter"),

	-- Navigation and file management
	require("plugins/harpoon"),
	require("plugins/neotree"),

	-- Python development
	require("plugins/venv-selector"),
	require("plugins/debug"),

	-- UI and appearance
	require("plugins/oxocarbon"),
	require("plugins/autopairs"),
	require("plugins/indentline"),
	require("plugins/noice"),
	require("plugins/dashboard"),
	require("plugins/statusline"),

	-- Markdown support
	require("plugins/markdown"),

	-- Development tools
	require("plugins/git"),
	require("plugins/terminal"),
	require("plugins/editing"),
	require("plugins/sessions"),
	require("plugins/ui-enhancements"),

	-- AI Integration
	require("plugins/claudecode"),

	-- Fun/extras
	require("plugins/leetcode"),

	-- Which-key for keymap hints
	require("plugins/which-key"),
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
