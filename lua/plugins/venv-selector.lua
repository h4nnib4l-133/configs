return {
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
			"mfussenegger/nvim-dap-python",
		},
		branch = "regexp",
		opts = {
			dap_enabled = true, -- makes the debugger work with venv
		},
	},
}
