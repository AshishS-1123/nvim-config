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
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
          }
        }
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

      -- Optional Handy Tab Switching Shortcuts (Alt + Number)
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
        ensure_installed = { "javascript", "typescript", "rust", "dart", "lua", "c", "cpp", "markdown", "markdown_inline" },
        auto_install = true,
        highlight = {
          enable = true, -- Activate syntax highlighting
        },
      })
    end
  },

  -- 8. Theme
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme("vscode") end
  },

  -- 9. Smooth Scrolling Engine (Neoscroll)
  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup({
        -- Target these specific default navigation keys for smooth animations
        mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
        hide_cursor = true,          -- Temporarily hide cursor during scroll so it doesn't flicker
        stop_eof = true,             -- Stop scrolling smoothly at the end of the file
        respect_scrolloff = false,   -- Smooth glide regardless of cursor margins
        cursor_scrolls_alone = true, -- Cursor glides naturally if window boundaries are reached
        easing_function = "quadratic" -- Options: "linear", "quadratic", "cubic", "sine", "circular"
      })

      -- Customizing the scrolling speed directly
      local neoscroll = require('neoscroll')
      local keymap = {
        -- Format: neoscroll.scroll(lines, move_cursor, duration_in_ms)
        -- Increasing the duration_in_ms makes the scroll SLOWER and smoother.
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
  {
    "dnlhc/glance.nvim",
    config = function()
      require("glance").setup({
        height = 15, -- Height of the preview window body
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
            ["<Esc>"] = require("glance").actions.close, -- Press Esc to dismiss the preview container
            ["q"] = require("glance").actions.close,
          },
        },
      })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      
      -- Keymaps
      -- Search current file (Ctrl + F)
      vim.keymap.set('n', '<leader>f', builtin.current_buffer_fuse_grep or builtin.current_buffer_fuzzy_find, { desc = 'Search in current file' })
      
      -- Search entire project (Live Grep)
      vim.keymap.set('n', '<leader>F', builtin.live_grep, { desc = 'Project Search (Live Grep)' })
      -- Find files by name
      vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Find Files' })
    end
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- Override markdown rendering so Noice takes over
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        lsp_doc_border = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    }
  }
}

