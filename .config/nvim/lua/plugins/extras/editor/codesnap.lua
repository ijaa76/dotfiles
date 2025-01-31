return {
  "mistricky/codesnap.nvim",
  build = "make",
  cmd = { "CodeSnap", "CodeSnapSave" },
  keys = {
    { "<leader>cs", mode = "v", ":'<,'>CodeSnap<cr>", desc = "Screenshot (Clipboard)" },
    { "<leader>cS", mode = "v", ":'<,'>CodeSnapSave<cr>", desc = "Screenshot (Save)" },
  },
  cond = vim.env.KITTY_SCROLLBACK_NVIM == nil,
  opts = {
    save_path = os.getenv("XDG_SCREENSHOTS_HOME") .. "/Codigo",
    title = "CodeSnap.nvim",
    code_font_family = "JetBrainsMono Nerd Font",
    watermark_font_family = "JetBrainsMono Nerd Font",
    watermark = "",
    bg_theme = "summer",
  },
}
