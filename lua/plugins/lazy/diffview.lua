return {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
        { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Git diff view" },
        { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git file history" },
    },
    opts = {},
}
