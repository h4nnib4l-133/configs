-- Neovim 0.11 optimized configuration
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Enable Neovim 0.11 native features
if vim.fn.has("nvim-0.11") == 1 then
  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_node_provider = 0
end

-- Load configuration modules
require("options")
require("keymaps")
require("lazy-bootstrap")
require("lazy-plugins")
