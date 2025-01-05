return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

  },
  config = function()
    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      automatic_installation = true,
      ensure_installed = {
        "gopls",
        "golangci_lint_ls",
        "lua_ls",
        "rust_analyzer",
        "bashls",
        "clangd",
        "cssls",
        "htmx",
        "jsonls",
        "ts_ls",
        "powershell_es",
        "sqlls",
        "svelte",
        "tailwindcss",
        "volar",
        "yamlls",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,

        ["clangd"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.clangd.setup {
            capabilities = capabilities,
            cmd = { "clangd", "--background-index", "--suggest-missing-includes" },
            offsetEncoding = { "utf-8" },
          }
        end,

        ['gopls'] = function()
          local lspconfig = require("lspconfig")
          lspconfig.gopls.setup {
            capabilities = capabilities,
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" }
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
                  globals = { "vim", "it", "describe", "before_each", "after_each" },
                }
              }
            }
          }
        end,

        ["svelte"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.svelte.setup {
            capabilities = capabilities
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

        ["zls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.zls.setup {
            capabilities = capabilities,
          }
        end,
      }
    })


    local lspconfig = require("lspconfig")
    lspconfig.nushell.setup {
      capabilities = capabilities,
      cmd = { "nu", "--lsp" }
    }
  end
}
