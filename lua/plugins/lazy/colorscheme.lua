return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = true,
    config = function()
      require("catppuccin").setup()
    end,
    init = function()
      vim.cmd [[colorscheme catppuccin-macchiato]]
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      require('tokyonight').setup({
        style = "moon",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          -- sidebars = "transparent",
          -- floats = "transparent",
        },
      })
    end,
    init = function()
      vim.cmd [[colorscheme tokyonight-moon]]
    end,
  },
}
