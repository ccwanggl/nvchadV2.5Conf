require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map({"i","n","v"}, "<leader>fp", "<cmd> NeoZoomToggle <CR>", {desc = "floating current pane" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
