local opt = vim.opt

-- Enable mouse support for clicking, resizing splits, etc.
opt.mouse = "a"

-- Sync Neovim clipboard with Ubuntu system clipboard (Ctrl+C / Ctrl+V compatibility)
opt.clipboard = "unnamedplus"

-- Line numbers
opt.number = true
opt.relativenumber = true -- Great for jumping lines, disable if you prefer strict VS Code style

-- Tabs & Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Code Folding (VS Code style behavior using nvim-ufo later)
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
