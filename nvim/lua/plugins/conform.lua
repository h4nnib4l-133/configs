-- lua/plugins/conform.lua - Enhanced with all language formatters
return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ lsp_fallback = true })
				end,
				desc = "Format buffer",
			},
			{
				"<leader>F",
				function()
					require("conform").format({ lsp_fallback = true, range = true })
				end,
				mode = "v",
				desc = "Format selection",
			},
		},
		opts = {
			formatters_by_ft = {
				-- Python
				python = { "isort", "black" },

				-- Lua
				lua = { "stylua" },

				-- Shell/Bash
				sh = { "shfmt" },
				bash = { "shfmt" },

				-- Web technologies
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },

				-- YAML (for docker-compose)
				yaml = { "prettier" },
				yml = { "prettier" },

				-- Dockerfile (prettier can handle it)
				dockerfile = { "prettier" },

				-- Markdown
				markdown = { "prettier", "inject" },

				-- TOML
				toml = { "taplo" },

				-- XML
				xml = { "xmlformat" },

				-- Go (if you add it later)
				go = { "gofumpt", "goimports" },

				-- Rust (if you add it later)
				rust = { "rustfmt" },

				-- Special: inject formatter for embedded code blocks
				["*"] = { "codespell" }, -- Global spell checker
			},

			-- Custom formatters configuration
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2", "-ci" }, -- 2 spaces, indent case statements
				},
				prettier = {
					prepend_args = { "--tab-width", "2", "--print-width", "100" },
				},
				black = {
					prepend_args = { "--line-length", "88" },
				},
				isort = {
					prepend_args = { "--profile", "black" },
				},
			},

			-- Format on save configuration
			format_on_save = function(bufnr)
				-- Disable format on save for specific filetypes
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return
				end

				-- Disable format on save in certain directories
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("/node_modules/") then
					return
				end

				return {
					timeout_ms = 500,
					lsp_fallback = true,
				}
			end,

			-- Notify on format errors
			notify_on_error = true,

			-- Log level
			log_level = vim.log.levels.ERROR,
		},

		config = function(_, opts)
			require("conform").setup(opts)

			-- Command to toggle format on save
			vim.api.nvim_create_user_command("FormatToggle", function()
				local current = require("conform").formatters_by_ft
				if vim.g.disable_format_on_save then
					vim.g.disable_format_on_save = false
					vim.notify("Format on save enabled", vim.log.levels.INFO)
				else
					vim.g.disable_format_on_save = true
					vim.notify("Format on save disabled", vim.log.levels.WARN)
				end
			end, { desc = "Toggle format on save" })

			-- Additional keymaps for specific formatters
			vim.keymap.set("n", "<leader>fp", function()
				require("conform").format({ formatters = { "isort", "black" } })
			end, { desc = "Format Python" })

			vim.keymap.set("n", "<leader>fl", function()
				require("conform").format({ formatters = { "stylua" } })
			end, { desc = "Format Lua" })

			vim.keymap.set("n", "<leader>fs", function()
				require("conform").format({ formatters = { "shfmt" } })
			end, { desc = "Format Shell" })

			vim.keymap.set("n", "<leader>fw", function()
				require("conform").format({ formatters = { "prettier" } })
			end, { desc = "Format Web (HTML/CSS/JS)" })
		end,
	},
}
