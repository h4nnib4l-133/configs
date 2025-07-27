-- lua/plugins/debug.lua - Enhanced Python DAP with comprehensive features
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		"mfussenegger/nvim-dap-python",
		"theHamsta/nvim-dap-virtual-text", -- Show variable values inline
	},

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dap_python = require("dap-python")

		-- Setup mason-nvim-dap
		require("mason-nvim-dap").setup({
			automatic_installation = true,
			handlers = {},
			ensure_installed = { "debugpy" },
		})

		-- Enhanced Python DAP configuration
		-- Find python path - works with venv-selector
		local function get_python_path()
			local venv_path = os.getenv("VIRTUAL_ENV")
			if venv_path then
				return venv_path .. "/bin/python"
			end
			return "python"
		end

		-- Setup python debugging
		dap_python.setup(get_python_path())

		-- Custom Python debug configurations
		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				pythonPath = get_python_path,
				console = "integratedTerminal",
				cwd = "${workspaceFolder}",
			},
			{
				type = "python",
				request = "launch",
				name = "Launch file with arguments",
				program = "${file}",
				args = function()
					local args_string = vim.fn.input("Arguments: ")
					return vim.split(args_string, " ", true)
				end,
				pythonPath = get_python_path,
				console = "integratedTerminal",
				cwd = "${workspaceFolder}",
			},
			{
				type = "python",
				request = "launch",
				name = "Django",
				program = "${workspaceFolder}/manage.py",
				args = { "runserver", "--noreload" },
				pythonPath = get_python_path,
				console = "integratedTerminal",
				cwd = "${workspaceFolder}",
				django = true,
			},
			{
				type = "python",
				request = "launch",
				name = "Flask",
				module = "flask",
				env = {
					FLASK_APP = "${workspaceFolder}/app.py",
					FLASK_ENV = "development",
				},
				args = { "run", "--host=0.0.0.0", "--port=5000" },
				pythonPath = get_python_path,
				console = "integratedTerminal",
				cwd = "${workspaceFolder}",
			},
			{
				type = "python",
				request = "launch",
				name = "FastAPI",
				module = "uvicorn",
				args = { "main:app", "--reload" },
				pythonPath = get_python_path,
				console = "integratedTerminal",
				cwd = "${workspaceFolder}",
			},
			{
				type = "python",
				request = "attach",
				name = "Attach remote",
				connect = function()
					local host = vim.fn.input("Host [127.0.0.1]: ")
					host = host ~= "" and host or "127.0.0.1"
					local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
					return { host = host, port = port }
				end,
			},
			{
				type = "python",
				request = "launch",
				name = "Run pytest",
				module = "pytest",
				args = { "${file}" },
				pythonPath = get_python_path,
				console = "integratedTerminal",
				cwd = "${workspaceFolder}",
			},
			{
				type = "python",
				request = "launch",
				name = "Run current test function",
				module = "pytest",
				args = function()
					local line = vim.fn.line(".")
					local file = vim.fn.expand("%:p")
					-- Try to find the test function name
					local test_name = ""
					for i = line, 1, -1 do
						local line_content = vim.fn.getline(i)
						local match = string.match(line_content, "def (test_[%w_]+)")
						if match then
							test_name = "::" .. match
							break
						end
					end
					return { file .. test_name }
				end,
				pythonPath = get_python_path,
				console = "integratedTerminal",
				cwd = "${workspaceFolder}",
			},
		}

		-- Enhanced keymaps
		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
		vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Set Conditional Breakpoint" })
		vim.keymap.set("n", "<leader>lp", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end, { desc = "Debug: Set Log Point" })
		vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
		vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run Last" })

		-- Python-specific keymaps
		vim.keymap.set("n", "<leader>dn", function()
			require("dap-python").test_method()
		end, { desc = "Debug: Test Method" })
		vim.keymap.set("n", "<leader>df", function()
			require("dap-python").test_class()
		end, { desc = "Debug: Test Class" })
		vim.keymap.set("v", "<leader>ds", function()
			require("dap-python").debug_selection()
		end, { desc = "Debug: Selection" })

		-- Enhanced DAP UI setup
		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			mappings = {
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
				toggle = "t",
			},
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.25 },
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					size = 40,
					position = "left",
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					size = 10,
					position = "bottom",
				},
			},
			controls = {
				enabled = true,
				element = "repl",
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
			floating = {
				max_height = nil,
				max_width = nil,
				border = "single",
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			windows = { indent = 1 },
			render = {
				max_type_length = nil,
				max_value_lines = 100,
			},
		})

		-- Toggle DAP UI
		vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: Toggle UI" })

		-- Setup virtual text (shows variable values inline)
		require("nvim-dap-virtual-text").setup({
			enabled = true,
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = false,
			show_stop_reason = true,
			commented = false,
			only_first_definition = true,
			all_references = false,
			filter_references_pattern = "<module",
			virt_text_pos = "eol",
			all_frames = false,
			virt_lines = false,
			virt_text_win_col = nil,
		})

		-- Auto-open/close DAP UI
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Signs for breakpoints
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
		)
		vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
		)
	end,
}
