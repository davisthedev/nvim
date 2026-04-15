return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
        { "<leader>gg", function()
            require("toggleterm.terminal").Terminal:new({
                cmd = "lazygit",
                direction = "float",
                hidden = true,
            }):toggle()
        end, desc = "Lazygit" },
        { "<leader>gd", function()
            require("toggleterm.terminal").Terminal:new({
                cmd = "lazydocker",
                direction = "float",
                hidden = true,
            }):toggle()
        end, desc = "Lazydocker" },
    },
    opts = {
        size = 20,
        open_mapping = [[<C-\>]],
        direction = "horizontal",
        float_opts = {
            border = "curved",
        },
    },
}
