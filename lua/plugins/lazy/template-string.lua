return {
    {
        "axelvc/template-string.nvim",
        config = function()
            require("template-string").setup {
                filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue", "svelte" },
                remove_template_string = true,
                restore_quotes = {
                    normal = [[']],
                    jsx = [["]],
                },
            }
        end,
        event = "InsertEnter",
        ft = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue", "svelte" },
    },
}
