-- lua/plugins/debug.lua - Native DAP without Mason
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
    "theHamsta/nvim-dap-virtual-text",
  },

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_python = require("dap-python")

    -- Find python path - works with venv-selector
    local function get_python_path()
      local venv_path = os.getenv("VIRTUAL_ENV")
      if venv_path then
        return venv_path .. "/bin/python"
      end
      return "python"
    end

    -- Setup python debugging (requires: pip install debugpy)
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

    -- Enhanced DAP UI setup
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
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
    })

    vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: Toggle UI" })

    -- Setup virtual text
    require("nvim-dap-virtual-text").setup({
      enabled = true,
      highlight_changed_variables = true,
      show_stop_reason = true,
    })

    -- Auto-open/close DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- Breakpoint signs
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine" })
  end,
}