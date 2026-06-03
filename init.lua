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

