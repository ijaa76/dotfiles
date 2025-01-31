local keys = {}

-- stylua: ignore start
for i = 1, 9 do
  table.insert(keys, { "<leader>m" .. i, "<cmd>Grapple select index=" .. i .. "<CR>", desc = "File " .. i })
end

table.insert(keys, { "<leader>ma", "<cmd>Grapple tag<CR>", desc = "Add Mark" })
table.insert(keys, { "<leader>mm", "<cmd>Grapple toggle_tags<CR>", desc = "Marks" })
table.insert(keys, { "<leader>mt", "<cmd>Telescope grapple tags<CR>", desc = "Marks (Telescope)" })
table.insert(keys, { "<leader>mC", "<cmd>Grapple reset<CR>", desc = "Clear all Marks" })
table.insert(keys, { "<leader>mc", "<cmd>Grapple untag<CR>", desc = "Clear Current Mark" })
table.insert(keys, { "<leader>ms", "<cmd>Grapple toggle_scopes<CR>", desc = "Scopes" })
table.insert(keys, { "<leader>mS", "<cmd>Grapple toggle_loaded<CR>", desc = "Loaded Scopes" })

table.insert(keys, { "]k", "<cmd>Grapple cycle forward<CR>", desc = "Next Mark" })
table.insert(keys, { "[k", "<cmd>Grapple cycle backward<CR>", desc = "Prev Mark" })

table.insert(keys, { "<C-A-l>", "<cmd>Grapple cycle forward<CR>", desc = "Next Mark" })
table.insert(keys, { "<C-A-h>", "<cmd>Grapple cycle backward<CR>", desc = "Prev Mark" })
-- stylua: ignore end

return {
  {
    "cbochs/grapple.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd = { "Grapple" },
    keys = keys,
    config = function()
      require("grapple").setup()
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").load_extension("grapple")
      end)
    end,
  },
  {
    "goolord/alpha-nvim",
    optional = true,
    opts = function(_, dashboard)
      local button = dashboard.button("m", "󰛢 " .. " Marks", "<cmd>Grapple toggle_tags<CR>")
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
      table.insert(dashboard.section.buttons.val, 5, button)
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    optional = true,
    opts = function(_, opts)
      local grapple = {
        action = "Grapple toggle_tags",
        desc = " Marks",
        icon = "󰛢 ",
        key = "m",
      }

      grapple.desc = grapple.desc .. string.rep(" ", 43 - #grapple.desc)
      grapple.key_format = "  %s"

      table.insert(opts.config.center, 5, grapple)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.sections.lualine_c, { require("grapple").statusline, cond = require("grapple").exists })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>m"] = { name = "󰛢 marks" },
      },
    },
  },
}
