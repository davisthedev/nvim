return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        spec = {
            { "<leader>c", group = "code" },
            { "<leader>g", group = "git" },
            { "<leader>s", group = "search" },
            { "<leader>p", group = "project" },
            { "<leader>t", group = "toggle" },
            { "<leader>w", group = "window" },
            { "<leader>x", group = "diagnostics" },
            { "<leader>9", group = "99 ai" },
        },
    },
}
