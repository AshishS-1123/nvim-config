vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

local function smart_definition_handler()
  -- 1. Get the precise matrix position of the mouse click
  local mouse_pos = vim.fn.getmousepos()
  if mouse_pos.winid == 0 or mouse_pos.line == 0 then return end
  
  -- 2. Teleport the cursor to the mouse click location safely
  vim.api.nvim_set_current_win(mouse_pos.winid)
  vim.api.nvim_win_set_cursor(mouse_pos.winid, { mouse_pos.line, mouse_pos.column - 1 })
  
  -- 3. Fetch active LSP clients for the current buffer
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return end
  
  -- FIX #1: Provide the explicit position_encoding from your active LSP client
  local position_encoding = clients[1].offset_encoding or "utf-16"
  local params = vim.lsp.util.make_position_params(0, position_encoding)
  
  -- 4. Query the LSP client for definition data
  local timeout_ms = 1000
  local response = vim.lsp.buf_request_sync(0, "textDocument/definition", params, timeout_ms)
  
  if not response or vim.tbl_isempty(response) then
    vim.lsp.buf.definition()
    return
  end
  
  local _, result = next(response)
  local locs = result.result
  if not locs or vim.tbl_isempty(locs) then return end
  
  local target = locs[1] or locs
  local target_uri = target.uri or target.targetUri
  local current_uri = vim.uri_from_bufnr(0)
  
  -- 5. Route navigation based on file location
  if target_uri ~= current_uri then
    -- DIFFERENT FILE: Open it normally as a new buffer slot
    vim.lsp.buf.definition()
  else
    -- SAME FILE: Open a scrollable preview container using Glance
    -- FIX #2: Changed from 'definition' (singular) to 'definitions' (plural)
    vim.cmd("Glance definitions")
  end
end

vim.keymap.set('n', '<C-k>', trigger_hover, { desc = "LSP Hover Docs in Normal Mode", silent = true })
vim.keymap.set('i', '<C-k>', trigger_hover, { desc = "LSP Hover Docs in Insert Mode", silent = true })
vim.keymap.set({'n', 'v'}, '<C-LeftMouse>', smart_definition_handler, { desc = "LSP Definition via Ctrl+Click", silent = true })

