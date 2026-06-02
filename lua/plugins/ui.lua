return {
  -- 1. File Explorer (Neo-tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = function()
      require("neo-tree").setup({
        enable_mouse_support = true,
        default_component_configs = {
          -- Adjusts the layout spacing
          indent = {
            with_expanders = true, -- Shows nice arrows next to folders
            expander_collapsed = "",
            expander_expanded = "",
          },
          -- Modifies the icon rendering space
          icon = {
            folder_closed = " ", -- Notice the extra space inside the quotes
            folder_open = " ",   -- This adds breathing room, making them look bigger
            folder_empty = "󰜮 ",
            default = "󰈚 ",
            highlight = "NeoTreeFileIcon",
          },
          name = {
            trailing_slash = true,
            use_git_status_colors = true,
          },
        },
      })
    end
  },

  -- 2. VS Code-Style Tabs (Bufferline)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          show_buffer_close_icons = true, -- Adds the 'X' close icon on tabs
          show_close_icon = true,
          diagnostics = "nvim_lsp",       -- Shows LSP error/warning hints on tabs
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorer",
              text_align = "left",
              separator = true,
            }
          },
        }
      })

      -- Optional Handy Tab Switching Shortcuts (Alt + Number)
      local map = vim.keymap.set
      map("n", "<A-1>", "<Cmd>BufferLineGoToBuffer 1<CR>", { silent = true })
      map("n", "<A-2>", "<Cmd>BufferLineGoToBuffer 2<CR>", { silent = true })
      map("n", "<A-3>", "<Cmd>BufferLineGoToBuffer 3<CR>", { silent = true })
      map("n", "<A-4>", "<Cmd>BufferLineGoToBuffer 4<CR>", { silent = true })
      map("n", "<A-5>", "<Cmd>BufferLineGoToBuffer 5<CR>", { silent = true })
      map("n", "<A-6>", "<Cmd>BufferLineGoToBuffer 6<CR>", { silent = true })
      map("n", "<A-7>", "<Cmd>BufferLineGoToBuffer 7<CR>", { silent = true })
      map("n", "<A-8>", "<Cmd>BufferLineGoToBuffer 8<CR>", { silent = true })
      map("n", "<A-9>", "<Cmd>BufferLineGoToBuffer 9<CR>", { silent = true })
      map("n", "<A-10>", "<Cmd>BufferLineGoToBuffer 10<CR>", { silent = true })
      map("n", "<A-11>", "<Cmd>BufferLineGoToBuffer 11<CR>", { silent = true })
      map("n", "<A-12>", "<Cmd>BufferLineGoToBuffer 12<CR>", { silent = true })
      map("n", "<A-13>", "<Cmd>BufferLineGoToBuffer 13<CR>", { silent = true })
      map("n", "<A-14>", "<Cmd>BufferLineGoToBuffer 14<CR>", { silent = true })
      map("n", "<A-15>", "<Cmd>BufferLineGoToBuffer 15<CR>", { silent = true })
      map("n", "<A-16>", "<Cmd>BufferLineGoToBuffer 16<CR>", { silent = true })
      map("n", "<A-17>", "<Cmd>BufferLineGoToBuffer 17<CR>", { silent = true })
      map("n", "<A-18>", "<Cmd>BufferLineGoToBuffer 18<CR>", { silent = true })
      map("n", "<A-19>", "<Cmd>BufferLineGoToBuffer 19<CR>", { silent = true })
      map("n", "<A-20>", "<Cmd>BufferLineGoToBuffer 20<CR>", { silent = true })
      map("n", "<A-p>", "<Cmd>BufferLineCyclePrev<CR>", { silent = true })
      map("n", "<A-n>", "<Cmd>BufferLineCycleNext<CR>", { silent = true })
    end
  },

  -- 3. Clickable Gutter Column (Statuscol) - Crucial for clickable folding arrows
  -- 3. Clickable Gutter Column (Statuscol) - Configured for Dual Line Numbers
  {
    "luukvbaal/statuscol.nvim",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        ft_ignore = { "neo-tree", "lazy", "mason", "toggleterm", "alpha" },
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" }, -- Clickable Fold Arrows
          { text = { "%s" }, click = "v:lua.ScSa" },             -- Git Signs / Breakpoints
          
          -- COLUMN 1: Relative Line Numbers (Perfect for quick jumps)
          {
            text = { builtin.lnumfunc, "│" },
            hl = "LineNr", -- Uses the standard, brighter line number color
            click = "v:lua.ScLa",
          },
          -- COLUMN 2: Pure Absolute Line Numbers (Perfect for Debugging)
          {
            text = {
              function(args)
                -- Right-aligns and pads the numbers cleanly up to 999 lines (change to %4d if working in massive files)
                return string.format("%2d", args.lnum)
              end,
              " "
            },
            hl = "NonText", -- Uses a dimmer color group so it doesn't clutter your vision
            click = "v:lua.ScLa",
          },
        },
      })
    end,
  },

  -- 4. Code Folding Engine (Nvim-ufo)
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      -- Configure Neovim's core fold options to display arrows nicely
      vim.o.foldcolumn = '2' -- Show fold column
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      
      -- Define modern VS Code style arrow symbols for folding
      vim.opt.fillchars = { 
        foldopen = "▼",   -- Large solid down triangle
        foldclose = "▶",  -- Large solid right triangle
        fold = " ", 
        foldsep = " " 
      }

      require("ufo").setup({
        provider_selector = function(_, _, _)
          return { "lsp", "indent" } -- Uses your LSP setup to determine fold boundaries
        end
      })
    end
  },

  -- 5. Interactive Breadcrumbs & Symbol Navigation (Dropbar)
  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- Generates a clickable winbar breadcrumb at the top of every file
      require("dropbar").setup()
      
      vim.api.nvim_set_hl(0, "WinBar", { fg = "#c5c5c5", bg = "#252526" })
      vim.api.nvim_set_hl(0, "WinBarNC", { fg = "#858585", bg = "#252526" })

      vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("DropbarForce", { clear = true }),
        pattern = "*",
        callback = function()
          -- Only apply to actual source code files (skips neo-tree, terminal rows, and empty dashboards)
          if vim.bo.buftype == "" and vim.bo.filetype ~= "neo-tree" and vim.fn.win_gettype() == "" then
            vim.wo.winbar = "%{%v:lua.dropbar()%}"
          end
        end,
      })
    end
  },

  -- 6. Git Gutters
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("gitsigns").setup() end
  },

  -- 7. Syntax Highlighting (Treesitter)
{
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      
      -- Initialize default setup
      ts.setup({
        ensure_installed = { "javascript", "typescript", "rust", "dart", "lua", "c", "cpp" },
        highlight = {
          enable = true, -- Activate syntax highlighting
        },
      })
      
      -- Install parsers asynchronously in the background
      ts.install({ "javascript", "typescript", "rust", "dart", "lua" })

      -- Natively activate Neovim's built-in Tree-sitter engine
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          
          -- Safe Guard: Only trigger syntax highlighting if the parser is ready
          if lang and vim.treesitter.language.add(lang) then
            pcall(vim.treesitter.start, args.buf)
          end
        end,
      })
    end
  },

  -- 8. Theme
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme("vscode") end
  }
}
