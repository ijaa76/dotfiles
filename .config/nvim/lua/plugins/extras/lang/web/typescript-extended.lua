local ts_server_activated = true -- Change this variable to false if you want to use typescript-tools instead of lspconfig tsserver implementation
local ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" }

local inlayHints = {
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayVariableTypeHintsWhenTypeMatchesName = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

local source_action = function(name)
  return function()
    vim.lsp.buf.code_action({
      apply = true,
      context = {
        only = { string.format("source.%s.ts", name) },
        diagnostics = {},
      },
    })
  end
end

return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "plugins.extras.lang.json-extended" },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "deno" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
              require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
              vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            end,
          },
          enabled = ts_server_activated,
          init_options = {
            preferences = {
              disableSuggestions = true,
            },
          },
          settings = {
            typescript = {
              inlayHints = inlayHints,
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
              },
            },
            javascript = {
              inlayHints = inlayHints,
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
              },
            },
          },
          keys = {
            {
              "<leader>cO",
              source_action("organizeImports"),
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              source_action("addMissingImports"),
              desc = "Add Missing Imports",
            },
            {
              "<leader>cR",
              source_action("removeUnused"),
              desc = "Remove Unused Imports",
            },
          },
        },
        denols = {},
      },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    enabled = not ts_server_activated,
    ft = ft,
    opts = {
      cmd = { "typescript-language-server", "--stdio" },
      handlers = {
        ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
          require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
          vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
        end,
      },
      settings = {
        code_lens = "all",
        expose_as_code_action = "all",
        tsserver_plugins = {
          "@styled/typescript-styled-plugin",
        },
        tsserver_file_preferences = {
          completions = {
            completeFunctionCalls = true,
          },
          init_options = {
            preferences = {
              disableSuggestions = true,
            },
          },
          includeInlayParameterNameHints = "all",
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
    keys = {
      { "<leader>cO", ft = ft, "<cmd>TSToolsOrganizeImports<cr>", desc = "Organize Imports" },
      { "<leader>cR", ft = ft, "<cmd>TSToolsRemoveUnusedImports<cr>", desc = "Remove Unused Imports" },
      { "<leader>cM", ft = ft, "<cmd>TSToolsAddMissingImports<cr>", desc = "Add Missing Imports" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "javascript",
        "jsdoc",
      })
    end,
  },
  {
    "dmmulroy/tsc.nvim",
    opts = {
      auto_start_watch_mode = false,
      use_trouble_qflist = true,
      flags = {
        watch = false,
      },
    },
    keys = {
      { "<leader>ct", ft = { "typescript", "typescriptreact" }, "<cmd>TSC<cr>", desc = "Type Check" },
      { "<leader>xy", ft = { "typescript", "typescriptreact" }, "<cmd>TSCOpen<cr>", desc = "Type Check Quickfix" },
    },
    ft = {
      "typescript",
      "typescriptreact",
    },
    cmd = {
      "TSC",
      "TSCOpen",
      "TSCClose",
    },
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    opts = {},
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-jest",
      "adrigzr/neotest-mocha",
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        ["neotest-jest"] = {
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
        ["neotest-mocha"] = {
          command = "npm test --",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
        ["neotest-vitest"] = {},
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>tw", function() require('neotest').run.run({ jestCommand = 'jest --watch ' }) end, desc = "Run Watch" },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "react",
        "typescript",
      },
    },
  },
}
