return {
  -- LSP Configuration & Automation
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "rust_analyzer", "clangd" }, 
      })

      vim.lsp.enable("ts_ls")

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
      keymap = { preset = "super-tab" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  }
}
