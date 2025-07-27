-- lua/plugins/lspconfig.lua - Fixed deprecated LSP servers for Neovim 0.11
return {
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/neodev.nvim", opts = {} },
		},

		config = function()
			-- LspAttach autocommand for keymaps and features
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Navigation
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Actions
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Enhanced Python-specific mappings
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.name == "pyright" then
						map("<leader>oi", function()
							vim.lsp.buf.execute_command({
								command = "pyright.organizeimports",
								arguments = { vim.uri_from_bufnr(0) },
							})
						end, "[O]rganize [I]mports")
					end

					-- Document highlighting
					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end
				end,
			})

			-- Enhanced capabilities for completion
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable snippet support for HTML/CSS
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Language server configurations with fixed deprecated names
			local servers = {
				pyright = {
					settings = {
						python = {
							analysis = {
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
								typeCheckingMode = "basic",
							},
						},
					},
				},
				-- Fixed: ruff_lsp is deprecated, use ruff instead
				ruff = {
					settings = {
						organizeImports = true,
						fixAll = true,
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									"${3rd}/luv/library",
									"${3rd}/busted/library",
								},
							},
							completion = { callSnippet = "Replace" },
							telemetry = { enable = false },
						},
					},
				},
				bashls = {
					settings = {
						bashIde = {
							globPattern = "*@(.sh|.inc|.bash|.command)",
						},
					},
				},
				dockerls = {},
				yamlls = {
					settings = {
						yaml = {
							schemas = {
								["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
								["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
									"docker-compose*.{yml,yaml}",
									"compose*.{yml,yaml}",
								},
							},
							validate = true,
							completion = true,
							hover = true,
						},
					},
				},
				html = {
					settings = {
						html = {
							format = { enable = true },
							hover = {
								documentation = true,
								references = true,
							},
						},
					},
				},
				cssls = {
					settings = {
						css = { validate = true },
						scss = { validate = true },
						less = { validate = true },
					},
				},
				emmet_ls = {
					settings = {
						emmet = {
							includeLanguages = {
								javascript = "javascriptreact",
								typescript = "typescriptreact",
							},
						},
					},
				},
				-- Fixed: tsserver is deprecated, use ts_ls instead
				ts_ls = {
					settings = {
						typescript = { format = { enable = true } },
						javascript = { format = { enable = true } },
					},
				},
				taplo = {}, -- TOML language server
			}

			-- Mason setup
			require("mason").setup()

			-- Install language servers and tools
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				-- Formatters
				"stylua",
				"isort",
				"black",
				"shfmt",
				"prettier",
				-- Linters
				"shellcheck",
				"hadolint",
				-- Debug adapters
				"debugpy",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- Mason-LSPConfig setup (compatible with Mason 2.0 and Neovim 0.11)
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			-- Configure each server
			for server_name, config in pairs(servers) do
				config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
				require("lspconfig")[server_name].setup(config)
			end
		end,
	},
}
