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
        ensure_installed = { "ts_ls", "rust_analyzer", "clangd", "dartls" }, 
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
      vim.lsp.config("dartls", {
        cmd = { "dart", "language-server", "--protocol=lsp" },
        -- ADD THIS INITIATION BLOCK BELOW
        init_options = {
          closingLabels = true,     -- Natively draws faint Flutter block ends
          flutterOutline = true,    -- Optimizes performance for component rendering
          outline = true,
        },
        on_attach = function(client, bufnr)
          -- Hook into the native Dart closing labels notification
          vim.api.nvim_create_autocmd("User", {
            pattern = "DartDiagnosticsLoaded",
            callback = function()
              -- This forces the LSP to send full widget names instead of short tokens
            end,
          })
          
          -- Support standard native LSP rendering for closing labels
          if client.server_capabilities.experimental and client.server_capabilities.experimental.closingLabels then
            local namespace = vim.api.nvim_create_namespace("dart_closing_labels")
            vim.lsp.handlers["dart/textDocument/publishClosingLabels"] = function(_, result, ctx)
              local uri = result.uri
              if uri ~= vim.uri_from_bufnr(bufnr) then return end
              
              vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
              local labels = result.labels
              for _, label in ipairs(labels) do
                local line = label.range["end"].line
                -- This prints the actual text provided by Flutter (e.g., "↳ Column", "↳ Container")
                vim.api.nvim_buf_set_extmark(bufnr, namespace, line, 0, {
                  virt_text = { { " ↳ " .. label.label, "ContextVt" } },
                  virt_text_pos = "eol",
                })
              end
            end
          end
        end,
      })
      vim.lsp.enable("clangd")
      vim.lsp.enable("dartls")
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
      completion = {
        trigger = {
          show_on_trigger_character = true,
        },
        menu = {
          auto_show = function (ctx)
            return ctx.mode ~= "cmdline"
          end
        },
      },
      signature = {
        enabled = true,
        trigger = {
          show_on_keyboard = false,
        },
      },
    },
  }
}
