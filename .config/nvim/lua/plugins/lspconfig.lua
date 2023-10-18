return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "gd", "<CMD>Glance definitions<CR>", desc = "Goto definition" }
      keys[#keys + 1] = { "gr", "<CMD>Glance references<CR>", desc = "References" }
      keys[#keys + 1] = { "gy", "<CMD>Glance type_definitions<CR>", desc = "Goto t[y]pe definitions" }
      keys[#keys + 1] = { "gI", "<CMD>Glance implementations<CR>", desc = "Goto implementations" }
      keys[#keys + 1] = { "<leader>ca", require("actions-preview").code_actions, desc = "Code Action Preview" }
    end,
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        virtual_text = {
          float = {
            border = {
              { "┌", "FloatBorder" },
              { "─", "FloatBorder" },
              { "┐", "FloatBorder" },
              { "│", "FloatBorder" },
              { "┘", "FloatBorder" },
              { "─", "FloatBorder" },
              { "└", "FloatBorder" },
              { "│", "FloatBorder" },
            },
          },
        },
      },
    },
  },
}
