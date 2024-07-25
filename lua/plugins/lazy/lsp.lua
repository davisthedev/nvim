return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities())

    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
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
        "tsserver",
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

        ["tsserver"] = function()
          local lspconfig = require("lspconfig")
          local root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")
          local mason_registry = require("mason-registry")
          local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
              '/node_modules/@vue/language-server'
          lspconfig.tsserver.setup {
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

        ["svelte"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.svelte.setup {
            capabilities = capabilities
          }
        end,
      }
    })


    local lspconfig = require("lspconfig")
    lspconfig.nushell.setup {
      capabilities = capabilities,
      cmd = { "nu", "--lsp" }
    }

    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local kind_icons = {
      Text = "",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰇽",
      Variable = "󰂡",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲",
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'path',    keyword_length = 3 },
      }, {
        { name = 'buffer', keyword_length = 3 },
      }),
      formatting = {
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
          -- Source
          vim_item.menu = ({
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            nvim_lua = "[Lua]",
            latex_symbols = "[LaTeX]",
          })[entry.source.name]
          return vim_item
        end
      },
      experimental = {
        ghost_text = true
      },
    })

    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )

    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end
}
