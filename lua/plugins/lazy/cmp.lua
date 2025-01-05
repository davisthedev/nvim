return {
{
    "hrsh7th/nvim-cmp",
    event = 'InsertEnter',
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },

    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
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
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
            ['<C-l>'] = cmp.mapping(function()
                if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
                end
            end, { 'i', 's' }),
            ['<C-h>'] = cmp.mapping(function()
                if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
                end
            end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
            { name = 'lazydev' },
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
end,
}
}