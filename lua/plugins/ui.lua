return {
  -- File Explorer (Neo-tree) with mouse click support
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = function()
      require("neo-tree").setup({
        enable_mouse_support = true,
        window = {
          mappings = {
          }
        }
      })
    end
  },

  -- Git Gutters (VS Code style modified/added indicators next to line numbers)
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("gitsigns").setup() end
  },

  -- Fast Syntax Highlighting (Updated for Modern Tree-sitter standards)
{
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      
      -- Initialize default setup
      ts.setup({
        ensure_installed = { "javascript", "typescript", "rust", "dart", "lua" },
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

  -- VS Code Style Code Folding (nvim-ufo)
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      require("ufo").setup()
    end
  },

  -- VS Code Dark Modern Theme (To make it visually familiar)
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("vscode")
    end
  }
}
