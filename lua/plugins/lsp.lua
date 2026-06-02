return {
  -- LSP Configuration & Automation
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- 1. Initialize Mason to automatically download your servers
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "rust_analyzer", "clangd" }, 
      })

      -- 2. Natively activate the JavaScript/TypeScript language server
      -- (We don't call it for rust_analyzer because rustaceanvim below handles that automatically)
      vim.lsp.enable("ts_ls")

      -- 3. Modern Dart/Flutter setup using the new native API
      vim.lsp.config("dartls", {
        cmd = { "dart", "language-server", "--protocol=lsp" },
      })
      vim.lsp.enable("dartls")

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
      })
      vim.lsp.enable("clangd")
    end
  },

  -- Specialized Rust Plugin (Gives you VS Code-level Rust features seamlessly)
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
  },

  -- Fast Code Completion / Suggestions (Blink.cmp)
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "super-tab" }, -- Tab cycles suggestions, Enter accepts
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  }
}
