return {
  -- File Explorer (Neo-tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = function()
      require("neo-tree").setup({
        enable_mouse_support = true,
        default_component_configs = {
          indent = {
            with_expanders = true,
            expander_collapsed = "",
            expander_expanded = "",
          },
          icon = {
            folder_closed = " ",
            folder_open = " ",
            folder_empty = "󰜮 ",
            default = "󰈚 ",
            highlight = "NeoTreeFileIcon",
          },
          name = {
            trailing_slash = true,
            use_git_status_colors = true,
          },
        },
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
          }
        }
      })
    end
  },

  --  VS Code-Style Tabs (Bufferline)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          show_buffer_close_icons = true,
          show_close_icon = true,
          diagnostics = "nvim_lsp",
          numbers = "ordinal",
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

      local map = vim.keymap.set
      map("n", "<Leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", { silent = true })
      map("n", "<Leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", { silent = true })
      map("n", "<Leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", { silent = true })
      map("n", "<Leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", { silent = true })
      map("n", "<Leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", { silent = true })
      map("n", "<Leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", { silent = true })
      map("n", "<Leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", { silent = true })
      map("n", "<Leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", { silent = true })
      map("n", "<Leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", { silent = true })
      map("n", "<Leader>p", "<Cmd>BufferLineCyclePrev<CR>", { silent = true })
      map("n", "<Leader>n", "<Cmd>BufferLineCycleNext<CR>", { silent = true })
    end
  },

  --  Clickable Gutter Column (Statuscol) - Configured for Dual Line Numbers
  {
    "luukvbaal/statuscol.nvim",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        ft_ignore = { "neo-tree", "lazy", "mason", "toggleterm", "alpha", "aerial" },
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          { text = { "%s" }, click = "v:lua.ScSa" },
          
          {
            text = { builtin.lnumfunc, "│" },
            hl = "NonText",
            click = "v:lua.ScLa",
          },
          {
            text = {
              function(args)
                return string.format("%2d", args.lnum)
              end,
              " "
            },
            hl = "NonText",
            click = "v:lua.ScLa",
          },
        },
      })
    end,
  },

  -- Folding Engine (Nvim-ufo)
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.o.foldcolumn = '2'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      
      vim.opt.fillchars = { 
        foldopen = "▼",
        foldclose = "▶",
        fold = " ", 
        foldsep = " " 
      }

      require("ufo").setup({
        provider_selector = function(bufnr, fileType, buftype)
          if fileType == "neo-tree" then 
            return ""
          end
          return { "lsp", "indent" }
        end
      })
    end
  },

  --  Interactive Breadcrumbs & Symbol Navigation (Dropbar)
  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("dropbar").setup()
      
      vim.api.nvim_set_hl(0, "WinBar", { fg = "#c5c5c5", bg = "#252526" })
      vim.api.nvim_set_hl(0, "WinBarNC", { fg = "#858585", bg = "#252526" })

      vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("DropbarForce", { clear = true }),
        pattern = "*",
        callback = function()
          if vim.bo.buftype == "" and vim.bo.filetype ~= "neo-tree" and vim.fn.win_gettype() == "" then
            vim.wo.winbar = "%{%v:lua.dropbar()%}"
          end
        end,
      })
    end
  },

  --  Git Gutters
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("gitsigns").setup() end
  },

  --  Syntax Highlighting (Treesitter)
{
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      
      ts.setup({
        ensure_installed = { "javascript", "typescript", "rust", "dart", "lua", "c", "cpp", "markdown", "markdown_inline" },
        auto_install = true,
        highlight = {
          enable = true,
          disable = false,
        },
      })
    end
  },

  --  Theme
  { "Everblush/nvim", name = "everblush" },

  --  Smooth Scrolling Engine (Neoscroll)
  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup({
        mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "quadratic"
      })

      local neoscroll = require('neoscroll')
      local keymap = {
        ["<C-d>"] = function() neoscroll.scroll(vim.wo.scroll, true, 350) end,
        ["<C-u>"] = function() neoscroll.scroll(-vim.wo.scroll, true, 350) end,
        ["<C-f>"] = function() neoscroll.scroll(vim.api.nvim_win_get_height(0), true, 450) end,
        ["<C-b>"] = function() neoscroll.scroll(-vim.api.nvim_win_get_height(0), true, 450) end,
      }

      for key, func in pairs(keymap) do
        vim.keymap.set('n', key, func)
        vim.keymap.set('x', key, func)
        vim.keymap.set('i', key, func, { silent = true })
      end
    end
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { },
  },
  -- Peek Preview 
  {
    "dnlhc/glance.nvim",
    config = function()
      require("glance").setup({
        height = 15,
        detached = true,
        skip_empty_open = true,
        list = {
          position = 'right',
          width = 0.2,
        },
        border = {
          enable = true,
          top_char = "─", bottom_char = "─", left_char = "│", right_char = "│",
          top_left_char = "╭", top_right_char = "╮", bottom_left_char = "╰", bottom_right_char = "╯",
        },
        mappings = {
          list = {
            ["<Esc>"] = require("glance").actions.close,
            ["q"] = require("glance").actions.close,
          },
        },
      })
    end,
  },
  -- File and Global Search.
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      
      -- Search current file (Ctrl + F)
      vim.keymap.set('n', '<leader>f', builtin.current_buffer_fuse_grep or builtin.current_buffer_fuzzy_find, { desc = 'Search in current file' })
      
      -- Search entire project (Live Grep)
      vim.keymap.set('n', '<leader>F', builtin.live_grep, { desc = 'Project Search (Live Grep)' })
      -- Find files by name
      vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Find Files' })
    end
  },
  -- Creating windows for stuff.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
          ["vim.lsp.util.stylize_markdown"] = false,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        lsp_doc_border = true,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "emsg",
          },
          view = "notify",
        },
        {
          filter = { error = true },
          view = "notify",
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    }
  },
  -- Aerial for showing minimap.
  {
    "stevearc/aerial.nvim",
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("aerial").setup({
        -- Backends used to harvest the functions/classes (LSP is preferred, falls back to Treesitter)
        backends = { "lsp", "treesitter", "markdown", "man" },
        open_automatic = true,
  
        layout = {
          default_direction = "right", -- Places the pane on the right side
          width = 35,                 -- Width of the pane
          min_width = 25,
          max_width = 0.5,            -- Max 50% of the screen
        },
  
        -- Restrict symbols to just classes, methods, and functions as requested
        filter_kind = {
          "Class",
          "Constructor",
          "Enum",
          "Function",
          "Interface",
          "Module",
          "Method",
          "Struct",
        },
  
        -- Keymaps inside the aerial sidebar pane
        keymaps = {
          ["<LeftMouse>"] = "actions.jump",   -- Single-click to jump to definition
          ["h"] = "actions.tree_close",       -- Collapse node
          ["l"] = "actions.tree_open",        -- Expand node
          ["zo"] = "actions.tree_open",       -- Standard vim fold open
          ["zc"] = "actions.tree_close",      -- Standard vim fold close
          ["zA"] = "actions.tree_toggle_recursive",
          ["<LeftMouse>"] = function()
            local actions = require("aerial.actions")
            actions.tree_toggle() -- Expand/collapse the item in the sidebar
            actions.jump()        -- Jump your main cursor to the definition
          end,
          ["<CR>"] = function()
            local actions = require("aerial.actions")
            actions.tree_toggle() -- Expand/collapse the item in the sidebar
            actions.jump()        -- Jump your main cursor to the definition
          end,
        },
  
        -- Manage icons and formatting
        show_guides = true, -- Shows tree guide lines for collapsible structures
        guides = {
          mid_item = "├─ ",
          last_item = "└─ ",
          nested_top = "│ ",
          whitespace = "  ",
        },
      })
  
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "aerial",
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = "no"
          vim.opt_local.foldcolumn = "0"
        end,
      })

      -- Keymap to toggle the code outline pane (sets it to Space + o)
      vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle! right<CR>", { desc = "Toggle Code Outline" })
    end,
  },
  -- Colored brackets.
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('rainbow-delimiters.setup').setup({
        strategy = {
          [''] = require('rainbow-delimiters').strategy['global'],
        },
      })

      local colors = {
        ["RainbowDelimiterRed"]    = { fg = "#e57474" }, -- Soft Red
        ["RainbowDelimiterYellow"] = { fg = "#e1bb7e" }, -- Muted Gold/Yellow
        ["RainbowDelimiterBlue"]   = { fg = "#67b0e8" }, -- Pastel Blue
        ["RainbowDelimiterOrange"] = { fg = "#e5c07b" }, -- Warm Amber
        ["RainbowDelimiterGreen"]  = { fg = "#8ccf7e" }, -- Soft Teal/Green
        ["RainbowDelimiterViolet"] = { fg = "#c47fd5" }, -- Muted Purple
        ["RainbowDelimiterCyan"]   = { fg = "#6cbfbf" }, -- Desaturated Cyan
      }

      for group, opts in pairs(colors) do
        vim.api.nvim_set_hl(0, group, opts)
      end
    end
  },
  -- Inline Virtual Text Block End-Labels (Safe & Smart Flutter Resolver)
  {
    "haringsrob/nvim_context_vt",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('nvim_context_vt').setup({
        -- Custom prefix to keep it looking clean and faint
        prefix = " ⟹ ",
        
        -- Disable by default for specific files if they get too noisy
        disable_ft = { "markdown", "yaml", "dart" },
        
        -- Controls what nodes are looked at (Functions, classes, conditional statements, loops)
        filter = function(node, bufnr)
          return true
        end,
      })

      -- Make the characters faint/dim by linking them to a commentary or non-text highlight group
      vim.api.nvim_set_hl(0, "ContextVt", { fg = "#4b6875", italic = true })
    end
  },
  -- Dedicated Flutter & Dart tooling suite
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false, -- Load explicitly for immediate Dart buffer hooks
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- Optional but gives beautiful UI selections
    },
    config = function()
      require("flutter-tools").setup({
        -- 1. NATIVE CLOSING LABELS (Fixes your bracket bug completely!)
        closing_tags = {
          highlight = "ContextVt", -- Maps perfectly to your Everblush color palette
          prefix = " ⟹  ",          -- Use the custom arrow style you prefer
          enabled = true,
        },
        
        -- 2. FLUTTER INTEGRATIONS
        widget_guides = {
          enabled = true, -- Optional: Draws subtle visual guidelines down nested elements
        },
        
        -- 3. AUTOMATIC LANGUAGE SERVER CONFIG
        lsp = {
          color = {
            enabled = true, -- Automatically parses color codes into UI highlights
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
          }
        }
      })
    end
  },
  -- Automatic Bracket Pairing and Smart Formatting
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      
      autopairs.setup({
        check_ts = true, -- Leverage Tree-sitter for intelligent code context
        disable_filetype = { "TelescopePrompt" },
      })

      -- Add the dynamic rule to make <Enter> format your scopes
      local Rule = require('nvim-autopairs.rule')
      local cond = require('nvim-autopairs.conds')

      -- Target matching pairs: {}, [], ()
      local brackets = { { '{', '}' }, { '[', ']' }, { '(', ')' } }
      
      autopairs.add_rules({
        -- This forces brackets to break smoothly onto 3 clean indented lines
        Rule(' ', ' ')
          :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({ '()', '[]', '{}' }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          :with_del(function(opts)
            local col = opts.col
            local line = opts.line
            local pair = line:sub(col - 1, col)
            return vim.tbl_contains({ '  ' }, pair)
          end)
      })
    end
  },
}

