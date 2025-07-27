-- lua/plugins/harpoon.lua
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED: Setup harpoon with default config
		harpoon:setup()

		-- Basic keymaps
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Add file" })

		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Toggle menu" })

		-- Quick navigation to specific files
		vim.keymap.set("n", "<C-h>", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: File 1" })

		vim.keymap.set("n", "<C-t>", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: File 2" })

		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: File 3" })

		vim.keymap.set("n", "<C-s>", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: File 4" })

		-- Navigation through list
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end, { desc = "Harpoon: Previous" })

		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end, { desc = "Harpoon: Next" })

		-- Telescope integration for harpoon files
		vim.keymap.set("n", "<leader>sh", function()
			local conf = require("telescope.config").values
			local file_paths = {}
			for _, item in ipairs(harpoon:list().items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end, { desc = "[S]earch [H]arpoon files" })
	end,
}
