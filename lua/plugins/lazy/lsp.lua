return {
    {
    "neovim/nvim-lspconfig",
    dependencies = {
        "saghen/blink.cmp",
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "j-hui/fidget.nvim",
    },
    config = function()
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        require("fidget").setup({})
        require("mason").setup()
        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettierd",
                "stylua",
                "gofumpt",
                "goimports",
            },
        })
        require("mason-lspconfig").setup({
            automatic_installation = true,
            ensure_installed = {
                "lua_ls",
                "gopls",
                "ts_ls",
                "terraformls",
                "rust_analyzer",
                "clangd",
                "svelte",
            },
            handlers = {
                function(server_name)
                    local lspconfig  = require("lspconfig")
                    lspconfig[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,

                ["terraformls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.terraformls.setup {
                        capabilities = capabilities,
                        single_file_support = true,
                        init_options = {
                            ignoreSingleFileWarning = true,
                        },
                    }
                end,

                ["ts_ls"] = function()
                    local lspconfig = require("lspconfig")
                    local mason_registry = require("mason-registry")
                    local ok, pkg = pcall(mason_registry.get_package, 'vue-language-server')
                    local vue_language_server_path = ok and pkg:get_install_path() ..
                        '/node_modules/@vue/language-server' or nil
                    local init_options = {}
                    if vue_language_server_path then
                        init_options.plugins = {
                          {
                            name = "@vue/typescript-plugin",
                            location = vue_language_server_path,
                            languages = { "javascript", "typescript", "vue" },
                          }
                        }
                    end
                    lspconfig.ts_ls.setup {
                      capabilities = capabilities,
                      init_options = init_options,
                      filetypes = { "javascript", "typescript", "vue", "svelte" },
                    }
                  end,
            }
        })
    end,
    }
}