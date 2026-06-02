local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Ctrl + S to Save (Normal, Insert, and Visual modes)
keymap({ "n", "i", "v" }, "<C-s>", "<Cmd>w<CR><Esc>", { desc = "Save File" })

-- Ctrl + C / Ctrl + V for Copy/Paste
-- Note: 'unnamedplus' handles this natively with y/p, but these force standard OS behavior
keymap("v", "<C-c>", '"+y', opts)
keymap("v", "<C-v>", '"+P', opts)
keymap("i", "<C-v>", '<C-r>+', opts)

-- Ctrl + K, S to Save All Files
keymap("n", "<C-k>s", "<Cmd>wa<CR>", { desc = "Save All Files" })

-- Ctrl + K, W to Close All Buffers/Files (Without exiting Neovim)
keymap("n", "<C-k>w", "<Cmd>bufdo bd<CR>", { desc = "Close All Files" })

-- Quick toggle for File Explorer (Like Ctrl+B in VS Code)
keymap("n", "<C-b>", "<Cmd>Neotree toggle<CR>", opts)
