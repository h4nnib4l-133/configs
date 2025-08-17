-- lua/plugins/lspconfig.lua - Pure native Neovim 0.11 LSP (no Mason)
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      -- Native Neovim 0.11 LSP capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      
      -- Enhanced snippet support
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
      }

      -- LSP attach configuration
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Navigation
          map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
          map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
          map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
          map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
          map("<leader>ds", vim.lsp.buf.document_symbol, "[D]ocument [S]ymbols")
          map("<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbols")

          -- Actions
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- Diagnostics
          map("<leader>e", vim.diagnostic.open_float, "Show diagnostic [E]rror")
          map("[d", vim.diagnostic.goto_prev, "Previous [D]iagnostic")
          map("]d", vim.diagnostic.goto_next, "Next [D]iagnostic")
          map("<leader>q", vim.diagnostic.setloclist, "Diagnostic [Q]uickfix list")

          -- Document highlighting for Neovim 0.11
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
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
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- Inlay hints for Neovim 0.11 (if supported)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- Enhanced diagnostic configuration for 0.11
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "»",
          },
        },
      })

      -- Direct LSP server setup (no Mason)
      local lspconfig = require("lspconfig")

      -- Lua LSP
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
            },
            telemetry = { enable = false },
            hint = { enable = true },
          },
        },
      })

      -- Python LSP (requires: pip install basedpyright)
      lspconfig.basedpyright.setup({
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "standard",
            },
          },
        },
      })

      -- Ruff for Python linting (requires: pip install ruff-lsp)
      lspconfig.ruff.setup({
        capabilities = capabilities,
        init_options = {
          settings = {
            organizeImports = true,
            fixAll = true,
          },
        },
      })

      -- TypeScript/JavaScript (requires: npm install -g typescript-language-server)
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
        },
      })

      -- HTML/CSS (requires: npm install -g vscode-langservers-extracted)
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })
      
      -- JSON (requires: npm install -g vscode-langservers-extracted)
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- Bash (requires: npm install -g bash-language-server)
      lspconfig.bashls.setup({ capabilities = capabilities })

      -- Docker (requires: npm install -g dockerfile-language-server-nodejs)
      lspconfig.dockerls.setup({ capabilities = capabilities })

      -- YAML (requires: npm install -g yaml-language-server)
      lspconfig.yamlls.setup({
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            },
            validate = true,
            completion = true,
          },
        },
      })
    end,
  },
  -- JSON schema support
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
}