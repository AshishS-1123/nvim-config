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
          "--background-index",          -- File indexing in the background
          "--clang-tidy",                -- Enable linter diagnostics
          "--header-insertion=iwyu",     -- Include What You Use (auto-imports headers)
          "--completion-style=detailed", -- Richer details in completion menus
          "--function-arg-placeholders", -- Snippet placeholders for function arguments
          "--fallback-style=llvm",       -- Default formatting fallback
          "-I/usr/include/gstreamer-1.0/**",
          "-I/usr/include/glib-2.0/**",
          "-I/usr/lib/x86_64-linux-gnu/glib-2.0/include/**",
          "-I/home/ashish-shevale/Android/Sdk/ndk/28.2.13676358/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include",
          "-I/home/ashish-shevale/flutter/bin/cache/dart-sdk/include",

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
