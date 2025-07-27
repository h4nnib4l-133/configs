-- lua/plugins/sessions.lua - Session management
return {
	{
		-- Session management
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			options = vim.opt.sessionoptions:get(),
		},
		config = function(_, opts)
			require("persistence").setup(opts)
			-- Session keymaps are in main keymaps.lua
		end,
	},
}
