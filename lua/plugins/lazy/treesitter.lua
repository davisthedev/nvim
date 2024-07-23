return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            local install = require("nvim-treesitter.install")

            install.compilers = { "clang" }

            configs.setup({
                ensure_installed = {
                    "c", "lua", "vim", "vimdoc", "javascript", "html",
                    "json", "typescript", "css", "yaml", "svelte", "vue",
                    "bash", "rust", "go", "markdown"
                },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
        dependencies = {
            { "nushell/tree-sitter-nu" },
        }
    }
}
