return {
  "tsakirist/telescope-lazy.nvim",
  config = function()
    LazyVim.on_load("telescope.nvim", function()
      require("telescope").load_extension("lazy")
    end)
  end,
  keys = {
    { "<leader>sP", "<cmd>Telescope lazy<CR>", desc = "Plugins (Lazy)" },
  },
}
