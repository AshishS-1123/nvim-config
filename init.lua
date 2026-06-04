require("config.options")
require("config.lazy")
require("config.keymaps")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mousescroll = "ver:1,hor:1"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
    format = function(diagnostic)
      return string.format("%s", diagnostic.message)
    end,
  },
  severity_sort = true,
  float = {
    border = "rounded",
  },
})

-- Styling for the hover docs window
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e222a", fg = "#56b6c2" })

local function trigger_hover()
  if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
    vim.lsp.buf.hover({ focusable = false, border = "rounded" })
  end
end

vim.keymap.set('n', '<C-k>', trigger_hover, { desc = "LSP Hover Docs in Normal Mode", silent = true })
vim.keymap.set('i', '<C-k>', trigger_hover, { desc = "LSP Hover Docs in Insert Mode", silent = true })

