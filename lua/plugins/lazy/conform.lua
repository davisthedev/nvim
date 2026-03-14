return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
        { "<leader>f", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
    },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            vue = { "prettierd", "prettier", stop_after_first = true },
            svelte = { "prettierd", "prettier", stop_after_first = true },
            css = { "prettierd", "prettier", stop_after_first = true },
            html = { "prettierd", "prettier", stop_after_first = true },
            json = { "prettierd", "prettier", stop_after_first = true },
            yaml = { "prettierd", "prettier", stop_after_first = true },
            markdown = { "prettierd", "prettier", stop_after_first = true },
            go = { "gofumpt", "goimports" },
            rust = { "rustfmt" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            terraform = { "terraform_fmt" },
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
        },
    },
}
