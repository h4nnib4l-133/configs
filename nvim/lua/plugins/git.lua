-- lua/plugins/git.lua - Git integration
return {
	{
		-- Git signs and hunks
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
					-- Setup git keymaps from main keymaps.lua
					setup_git_keymaps(gs, bufnr)
				end,
			})
		end,
	},
}
