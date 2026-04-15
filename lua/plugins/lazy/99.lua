return {
    "ThePrimeagen/99",
    keys = {
        { "<leader>9v", function() require("99").visual() end, mode = "v", desc = "99: visual prompt" },
        { "<leader>9x", function() require("99").stop_all_requests() end, desc = "99: stop requests" },
        { "<leader>9s", function() require("99").search() end, desc = "99: search" },
    },
    config = function()
        require("99").setup({
            tmp_dir = "./tmp",
            md_files = { "AGENT.md" },
        })
    end,
}
