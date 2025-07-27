-- lua/plugins/treesitter.lua - Fixed jsx parser and enhanced configuration
return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects", -- Enhanced text objects
		},
		opts = {
			ensure_installed = {
				-- Core languages you wanted
				"python",
				"lua",
				"bash",

				-- Web development
				"html",
				"css",
				"scss",
				"javascript",
				"typescript",
				"tsx", -- JSX is handled by tsx parser now
				-- Removed "jsx" as it's deprecated - JSX syntax is handled by javascript/typescript parsers
				"json",
				"jsonc",

				-- Configuration files
				"yaml",
				"toml",
				"dockerfile",

				-- Documentation
				"markdown",
				"markdown_inline",
				"rst",

				-- Others
				"vim",
				"vimdoc",
				"query",
				"regex",
				"git_config",
				"git_rebase",
				"gitcommit",
				"gitignore",
				"sql",
				"xml",
				"ninja",

				-- Additional useful ones
				"comment",
				"diff",
				"gitattributes",
			},

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			auto_install = true,

			-- List of parsers to ignore installing (for "all")
			ignore_install = {},

			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system for indent rules
				additional_vim_regex_highlighting = { "ruby", "markdown" },

				-- Disable for large files
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},

			indent = {
				enable = true,
				disable = { "ruby", "python" }, -- Python indenting can be problematic
			},

			-- Enhanced text objects
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj
					keymaps = {
						-- Function textobjects
						["af"] = "@function.outer",
						["if"] = "@function.inner",

						-- Class textobjects
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",

						-- Conditional textobjects
						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.inner",

						-- Loop textobjects
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",

						-- Parameter textobjects
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",

						-- Comment textobjects
						["a/"] = "@comment.outer",
						["i/"] = "@comment.inner",
					},
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
					include_surrounding_whitespace = true,
				},

				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
						["]A"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
					},
				},

				swap = {
					enable = true,
					swap_next = {
						["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
						["<leader>nf"] = "@function.outer", -- swap function with next
					},
					swap_previous = {
						["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
						["<leader>pf"] = "@function.outer", -- swap function with previous
					},
				},
			},

			-- Incremental selection
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = "<C-s>",
					node_decremental = "<C-backspace>",
				},
			},
		},

		config = function(_, opts)
			-- Prefer git instead of curl for better connectivity
			require("nvim-treesitter.install").prefer_git = true

			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)

			-- Additional treesitter configuration

			-- Folding based on treesitter
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.opt.foldenable = false -- Don't fold by default

			-- Custom queries for better highlighting (example for Python)
			vim.treesitter.query.set(
				"python",
				"highlights",
				[[
        ; Highlight TODO, FIXME, etc. in comments
        ((comment) @todo
         (#match? @todo "TODO|FIXME|HACK|BUG|NOTE"))
      ]]
			)

			-- Language-specific configurations
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "dockerfile" },
				callback = function()
					-- Set specific settings for Dockerfile
					vim.opt_local.commentstring = "# %s"
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "yaml", "yml" },
				callback = function()
					-- YAML specific settings
					vim.opt_local.tabstop = 2
					vim.opt_local.shiftwidth = 2
					vim.opt_local.expandtab = true
				end,
			})

			-- Enable treesitter-based indentation for specific filetypes
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "javascript", "typescript", "html", "css", "lua" },
				callback = function()
					vim.opt_local.indentexpr = "nvim_treesitter#indent()"
				end,
			})

			-- Show treesitter capture groups under cursor (helpful for debugging)
			vim.keymap.set("n", "<leader>ti", function()
				local result = vim.treesitter.get_captures_at_cursor(0)
				print(vim.inspect(result))
			end, { desc = "[T]reesitter [I]nspect" })

			-- Toggle treesitter highlighting
			vim.keymap.set("n", "<leader>th", function()
				if vim.b.ts_highlight then
					vim.treesitter.stop()
					vim.b.ts_highlight = false
					vim.notify("Treesitter highlighting disabled", vim.log.levels.INFO)
				else
					vim.treesitter.start()
					vim.b.ts_highlight = true
					vim.notify("Treesitter highlighting enabled", vim.log.levels.INFO)
				end
			end, { desc = "[T]reesitter [H]ighlighting toggle" })
		end,
	},
}
