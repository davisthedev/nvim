return {
	{
   "folke/tokyonight.nvim",
   lazy = false,
   priority = 1000,
   config = function()
require('tokyonight').setup({
    style = "moon",
    transparent = false,
    terminal_colors = true,
    styles = {
        comments = { italic = false },
        keywords = { italic = false },
        sidebars = "dark",
        floats = "dark",
    },
}) 
   end,
   init = function()
     vim.cmd [[colorscheme tokyonight-moon]]
   end,
	},
}
