return {
    {
    "neovim/nvim-lspconfig",
    dependencies = {
        "saghen/blink.cmp",
        "folke/lazydev.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } 
            },
            },
        },
    },
    config = function()
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        local lsp_config = require("lspconfig")
        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "gopls",
                "ts_ls",
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

                ["ts_ls"] = function()
                    local lspconfig = require("lspconfig")
                    local root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")
                    local mason_registry = require("mason-registry")
                    local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
                        '/node_modules/@vue/language-server'
                    lspconfig.ts_ls.setup {
                      capabilities = capabilities,
                      init_options = {
                        plugins = {
                          {
                            name = "@vue/typescript-plugin",
                            location = vue_language_server_path,
                            languages = { "javascript", "typescript", "vue" },
                          }
                        }
                      },
                      filetypes = { "javascript", "typescript", "vue", "svelte" },
                    }
                  end,

                ["volar"] = function()
                    local lspconfig = require("lspconfig")
                    local root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")
                    lspconfig.volar.setup {
                        capabilities = capabilities,
                        filetypes = { "vue" },
                        root_dir = root_dir
                    }
                end,
            }
        })
    end,
    }
}