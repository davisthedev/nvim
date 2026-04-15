return {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
        { "<leader>sr", function() require("grug-far").open() end, desc = "Search and replace" },
        { "<leader>sr", function()
            require("grug-far").with_visual_selection()
        end, mode = "v", desc = "Search and replace selection" },
    },
    opts = {},
}
