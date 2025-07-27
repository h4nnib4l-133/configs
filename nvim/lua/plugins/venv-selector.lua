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
		config = function()
			require("venv-selector").setup({
				settings = {
					options = {
						debug = true,
						notify_user_on_venv_activation = true,
					},
					search = {
						anaconda_envs = {
							command = "$FD 'bin/python$' /home/bear/miniconda3/envs --full-path --color never -E /proc",
							type = "anaconda",
						},
						anaconda_base = {
							command = "$FD '/python$' /home/bear/miniconda3/bin/ --full-path --color never -E /proc",
							type = "anaconda",
						},
					},
				},
			})
		end,
	},
}
