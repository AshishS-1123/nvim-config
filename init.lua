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

vim.cmd('colorscheme everblush')

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    pcall(vim.treesitter.stop)
  end
})

vim.keymap.set('n', '<C-k>', trigger_hover, { desc = "LSP Hover Docs in Normal Mode", silent = true })
vim.keymap.set('i', '<C-k>', trigger_hover, { desc = "LSP Hover Docs in Insert Mode", silent = true })
vim.keymap.set({'n', 'v'}, '<C-LeftMouse>', smart_definition_handler, { desc = "LSP Definition via Ctrl+Click", silent = true })

vim.api.nvim_create_user_command("SafeClose", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local listed_bufs = vim.fn.getbufinfo({ buflisted = 1 })
  
  local normal_bufs = {}
  for _, b in ipairs(listed_bufs) do
    local ft = vim.bo[b.bufnr].filetype
    local bt = vim.bo[b.bufnr].buftype
    if ft ~= "neo-tree" and ft ~= "aerial" and bt == "" and vim.bo[b.bufnr].buflisted then
      table.insert(normal_bufs, b.bufnr)
    end
  end

  if #normal_bufs > 1 then
    vim.cmd("bnext")
    pcall(vim.cmd, "bd " .. current_buf)
  else
    local buf_name = vim.api.nvim_buf_get_name(current_buf)
    local is_empty_dummy = buf_name == "" and not vim.bo[current_buf].modified
    
    if is_empty_dummy then
      vim.cmd("noautocmd qall")
    else
      vim.cmd("enew")
      if vim.api.nvim_buf_is_valid(current_buf) then
        pcall(vim.cmd, "bd " .. current_buf)
      end
    end
  end
end, {})

vim.cmd([[cnoreabbrev <expr> q (getcmdtype() == ':' && getcmdline() == 'q') ? 'SafeClose' : 'q']])

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("RecoverLayout", { clear = true }),
  callback = function()
    if vim.fn.expand("%") == "[Command Line]" then return end
    
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local only_sidebars = true
    
    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      local bt = vim.bo[buf].buftype
      
      if ft ~= "neo-tree" and ft ~= "aerial" and ft ~= "qf" and ft ~= "help" and ft ~= "" then
        only_sidebars = false
        break
      end
      if ft == "" and bt == "" then
        only_sidebars = false
        break
      end
    end
    
    if only_sidebars then
      pcall(vim.cmd, "AerialClose")
      pcall(vim.cmd, "Neotree close")
      vim.cmd("enew")              -- Spawn clean center staging window
      pcall(vim.cmd, "Neotree show") -- Restore your left side explorer
    end
  end,
})

-- Force current matching bracket pair to light up clearly
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  callback = function()
    -- Style 1: Subtle, modern background block highlight
    vim.api.nvim_set_hl(0, "MatchParen", { 
      fg = "NONE",    -- Deep background color matching Everblush text rows
      bg = "#323641",    -- Vibrant Everblush Cyan backdrop to make the character pop
      bold = true,       -- Thicken the bracket font weight
    })
  end,
})

