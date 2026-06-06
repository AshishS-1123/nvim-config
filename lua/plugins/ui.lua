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
        ft_ignore = { "neo-tree", "lazy", "mason", "toggleterm", "alpha" },
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
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    }
  },
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "*",
    dependencies = "rafamadriz/friendly-snippets",
    opts = {
      keymap = { preset = "default" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    config = function(_, opts)
      local blink = require("blink.cmp")
      blink.setup(opts)
  
      vim.api.nvim_create_autocmd("TextChangedI", {
        group = vim.api.nvim_create_augroup("BlinkAutoCloseExactMatch", { clear = true }),
        callback = function()
          vim.schedule(function()
            if blink.is_visible() then
              local cursor = vim.api.nvim_win_get_cursor(0)
              local line = vim.api.nvim_get_current_line()
              local col = cursor[2]
              
              local before_cursor = line:sub(1, col)
              local current_word = vim.trim(before_cursor:match("[%w_]+$") or "")

              if current_word then
                local list = require("blink.cmp.completion.list")
                for i = 1, math.min(5, #list.items) do
                  item = list.items[i]
                  if vim.trim(item.filterText or "") == current_word then
                    blink.hide()
                    break
                  end
                end
              end
            end
          end)
        end,
      })
    end,
  }
}
  
