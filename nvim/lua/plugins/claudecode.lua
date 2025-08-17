-- lua/plugins/claudecode.lua - Claude Code integration
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("claudecode").setup({
      -- Configuration options
      port = 0, -- 0 means auto-select available port
      timeout = 5000, -- Connection timeout in ms
      debug = false, -- Enable debug logging
    })

    -- Key mappings for Claude Code
    vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
    vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" })
    vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept Claude diff" })
    vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Reject Claude diff" })
    vim.keymap.set("n", "<leader>at", "<cmd>ClaudeCodeToggleTerminal<cr>", { desc = "Toggle Claude terminal" })
  end,
}