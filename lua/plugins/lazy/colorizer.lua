return {
    {
        "nvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup {
                filetypes = { "*", "!packer" },
                user_default_options = {
                    tailwind = "lsp",
                    names = false,
                    sass = { enable = true, parsers = { css = true } },
                },
            }
        end,
    }
}
